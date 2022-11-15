//
//  ARMODCommunicationLayer.h
//  ARMOD
//
//  Created by phantomsxr on 2021/5/26.
//  Copyright © 2020 phantomsxr.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <UnityFramework/UnityFramework.h>
#import <UnityFramework/NativeCallProxy.h>
@interface ARMOD : UIResponder<UIApplicationDelegate, UnityFrameworkListener>
@property UnityFramework* ufw;
@property int selfgArgc;
@property char** selfgArgv;

+(id) sharedInstance;

// MARK: - Notification
- (void)unityDidUnload:(NSNotification*)notification;


// MARK: - ARMOD Native Public APIs
/*!
 @Discussion Link to the application's Window
 @param nativeWindow UIWindow of its own app
 */
- (void) connectARMOD:(UIWindow*) nativeWindow;


/*!
 @Discussion Launch options for linked apps
 @param applaunchOpts Launch options
 */
- (void) connectLaunchOpts:(NSDictionary*) applaunchOpts;

/*!
 @Discussion Register a custom-implemented monitoring protocol. Used to monitor and execute messages sent by the SDK, for example:
 1. When starting to load AR creative interactive experience content, `addLoadingOverlay` will be executed;
 2. After loading, it will execute `removeLoadingOverlay`;
 3. Execute `updateLoadingProgress` while loading;
 4. Execute `notSupportARMOD` when the device does not support AR;
 5. SDK error, will execute `showAlertConfirmation` when the project is inquired
 Call it at any time after ARMOD is loaded to set the object that implements the NativeCallsProtocol method
 @param api Custom monitoring protocol object
 */
- (void) registerAPIforNativeCalls:(id<NativeCallsProtocol>) api;

/*!
 @Discussion Use the configuration parameters in the main method of the application itself
 @param gArgc Consistent with the main function
 @param gArgv Consistent with the main function
 */
- (void) connectArgcArgv:(int)gArgc setgArgv:(char **) gArgv;

/*!
 @Discussion Use this method to initialize the SDK
 @param appconfigure SDK configuration
 @param completed After initialization execute.
 */
- (void) initARMOD:(NSString*) appconfigure completed:(void (^)(void)) completed;


/*!
 @Discussion Query AR projects by using the unique Id of the project
 @param projecetUid Project unique Id
 */
- (void) fetchProject:(NSString*) projecetUid;

/*!
 @Discussion Query AR projects by using the unique Id of the project
 @param projectName Project unique name
 */
- (void)fetchProjectByName:(NSString*) projectName;

/*!
 @Discussion Query AR projects through pictures
 */
- (void) fetchProjectByImage;

/*!
 @Discussion Show the AR window
 */
- (void) loadAndShowARMODView;

/*!
 @Discussion Remove and hide the current AR window
 */
- (void) unloadAndHideARMODView;

/*!
 @Discussion Get the Controller of the AR view
 */
- (UIViewController*) getARMODController;

/*!
 @Discussion Set the direction of the AR window
 @param orientation  To adapt the direction, please select according to UIInterfaceOrientation
 */
- (void) setUIInterfaceOrientation:(UIInterfaceOrientation) orientation;

/*!
 @Discussion Clear all download caches
 */
- (void)cleanCache;

/*!
 @Discussion Continue to download the AR experience
 */
- (void)continueToDownloadARExperience;

/*!
 @Discussion Send data to XR-Experience
 @param data Will send data
 */
- (void)sendMessageToXRMODEngine:(NSString *)data;
@end
