package com.scotts.lawnapp

import com.adobe.marketing.mobile.Analytics;
import com.adobe.marketing.mobile.MobileCore;
import com.google.firebase.iid.FirebaseInstanceId
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import com.localytics.android.*
import android.content.Intent
import android.os.Bundle

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        val channelAdobe = MethodChannel(flutterEngine.dartExecutor.binaryMessenger,
                "com.scotts.lawnapp/adobe")
        channelAdobe.setMethodCallHandler { call, result ->
            if (call.method == "configureAdobeWithEnvironmentId") {
                val environmentId = (call.arguments as String)!!
                if (environmentId == null || environmentId.isEmpty()) {
                    // Return error if we were given empty or null environment ID.
                    result.error("Bad Argument", "Environment ID is null or empty", null)
                } else {
                    // We're about to switch environments, so any queued items will need to go.
                    Analytics.clearQueue()
                    // Trigger download of new configuration.
                    MobileCore.configureWithAppID(environmentId)
                    // Set session timeout to zero, to forcibly close the session.
                    MobileCore.updateConfiguration(mapOf("lifecycle.sessionTimeout" to 0))
                    // Set session timeout back to a reasonable five minutes.
                    MobileCore.updateConfiguration(mapOf("lifecycle.sessionTimeout" to 300))
                    // Because we can't await any of the above, we use an artificial
                    // timeout of a second, to leave room for it to finish.
                    Thread.sleep(1000L)
                    // Return given environment ID.
                    result.success(environmentId)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        Localytics.onNewIntent(this, intent)
    }
}
