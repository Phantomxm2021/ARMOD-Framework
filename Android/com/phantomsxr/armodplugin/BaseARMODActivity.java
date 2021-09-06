package com.phantomsxr.armodplugin;


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
public abstract class BaseARMODActivity extends UnityPlayerActivity {

    private final String InitSDK = "InitSDK";
    private final String FetchByUid = "LaunchARQuery";
    private final String LaunchARScanner = "LaunchARScanner";
    private final String Dispose = "Dispose";
    private final String DoQuit = "doQuit";
    private final String CleanCache = "CleanCache";
    private final String SetUIInterfaceOrientation = "SetUIInterfaceOrientation";
    private ARMODCallbackAPI armodCallbackAPI;

    public static UnityPlayer armodPlayer;

    private Class<?> originalActivity;

    protected Context context;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        armodPlayer = mUnityPlayer;
        armodCallbackAPI = new ARMODCallbackAPI();
        context = this;
        onCreateUI();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        originalActivity = null;
        armodCallbackAPI = null;
    }

    /**
     * Build the UI on the AR window
     */
    public abstract void onCreateUI();


    /**
     * Initialize SDK
     *
     * @param _appConfigure SDK configuration information, passed in in JSON format
     * @param _activity     Act class of the current window
     */
    public void initARMOD(String _appConfigure, Class<?> _activity) {
        originalActivity = _activity;
        Utils.getInstance().callSDKMethod(InitSDK, _appConfigure);
    }


    /**
     * Get the Frame layout on the AR window
     *
     * @return Frame Layout
     */
    public FrameLayout getARMODFrameLayout() {
        if (Utils.getInstance().isInitialized())
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
     * Query project details by project Id
     *
     * @param _id Project unique Id
     */
    public void fetchProject(String _id) {
        new Handler(Looper.getMainLooper())
                .postDelayed(() -> Utils.getInstance().callSDKMethod(FetchByUid, _id), 1000);

    }


    /**
     * Set the orientation of the current window
     *
     * @param _orientationId Portrait=1; PortraitUpsideDown=2;LandscapeLeft=3;LandscapeRight=4;
     */
    public void setUIInterfaceOrientation(String _orientationId) {
        Utils.getInstance().callSDKMethod(SetUIInterfaceOrientation, _orientationId);
    }

    /**
     * Clear AR cache
     */
    public void cleanCache(){
        Utils.getInstance().callSDKMethod(CleanCache,"");
    }


    /**
     * Start image recognition, the recognition is successful at the beginning of the recognition, please refer to'onRecognized' and'startRecognized'
     */
    public void fetchProjectByImage(){
        new Handler(Looper.getMainLooper())
                .postDelayed(() -> Utils.getInstance().callSDKMethod(LaunchARScanner, ""), 1000);
    }

    /**
     * Uninstall close the current SDK window
     */
    public void unloadAndHideARMOD() {
        if (Utils.getInstance().isInitialized()) {
            Intent intent = new Intent(getApplicationContext(), this.getClass());
            intent.setFlags(Intent.FLAG_ACTIVITY_REORDER_TO_FRONT);
            intent.putExtra(DoQuit, true);
            startActivity(intent);
        }
    }

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
                Utils.getInstance().callSDKMethod(Dispose, "");
                finish();
            }
    }

    /**
     * Uninstall AR window
     */
    private void unloadARMODView() {
        Intent intent = new Intent(getApplicationContext(), originalActivity);
        intent.setFlags(Intent.FLAG_ACTIVITY_REORDER_TO_FRONT | Intent.FLAG_ACTIVITY_SINGLE_TOP);
        startActivity(intent);
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
}
