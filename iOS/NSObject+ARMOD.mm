//
//  NSObject+ARMOD.m
//  ARMODLib
//
//  Created by NSWell on 2020/10/22.
//

#import "NSObject+ARMOD.h"

@implementation ARMOD

NSDictionary* appLaunchOpts;
static ARMOD *sharedInstance;


static UIWindow *originWindow;

char const *initApp="InitSDK";
char const *fetchProject= "LaunchARQuery";
char const *fetchProjectByImage= "LaunchARScanner";
char const *appDelegate = "AppDelegate";
char const *dataBundleId= "com.unity3d.framework";

id<NativeCallsProtocol> ncp;
NSString *frameworkLibAPI = @"FrameworkLibAPI";
NSString *bundlePath = @"/Frameworks/UnityFramework.framework";


UnityFramework* UnityFrameworkLoad()
{
    NSString* bundlePath = nil;
    bundlePath = [[NSBundle mainBundle] bundlePath];
    bundlePath = [bundlePath stringByAppendingString: @"/Frameworks/UnityFramework.framework"];
    
    NSBundle* bundle = [NSBundle bundleWithPath: bundlePath];
    if ([bundle isLoaded] == false) [bundle load];
    
    UnityFramework* ufw = [bundle.principalClass getInstance];
    if (![ufw appController])
    {
        // unity is not initialized
        [ufw setExecuteHeader: &_mh_execute_header];
    }
    return ufw;
}

- (bool)armodIsInitialized { return [self ufw] && [[self ufw] appController]; }


/// Init ARMOD SDK Module
- (void)initARMODModule{
    @try {
        if([self armodIsInitialized]) {
            NSLog(@"ARMOD already initialized Unload ARMOD first");
            return;
        }
    

        [self setUfw: UnityFrameworkLoad()];
        
        [[self ufw] setDataBundleId: "com.unity3d.framework"];
        

        
        [[self ufw] registerFrameworkListener: self];
        
        if (ncp!=nil) {
            [NSClassFromString(@"FrameworkLibAPI") registerAPIforNativeCalls:ncp];
        }
        
        [[self ufw] runEmbeddedWithArgc: self.selfgArgc argv: self.selfgArgv appLaunchOpts: appLaunchOpts];
    
        
        // set quit handler to change default behavior of exit app
        [[self ufw] appController].quitHandler = ^(){ NSLog(@"AppController.quitHandler called"); };
    
        
        if (@available(iOS 13.0, *)) {
            if(originWindow.windowScene != nil){
                [[[[self ufw] appController]  window] setWindowScene:originWindow.windowScene];
                [[[[self ufw] appController] window] makeKeyAndVisible];
            }
        }
        NSLog(@"SDK Initialized");
    }
    @catch (NSException *e) {
        NSLog(@"%@",e);
    }
}


/// Call method to ARMOD SDK
/// @param methodName Method name
/// @param data method paramaters,It's a string
- (void)callSDKMethod:(char const*) methodName addData:(char const*)data{
    if([self armodIsInitialized]){
        [[self ufw] sendMessageToGOWithName:"EntryPoint" functionName:methodName  message:data];
    }else{
        NSLog(@"You can not send anything message to AR,Because SDK is not initialize");
    }
}


/// unload the ARMOD Window
- (void)unloadARMODWindow{
    if([self armodIsInitialized]){
//        [[self ufw] unloadApplication];
        [self callSDKMethod:"Dispose" addData:""];
    }
}

/// Display the ARMOD Window
- (void)showARMODWindow{
    if([self armodIsInitialized]){
        
        [[self ufw] showUnityWindow];
    }else{
        NSLog(@"ARMOD is not initialized ,Initialize ARMOD first");
    }
}

- (void)cleanCache{
    if([self armodIsInitialized]){
        [self callSDKMethod:"CleanCache" addData:""];
    }
}


/// Execute after ARMOD and Unity unload
/// @param notification notification description
- (void)unityDidUnload:(NSNotification *)notification{
    [[self ufw] unregisterFrameworkListener:self];
    [self setUfw:nil];
    [originWindow makeKeyAndVisible];
}

- (void)unityDidQuit:(NSNotification*)notification{
    [[self ufw] unregisterFrameworkListener: self];
    [self setUfw: nil];
    [originWindow makeKeyAndVisible];
}

- (void) registerAPIforNativeCalls:(id<NativeCallsProtocol>) api{
    ncp = api;
}

// MARK: - API
+ (id)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(void)applicationWillResignActive:(UIApplication *)application{
    if( [self armodIsInitialized]){
        [[[self ufw] appController] applicationWillResignActive:application];
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application{
    if( [sharedInstance armodIsInitialized]){
        [[[self ufw] appController] applicationDidEnterBackground:application];
    }
}


- (void)applicationWillEnterForeground:(UIApplication *)application{
    if( [self armodIsInitialized]){
        [[[self ufw] appController] applicationWillEnterForeground:application];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application{
    if( [self armodIsInitialized]){
        [[[self ufw] appController] applicationDidBecomeActive:application];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application{
    if( [self armodIsInitialized]){
        [[[self ufw] appController] applicationWillTerminate:application];
    }
}


- (void) connectArgcArgv:(int)gArgc setgArgv:(char **) gArgv{
    [self setSelfgArgc:gArgc];
    [self setSelfgArgv:gArgv];
}

- (void) connectARMOD:(UIWindow*) nativeWindow{
    originWindow = nativeWindow;
}


- (void) connectLaunchOpts:(NSDictionary*) applaunchOpts{
    appLaunchOpts = applaunchOpts;
}


- (void)initARMOD:(NSString*) appconfigure{
    [self initARMODModule];
    [self callSDKMethod:initApp addData:[appconfigure UTF8String]];
}

- (void)fetchProject:(NSString*) projecetUid{
    //Since the initialization decision is performed asynchronously, the query item needs to be delayed
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.125 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        const char *converted_projectUid = [projecetUid UTF8String];
        [self callSDKMethod:fetchProject addData:converted_projectUid];
    });
}


- (void)fetchProjectByImage{
    //Since the initialization decision is performed asynchronously, the query item needs to be delayed
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.125 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self callSDKMethod:fetchProjectByImage addData:""];
        
    });
}


- (UIViewController*)getARMODController{
    return [[[self ufw] appController] rootViewController];
}


- (void)loadAndShowARMODView{
    if(![self armodIsInitialized]){
        [self initARMODModule];
    }
    
    [self showARMODWindow];
}


- (void)setUIInterfaceOrientation:(UIInterfaceOrientation)orientation{
    NSString *orientationValue = [NSString stringWithFormat:@"%d",(int)orientation];
    const char *data = [orientationValue UTF8String];
    [self callSDKMethod:"SetUIInterfaceOrientation" addData:data];
}

- (void)unloadAndHideARMODView{
    NSLog(@"Unload and hide armod view executed!");
    if([self armodIsInitialized]){
        [self unloadARMODWindow];
    }else{
        NSLog(@"ARMOD is not initialized ,Initialize ARMOD first");
    }
}
@end

