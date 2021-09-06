//
//  ARMODCallbackAPI.swift
//  ARMOD
//
//  Created by phantomsxr on 2021/9/2.
//  Copyright © 2020 phantomsxr.com. All rights reserved.
//

import Foundation
//import flutter_armod_widget

@objc public class ARMODCallbackAPI: UIResponder,NativeCallsProtocol  {
    public func tryAcquireInformation(_ opTag: String!,  callBackFuncP callback: TryAcquireInformationCallBackFuncP!) {
        let playload: Dictionary<String, Any> = [
            "opTag": opTag!
        ]
        
        globalChannel?.invokeMethod("events#onTryAcquireInformation", arguments: playload, result:  {result in
            
            
            self.resultStr = result as? String ?? ""
            self.gotResult = true
            callback(self.resultStr.cString(using: .utf8))
        })
    }
    
    
    var gotResult:Bool = false;
    var resultStr:String = ""
    
    public func throwException(_ message: String!, errorCode code: Int32) {
        let playload: Dictionary<String, Any> = [
            "message": message ?? "Unknow",
            "errorCode":code,
        ]
        
        globalChannel?.invokeMethod("events#throwException", arguments: playload)
    }
    
    public func onARMODExit() {
        globalChannel?.invokeMethod("events#onARMODExit", arguments: "")
    }
    
    public func onARMODLaunch() {
        //Secondary load
        if((GetARMODPlayerUtils()?.isARMODReady()) != nil){
            DispatchQueue.main.asyncAfter(deadline: .now()+0.125, execute:
                                            {
                                                globalChannel?.invokeMethod("events#onARMODLaunch", arguments: "")
                                            })
        }else{
            globalChannel?.invokeMethod("events#onARMODLaunch", arguments: "")
        }
    }
    
    public func addLoadingOverlay() {
        globalChannel?.invokeMethod("events#onAddLoadingOverlay", arguments: "")
    }
    
    public func updateLoadingProgress(_ progress: Float) {
        let playload: Dictionary<String, Float> = [
            "progress": progress
        ]
        globalChannel?.invokeMethod("events#onUpdateLoadingProgress", arguments: playload)
    }
    
    public func removeLoadingOverlay() {
        globalChannel?.invokeMethod("events#onRemoveLoadingOverlay", arguments: "")
    }
    
    public func deviceNotSupport() {
        globalChannel?.invokeMethod("events#onDeviceNotSupport", arguments: "")
    }
    
    public func sdkInitialized() {
        globalChannel?.invokeMethod("events#onSdkInitialized", arguments: "")
    }
    
    public func openBuilt(inBrowser url: String!) {
        let playload: Dictionary<String, Any> = [
            "url": url ?? ""
        ]
        globalChannel?.invokeMethod("events#onOpenBuiltinBrowser", arguments: playload)
    }
    
    public func recognitionStart() {
        globalChannel?.invokeMethod("events#onRecognitionStart", arguments: "")
    }
    
    public func recognitionComplete() {
        globalChannel?.invokeMethod("events#onRecognitionComplete", arguments: "")
    }
    
    public func packageSizeMoreThanPresetSize(_ currentSize: Float, preset presetSize: Float) {
        let playload: Dictionary<String, Any> = [
            "currentSize": currentSize,
            "presetSize":presetSize
        ]
        globalChannel?.invokeMethod("events#onPackageSizeMoreThanPresetSize", arguments: playload)
    }
    
    private func test(opTag:String){
        let playload: Dictionary<String, Any> = [
            "opTag": opTag
        ]
       
        globalChannel?.invokeMethod("events#onTryAcquireInformation", arguments: playload, result:  {result in
            self.resultStr = result as? String ?? ""
            self.gotResult = true
        })
    }
    
    
    func tryAcquireInfomationAsync(
        _ completion: @escaping (String?, Error?) -> Void
    )
    {
        DispatchQueue.global().async {
            do {
                self.test(opTag: "123")
                while !self.gotResult{
                    print(self.gotResult)
                }
                DispatchQueue.main.async {
                    completion(self.resultStr, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }
}
