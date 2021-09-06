package com.phantomsxr.armodplugin;

import com.unity3d.player.UnityPlayer;
import java.util.concurrent.CopyOnWriteArraySet;

public class Utils {
    private  final String EntryPoint = "EntryPoint";
    public  final CopyOnWriteArraySet<ARMODEventListener> mARMODEventListeners = new CopyOnWriteArraySet<ARMODEventListener>();

    private static Utils instance = null;
    private Utils(){}
    static{
        instance = new Utils();
    }

    public static Utils getInstance(){
        return instance;
    }

    /**
     * Call SDK internal method
     *
     * @param _methodName Call method name
     * @param _data       transfer data
     */
    public void callSDKMethod(String _methodName, String _data) {
        if (isInitialized()) {
            UnityPlayer.UnitySendMessage(EntryPoint, _methodName, _data);
        } else {
            System.out.println("You can not send anything message to AR,Because SDK is not initialize");
        }
    }

    /**
     * Determine whether the SDK is initialized
     *
     * @return False False means that it has not been initialized, and True means that the initialization is successful
     */
    public boolean isInitialized() {
        return BaseARMODActivity.armodPlayer != null;
    }

    /**
     * Add AR-MOD SDK callback listener to listener array
     * @param listener callback listener
     */
    public void addARMODEventListener(ARMODEventListener listener){
        mARMODEventListeners.add(listener);
    }

    /**
     * Remove AR-MOD SDK callback listener from listener array
     * @param listener callback listener
     */
    public void removeARMODEventListener(ARMODEventListener listener){
        mARMODEventListeners.remove(listener);
    }
}
