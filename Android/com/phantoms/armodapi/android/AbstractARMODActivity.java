package com.phantoms.armodapi.android;


import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;
import android.view.LayoutInflater;
import android.widget.FrameLayout;

import com.unity3d.player.UnityPlayer;
import com.unity3d.player.UnityPlayerActivity;

/**
 * AR SDK Activity，To access AR-SDK, you need to inherit this Activity.
 */
public abstract class AbstractARMODActivity extends UnityPlayerActivity {

    private final String InitSDK = "InitSDK";
    private final String FetchByUid = "LaunchARQuery";
    private final String LaunchARScanner = "LaunchARScanner";
    private final String Dispose = "Dispose";
    private final String EntryPoint = "EntryPoint";
    private final String DoQuit = "doQuit";
    private final String CleanCache = "CleanCache";
    private final String SetUIInterfaceOrientation = "SetUIInterfaceOrientation";

    public static AbstractARMODActivity instance = null;

    private Class<?> originalActivity;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        instance = this;
        onCreateUI();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        originalActivity = null;
        instance = null;
    }


    //--------------------------------------------------------------------------------------------------------------

    /**
     * Build the UI on the AR window
     */
    public abstract void onCreateUI();

    /**
     * When the device does not support AR-SDK, execute this method
     *
     */
    abstract public void deviceNotSupport();

    /**
     * This method is executed when the resource is loaded.
     */
    abstract public void removeLoadingOverlay();

    /**
     * Download resource progress
     */
    abstract public void updateLoadingProgress(float _progressValue);

    /**
     * Start loading resources will execute the method
     */
    abstract public void addLoadingOverlay();


    /**
     * The method will be executed if an exception occurs
     *
     * @param _error   SDK error string
     * @param _errorCode Error code
     */
    abstract public void throwException(String _error,int _errorCode);

    /**
     * The device supports AR SDK, but AR Service needs to be installed
     */
    abstract public void needInstallARCoreService();

    /**
     * Use the APP built-in browser to open the specified link
     * @param _url url string
     */
    abstract public void openBuiltInBrowser(String _url);

    /**
     * The  algorithm of AR is initialized
     */
    abstract public void sdkInitialized();

    /**
     * Recognized successfully
     */
    abstract public void recognitionComplete();

    /**
     * Start to recognize
     */
    abstract public void recognitionStart();

    /**
     * Get device information
     * @param _opTag The type of operation request sent by the sdk
     */
    abstract public String tryAcquireInformation(String _opTag);

    /**
     * Initialize SDK
     *
     * @param _appConfigure SDK configuration information, passed in in JSON format
     * @param _activity     Act class of the current window
     */
    public void initARMOD(String _appConfigure, Class<?> _activity) {
        originalActivity = _activity;
        callSDKMethod(InitSDK, _appConfigure);
    }

    /**
     * Query project details by project Id
     *
     * @param _id Project unique Id
     */
    public void fetchProject(String _id) {
        new Handler(Looper.getMainLooper())
                .postDelayed(() -> callSDKMethod(FetchByUid, _id), 1000);

    }

    /**
     * Start image recognition, the recognition is successful at the beginning of the recognition, please refer to'onRecognized' and'startRecognized'
     */
    public void fetchProjectByImage(){
        new Handler(Looper.getMainLooper())
                .postDelayed(() -> callSDKMethod(LaunchARScanner, ""), 1000);
    }

    /**
     *Uninstall close the current SDK window
     */
    public void unloadAndHideARMOD() {
        if (isInitialized()) {
            Intent intent = new Intent(getApplicationContext(), this.getClass());
            intent.setFlags(Intent.FLAG_ACTIVITY_REORDER_TO_FRONT);
            intent.putExtra(DoQuit, true);
            startActivity(intent);
        }
    }

    /**
     * Get the Frame layout on the AR window
     *
     * @return Frame Layout
     */
    public FrameLayout getARMODFrameLayout() {
        if (isInitialized())
            return mUnityPlayer;
        else
            return null;
    }

    /**
     * Get the Layout Inflater of the current window. You can set the following Id
     *
     * @return Layout Inflater
     */
    public LayoutInflater getLayoutInflater() {
        return (LayoutInflater) this.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
    }


    /**
     * Set the orientation of the current window
     *
     * @param _orientationId Portrait=1; PortraitUpsideDown=2;LandscapeLeft=3;LandscapeRight=4;
     */
    public void setUIInterfaceOrientation(String _orientationId) {
        callSDKMethod(SetUIInterfaceOrientation, _orientationId);
    }

    /**
     * Clear AR cache
     */
    public void cleanCache(){
        callSDKMethod(CleanCache,"");
    }

    //--------------------------------------------------------------------------------------------------------------

    /**
     * Listen for Intent events
     *
     * @param intent intent
     */
    private void handleIntent(Intent intent) {
        if (intent == null || intent.getExtras() == null) return;
        Log.i("handleIntent","handleIntent!!!!");

        if (intent.getExtras().containsKey(DoQuit))
            if (mUnityPlayer != null) {
                callSDKMethod(Dispose, "");
                finish();
            }
    }

    /**
     * Call SDK internal method
     *
     * @param _methodName Call method name
     * @param _data       transfer data
     */
    private void callSDKMethod(String _methodName, String _data) {
        if (isInitialized()) {
            UnityPlayer.UnitySendMessage(EntryPoint, _methodName, _data);
        } else {
            System.out.println("You can not send anything message to AR,Because SDK is not initialize");
        }
    }

    /**
     *Uninstall AR window
     */
    private void unloadARMODView() {
        Intent intent = new Intent(getApplicationContext(), originalActivity);
        intent.setFlags(Intent.FLAG_ACTIVITY_REORDER_TO_FRONT | Intent.FLAG_ACTIVITY_SINGLE_TOP);
        startActivity(intent);
    }


    /**
     * Determine whether the SDK is initialized
     *
     * @return False False means that it has not been initialized, and True means that the initialization is successful
     */
    protected boolean isInitialized() {
        return mUnityPlayer != null;
    }

    /**
     * Get a new Intent
     *
     * @param intent intent
     */
    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        handleIntent(intent);
        setIntent(intent);
    }

    /**
     * Callback function, run when the AR window is closed
     */
    @Override
    public void onUnityPlayerUnloaded() {
        unloadARMODView();
    }



    //--------------------------------------------------------------------------------------------------------------
}
