package com.scotts.lawnapp

import android.app.Notification
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.text.TextUtils
import androidx.core.app.NotificationCompat
import com.google.firebase.messaging.RemoteMessage
import com.localytics.android.Localytics
import com.scotts.lawnapp.R
import io.flutter.plugins.firebasemessaging.FlutterFirebaseMessagingService

class MLMessagingService : FlutterFirebaseMessagingService() {

    override fun onNewToken(refreshedToken: String) {
        super.onNewToken(refreshedToken)
        Localytics.setPushRegistrationId(refreshedToken)
    }

    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        /**
         * The RemoteMessage with "remoteConfig" key is received
         * when the Firebase Remote Config is updated from console
         * for "kill switch" or "force update" values.
         *
         * In that case, we will let Flutter Firebase Messaging Plugin handle it
         * so we can receive callbacks registered on Flutter side.
         */
        if(remoteMessage.data.containsKey("remoteConfig")){
            super.onMessageReceived(remoteMessage)
        }
        else if (!Localytics.handleFirebaseMessage(remoteMessage.data)) {
            showNotification(remoteMessage.data.get("message") ?: "")
        }
    }

    private fun showNotification(message: String) {
        if (!TextUtils.isEmpty(message)) {
            val intent = Intent(this, MainActivity::class.java)
            intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)

            val pendingIntent = PendingIntent.getActivity(this, 0, intent, PendingIntent.FLAG_ONE_SHOT)

            val builder = NotificationCompat.Builder(this, "SOME_CHANNEL_ID")
                    .setSmallIcon(R.mipmap.ic_launcher)
                    .setContentTitle("FCM Message")
                    .setContentText(message)
                    .setAutoCancel(true)
                    .setDefaults(Notification.DEFAULT_SOUND)
                    .setContentIntent(pendingIntent)

            val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

            manager.notify(0, builder.build());
        }
    }
}
