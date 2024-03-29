package com.phantomsxr.armodplugin;


import android.os.Handler;
import android.os.Looper;
import android.util.Log;


public class ARMODCallbackAPI {
    public static ARMODCallbackAPI instance = null;
    String LOG_TAG = "OverrideARMODActivity";

    public ARMODCallbackAPI(){
        instance = this;
    }
    Handler mainHandler = new Handler(Looper.getMainLooper());
    /**
     * When the device does not support AR-SDK, execute this method
     *
     */
    public void deviceNotSupport(){
        RunOnMainThread(() -> {
            for(ARMODEventListener listener : Utils.getInstance().mARMODEventListeners){
                try {
                    listener.onDeviceNotSupport();
                } catch (Exception e) {
                    Log.e(LOG_TAG, e.getMessage());
                }
            }
        });
    }

    /**
     * This method is executed when the resource is loaded.
     */
    public void removeLoadingOverlay(){
        RunOnMainThread(()->{
            for(ARMODEventListener listener : Utils.getInstance().mARMODEventListeners){
                try {
                    listener.onRemoveLoadingOverlay();
                } catch (Exception e) {
                    Log.e(LOG_TAG, e.getMessage());
                }
            }});
    }

    /**
     * Download resource progress
     */
    public void updateLoadingProgress(float _progressValue){
        for(ARMODEventListener listener : Utils.getInstance().mARMODEventListeners){
            try {
                listener.onUpdateLoadingProgress(_progressValue);
            } catch (Exception e) {
                Log.e(LOG_TAG, e.getMessage());
            }
        }
    }

    /**
     * Start loading resources will execute the method
     */
    public void addLoadingOverlay(){
        RunOnMainThread(()->{
            for(ARMODEventListener listener : Utils.getInstance().mARMODEventListeners){
                try {
                    listener.onAddLoadingOverlay();
                } catch (Exception e) {
                    Log.e(LOG_TAG, e.getMessage());
                }
            }});
    }


    /**
     * The method will be executed if an exception occurs
     *
     * @param _error   SDK error string
     * @param _errorCode Error code
     */
    public void throwException(String _error,int _errorCode){
        RunOnMainThread(()->{
            for(ARMODEventListener listener : Utils.getInstance().mARMODEventListeners){
                try {
                    listener.onThrowException(_error,_errorCode);
                } catch (Exception e) {
                    Log.e(LOG_TAG, e.getMessage());
                }
            }});
    }

    /**
     * The device supports AR SDK, but AR Service needs to be installed
     */
    public void needInstallARCoreService(){
        RunOnMainThread(()->{
            for(ARMODEventListener listener : Utils.getInstance().mARMODEventListeners){
                try {
                    listener.onNeedInstallARCoreService();
                } catch (Exception e) {
                    Log.e(LOG_TAG, e.getMessage());
                }
            }});
    }

    /**
     * Use the APP built-in browser to open the specified link
     * @param _url url string
     */
    public void openBuiltInBrowser(String _url){
        RunOnMainThread(()->{
            for(ARMODEventListener listener : Utils.getInstance().mARMODEventListeners){
                try {
                    listener.onOpenBuiltInBrowser(_url);
                } catch (Exception e) {
                    Log.e(LOG_TAG, e.getMessage());
                }
            }});
    }

    /**
     * The  algorithm of AR is initialized
     */
    public void sdkInitialized(){
        RunOnMainThread(()->{
            for(ARMODEventListener listener : Utils.getInstance().mARMODEventListeners){
                try {
                    listener.onSdkInitialized();
                } catch (Exception e) {
                    Log.e(LOG_TAG, e.getMessage());
                }
            }});
    }

    /**
     * Recognized successfully
     */
    public void recognitionComplete(){
        RunOnMainThread(()->{
            for(ARMODEventListener listener : Utils.getInstance().mARMODEventListeners){
                try {
                    listener.onRecognitionComplete();
                } catch (Exception e) {
                    Log.e(LOG_TAG, e.getMessage());
                }
            }});
    }

    /**
     * Start to recognize
     */
    public void recognitionStart(){
        RunOnMainThread(()->{
            for(ARMODEventListener listener : Utils.getInstance().mARMODEventListeners){
                try {
                    listener.onRecognitionStart();
                } catch (Exception e) {
                    Log.e(LOG_TAG, e.getMessage());
                }
            }});
    }

    /**
     * Get device information
     * @param _opTag The type of operation request sent by the sdk
     */
    public void tryAcquireInformation(String _opTag, AndroidCallback callback){
        RunOnMainThread(()->{
            for (ARMODEventListener listener : Utils.getInstance().mARMODEventListeners) {
                try {
                    listener.onTryAcquireInformation(_opTag, callback);
                } catch (Exception e) {
                    Log.e(LOG_TAG, e.getMessage());
                }
            }});
    }

    /**
     * Listening and receiving messages from XR-Experience
     * @param _data The message data sent from XR-Experience
     */
    public void onMessageReceived(String _data){
        RunOnMainThread(()->{
            for (ARMODEventListener listener : Utils.getInstance().mARMODEventListeners) {
                try {
                    listener.onMessageReceived(_data);
                } catch (Exception e) {
                    Log.e(LOG_TAG, e.getMessage());
                }
            }});
    }

    /**
     * Run after AR-MOD algorithm is working
     */
    public void onARMODLaunch(){
        RunOnMainThread(()->{
            for (ARMODEventListener listener : Utils.getInstance().mARMODEventListeners) {
                try {
                    listener.onARMODLaunch();
                } catch (Exception e) {
                    Log.e(LOG_TAG, e.getMessage());
                }
            }});
    }


    /**
     * Run after AR-MOD algorithm is working
     */
    public void onARMODExit(){
        RunOnMainThread(()->{
            for (ARMODEventListener listener : Utils.getInstance().mARMODEventListeners) {
                try {
                    listener.onARMODExit();
                } catch (Exception e) {
                    Log.e(LOG_TAG, e.getMessage());
                }
            }});
    }


    /**
     * Detected that the ARExperience package is too large
     * @param currentSize Current package size
     * @param presetSize Maximum downloadable package size 
     */
    public void onPackageSizeMoreThanPresetSize(String currentSize,String presetSize){
        RunOnMainThread(()->{
            for (ARMODEventListener listener : Utils.getInstance().mARMODEventListeners) {
                try {
                    listener.onPackageSizeMoreThanPresetSize(currentSize,presetSize);
                } catch (Exception e) {
                    Log.e(LOG_TAG, e.getMessage());
                }
            }});
    }

    private void RunOnMainThread(RunOnMainThreadAction action){
        Runnable myRunnable = new Runnable() {
            @Override
            public void run() {
                for(ARMODEventListener listener : Utils.getInstance().mARMODEventListeners){
                    try {
                        action.Execute();
                    } catch (Exception e) {
                        Log.e(LOG_TAG, e.getMessage());
                    }
                }
            }
        };
        mainHandler.post(myRunnable);

    }

    private interface RunOnMainThreadAction{
        void Execute();
    }
}
