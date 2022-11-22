package com.phantomsxr.armodplugin;

public interface ARMODEventListener {
    void onDeviceNotSupport();
    void onAddLoadingOverlay();
    void onUpdateLoadingProgress(float progress);
    void onRemoveLoadingOverlay();
    void onThrowException(String errorMsg,int errorCode);
    void onNeedInstallARCoreService();
    void onSdkInitialized();
    void onOpenBuiltInBrowser(String url);
    void onRecognitionStart();
    void onRecognitionComplete();
    void onTryAcquireInformation(String opTag,AndroidCallback androidCallback);
    void onPackageSizeMoreThanPresetSize(String currentSize,String presetSize);
    void onMessageReceived(String data)
    void onARMODExit();
    void onARMODLaunch();
}
