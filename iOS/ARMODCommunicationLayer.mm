//
//  ARMODCommunicationLayer.m
//  ARMOD
//
//  Created by phantomsxr on 2021/5/26.
//  Copyright © 2020 phantomsxr.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ARMODCommunicationLayer.h"
@implementation ARMOD
id<NativeCallsProtocol> ncp;
NSDictionary* appLaunchOpts;

static ARMOD *sharedInstance;
static UIWindow *originWindow;

// MARK: - Methods Key
char const *initApp                         = "InitSDK";
char const *dispose                         = "Dispose";
char const *cleanCache                      = "CleanCache";
char const *fetchProject                    = "LaunchXRQuery";
char const *fetchProjectByImage             = "LaunchARScanner";
char const *setUIInterfaceOrientation       = "SetUIInterfaceOrientation";
char const *continueToDownloadARExperience  = "ContinueToDownloadAssets";

char const *appDelegate                     = "AppDelegate";

// MARK: - Fields Key
char const *messageReceiveObjecgtName       = "EntryPoint";
char const *dataBundleId                    = "com.unity3d.framework";
NSString *frameworkLibAPI                   = @"FrameworkLibAPI";
NSString *bundlePathStr                     = @"/Frameworks/UnityFramework.framework";

// MARK: - Notification
- (void)unityDidUnload:(NSNotification *)notification{
    
    [[self ufw] unregisterFrameworkListener:self];
    [self setUfw:nil];
    [originWindow makeKeyAndVisible];
}


/*!
@Discussion Load Unity Framework
*/
UnityFramework* UnityFrameworkLoad()
{
    NSString* bundlePath = nil;
    bundlePath = [[NSBundle mainBundle] bundlePath];
    bundlePath = [bundlePath stringByAppendingString: bundlePathStr];
    
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

/*!
@Discussion Check current armod sdk is initialized
*/
- (bool)armodIsInitialized { return [self ufw] && [[self ufw] appController]; }


/*!
@Discussion Init ARMOD SDK Module
*/
- (void)initARMODModule{
    @try {
        if([self armodIsInitialized]) {
            return;
        }
    
        [self setUfw: UnityFrameworkLoad()];
    
        [[self ufw] setDataBundleId: dataBundleId];
    
    
        [[self ufw] registerFrameworkListener: self];
        
        if (ncp!=nil) {
            [NSClassFromString(frameworkLibAPI) registerAPIforNativeCalls:ncp];
        }
        
       
        
        [[self ufw] runEmbeddedWithArgc: self.selfgArgc argv: self.selfgArgv appLaunchOpts: appLaunchOpts];
        
        // set quit handler to change default behavior of exit app
        [[self ufw] appController].quitHandler = ^(){ NSLog(@"AppController.quitHandler called"); };

        if (@available(iOS 13.0, *)) {
            
            if(originWindow.windowScene != nil){
                [[[[self ufw] appController]  window] setWindowScene:originWindow.windowScene];
                [[[[self ufw] appController]  window] addSubview:self.ufw.appController.rootView];
                [[[[self ufw] appController] window] makeKeyAndVisible];
                [[[[[[self ufw] appController] window] rootViewController] view] setNeedsLayout];
            }
        }
    }
    @catch (NSException *e) {
        NSLog(@"%@",e);
    }
}


/*!
@Discussion Call method to ARMOD SDK
@param methodName Method name
@param data method paramaters,It's a string
*/
- (void)callSDKMethod:(char const*) methodName addData:(char const*)data{
    if([self armodIsInitialized]){
        [[self ufw] sendMessageToGOWithName:messageReceiveObjecgtName functionName:methodName  message:data];
    }else{
        NSLog(@"You can not send anything message to AR,Because SDK is not initialize");
    }
}


/*!
@Discussion Unload the ARMOD Window
*/
- (void)unloadARMODWindow{
    if([self armodIsInitialized]){
        [self callSDKMethod:dispose addData:""];
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.125 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////            [UnityFrameworkLoad() unloadApplication];
//            [[self ufw] unregisterFrameworkListener:self];
//            [self setUfw:nil];
//            [originWindow makeKeyAndVisible];
//        });
    }
}

/*!
@Discussion Display the ARMOD Window
*/
- (void)showARMODWindow{
    if([self armodIsInitialized]){
        [[self ufw] showUnityWindow];
    }else{
        NSLog(@"ARMOD is not initialized ,Initialize ARMOD first");
    }
    
}

/*!
@Discussion Register callback for app
*/
- (void) registerAPIforNativeCalls:(id<NativeCallsProtocol>) api{
    ncp = api;
}

// MARK: - ARMOD Public Native APIs
+ (id)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{sharedInstance = [[self alloc] init];});
    return sharedInstance;
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

- (void)initARMOD:(NSString*) appconfigure completed:(void (^)())completed{
    [self initARMODModule];
    [self callSDKMethod:initApp addData:[appconfigure UTF8String]];
   completed();
}

/*!
@Discussion Query the AR Experience project by project uid
*/
- (void)fetchProject:(NSString*) projecetUid{
    //Since the initialization decision is performed asynchronously, the query item needs to be delayed
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.125 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        const char *converted_projectUid = [projecetUid UTF8String];
        [self callSDKMethod:fetchProject addData:converted_projectUid];
    });
}

/*!
 @Discussion Query the XR Experience from local
 */
- (void)fetchProjectByName:(NSString*) projectName{
    //Since the initialization decision is performed asynchronously, the query item needs to be delayed
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.125 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        const char *converted_projectName = [projectName UTF8String];
        [self callSDKMethod:"LaunchAROffline" addData:converted_projectName];
    });
}

/*!
@Discussion Query the AR Experience project by image
*/
- (void)fetchProjectByImage{
    //Since the initialization decision is performed asynchronously, the query item needs to be delayed
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.125 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self callSDKMethod:fetchProjectByImage addData:""];
    });
}

/*!
@Discussion Get current view controller
*/
- (UIViewController*)getARMODController{
    return [[[self ufw] appController] rootViewController];
}

/*!
@Discussion Load and show ARMOD view
*/
- (void)loadAndShowARMODView{
    if(![self armodIsInitialized]){
        [self initARMODModule];
    }
    
    [self showARMODWindow];
}

/*!
@Discussion Set current App orientation
*/
- (void)setUIInterfaceOrientation:(UIInterfaceOrientation)orientation{
    NSString *orientationValue = [NSString stringWithFormat:@"%d",(int)orientation];
    const char *data = [orientationValue UTF8String];
    [self callSDKMethod:setUIInterfaceOrientation addData:data];
}

/*!
@Discussion Unload and hide ARMOD view
*/
- (void)unloadAndHideARMODView{
    if([self armodIsInitialized]){
        [self unloadARMODWindow];
    }else{
        NSLog(@"ARMOD is not initialized ,Initialize ARMOD first");
    }
}

/*!
@Discussion Clean the ARMOD's AR experience assets
*/
- (void)cleanCache{
    if([self armodIsInitialized]){
        [self callSDKMethod:cleanCache addData:""];
    }
}

/*!
@Discussion Continue to download
*/
- (void)continueToDownloadARExperience{
    if([self armodIsInitialized]){
        [self callSDKMethod:continueToDownloadARExperience addData:""];
    }
}

/*!
 @Discussion Send a message to XRMOD Engine.
 */
- (void)sendMessageToXRMODEngine:(NSString *)data{
    if([self armodIsInitialized]){
        const char *stringToUnity = [data UTF8String];
        [self callSDKMethod:onMessageReceived addData:stringToUnity];
    }
}
// MARK: - Application Hook

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
@end

