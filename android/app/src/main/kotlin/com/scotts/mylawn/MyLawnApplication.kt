package com.scotts.lawnapp

import android.app.Activity
import android.os.Bundle
import com.adobe.marketing.mobile.AdobeCallback;
import com.adobe.marketing.mobile.Analytics;
import com.adobe.marketing.mobile.Identity;
import com.adobe.marketing.mobile.InvalidInitException;
import com.adobe.marketing.mobile.Lifecycle;
import com.adobe.marketing.mobile.LoggingMode;
import com.adobe.marketing.mobile.MobileCore;
import com.adobe.marketing.mobile.MobileServices;
import com.adobe.marketing.mobile.Places;
import com.adobe.marketing.mobile.PlacesMonitor;
import com.adobe.marketing.mobile.Signal;
import com.adobe.marketing.mobile.UserProfile;
import com.adobe.marketing.mobile.WrapperType;
import com.localytics.android.*

import io.flutter.Log;
import io.flutter.app.FlutterApplication
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin
import io.flutter.plugins.firebasemessaging.FlutterFirebaseMessagingService

// https://github.com/FirebaseExtended/flutterfire/issues/2077#issuecomment-631029256
class MyLawnApplication : FlutterApplication(), PluginRegistry.PluginRegistrantCallback {
    override fun onCreate() {
        super.onCreate()
        FlutterFirebaseMessagingService.setPluginRegistrant(this);

        Localytics.autoIntegrate(this)

        // Adobe Places initialization
        MobileCore.setApplication(this)
        MobileCore.setLogLevel(LoggingMode.DEBUG)
        MobileCore.setWrapperType(WrapperType.FLUTTER)

        // Adobe Analytics initialization
        Analytics.registerExtension()

        try {
            UserProfile.registerExtension()

            MobileServices.registerExtension()
            PlacesMonitor.registerExtension()
            Places.registerExtension()
            Analytics.registerExtension()
            Identity.registerExtension()
            Lifecycle.registerExtension()
            Signal.registerExtension()


            MobileCore.start(null)

        } catch (e: InvalidInitException){
            Log.e("App", "Error while registering Adobe extension ${e.localizedMessage}")
        }

        registerActivityLifecycleCallbacks(object : ActivityLifecycleCallbacks {
        override fun onActivityCreated(activity: Activity, bundle: Bundle?) { /*no-op*/ }

        override fun onActivityStarted(activity: Activity) { /*no-op*/
        }

        override fun onActivityResumed(activity: Activity) {
            MobileCore.setApplication(this@MyLawnApplication)
            MobileCore.lifecycleStart(null)
        }

        override fun onActivityPaused(activity: Activity) {
            MobileCore.lifecyclePause()
        }

        override fun onActivityStopped(activity: Activity) { /*no-op*/ }

        override fun onActivitySaveInstanceState(activity: Activity,
                                                bundle: Bundle) { /*no-op*/ }

        override fun onActivityDestroyed(activity: Activity) { /*no-op*/ }
        })
    }

    override fun registerWith(registry: PluginRegistry?) {
        FirebaseMessagingPlugin.registerWith(registry?.registrarFor("io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin"))
    }
}