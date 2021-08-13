# Version 0.0.3
## Add
- New programming work follow.
  - MonoBinder Developers will be allowed to perform visual configuration through the Inspector panel.
  - Quickly create AR experience through templates
    
- LightProbs APIs support
- Add local packages
- Add default Event System to main scene
- Add FaceMesh state
- Add Face Mesh prefab
- Add Auto convert to MonoBinder
- Add convert to MonoBinder  dialog


## Changed
- Rename development kit version to v0.0.3
- Changed ImageDebug [Resolution](https://www.teambition.com/task/610a04401c41f90044134265)
- Changed `Focus Slam` Not send any notification to AR-Experience on Unity Editor
- Update Unity editor version to 2020.3.14f1
- Obsolete the Anchor `Stick type enum`
- Obsolete the Anchor `ByScreen action`
- Change face mesh algorithm struct
- Disable obfuscate plugin
- Change AR-MOD API default constructor to new constructor, `New ARMODAPI()` -> `New ARMODAPI(#PROJECT_NAME#)`


## Fixed
- Core:Fix ARMOD API clr binding
- Core:Fix Call error again after releasing the ActionNotificationCenter
- Core:Fix https://www.teambition.com/task/6102c0d754ac40004408d620
- Android:Fix Ingamedebug plugin error
- iOS:Fix defines 

# Version 0.0.2
## Add
- New API Exit ARMOD callback added
- Camera Stack API added
- Device vibration API added
- Networking.DownloadHandler API added
- Set Unity UGUI Canvas world camera api added
- Access in-depth information
- Access Camera frame
- Support secondary development based on Unity
- ARWorld Scale
- Gyroscope support
- Location Services
- Runtime Debug log

## Change
- SDK performance stability optimization
- Native and Unity options to SDK configuration
- Change the ImageTracker status to enumerated
- The download resource file is too large and requires a prompt
- Increase runtime quality adjustment
- Added loading Material function

## Fix
- Fix development tool errors

# Version 0.0.1
# Main features of ARMOD

## AR Basic
- Device tracking: track the device's position and orientation in physical space.
- Plane detection: detect horizontal and vertical surfaces.
- Point clouds, also known as feature points.
- Anchor: an arbitrary position and orientation that the device tracks.
- Light estimation: estimates for average color temperature and brightness in physical space.
- Environment probe: a means for generating a cube map to represent a particular area of the physical environment.
- Face tracking: detect and track human faces.
- 2D image tracking: detect and track 2D images.
- Human segmentation: determines a stencil texture and depth map of humans detected in the camera image.
- Raycast: queries physical surroundings for detected planes and feature points.
- Pass-through video: optimized rendering of mobile camera image onto touch screen as the background for AR content.
- Session management: manipulation of the platform-level configuration automatically when AR Features are enable or disabled.
- Occlusion: allows for occlusion of virtual content by detected environmental depth (environment occlusion) or by detected human depth (human occlusion).
## AR Cloud
- Fast visual positioning, low system overhead
- Positioning can be run offline on the device or online in the cloud
- Plug-ins on iOS, Android and devices compatible with Huawei AR Engine
- Immersal Cloud Service's REST API for any device
- Pre-built applications are available on the App Store to map real-world locations
- It can even map indoor and outdoor large urban areas
- Very small map file format, extremely optimized
- Private/public map with sharing options
- Global map coordination supports WGS84 and ECEF
- Use GPS coordinates to mark and search the map
- Textured mesh of point cloud and available mapping space
- Support multiple maps at the same time in the same space
- Easy-to-use Unity example with templates for indoor navigation and more
- Detailed documentation helps developers get started
- Use the 3D map viewer to develop the portal
## Unity Features
- Unity Editor Support
- Scriptable
- Visual Scripting
- Physics engine
- Lights
- Lightmap
- Universal Render Pipeline
- Custom Materials
- Custom Shaders
- UGUI
- Sprite Atlas
- Networking
- Timeline
- Animation and Animator
- Custom onnx AI Models
- iOS
- Android
- Hololens
- Magicleap
- Native Features
- All Platform native features are supported, But need developers to develop and adapt by themselves
## ARCMS Features
- ARExperience management
- ARShowcase management
- Recommend the ARShowcase
- Multiple APP support
- Tags management
- Authentication system
- 10,000 http api requests per day/Application
- Restful API Support


