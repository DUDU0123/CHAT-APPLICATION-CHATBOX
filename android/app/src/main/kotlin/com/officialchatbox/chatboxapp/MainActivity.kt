package com.officialchatbox.chatboxapp
import io.flutter.embedding.android.FlutterActivity
import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.database.Cursor
import android.media.RingtoneManager
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import io.flutter.embedding.engine.FlutterEngine
import android.os.Environment
import android.os.StatFs
import android.widget.Toast
import io.flutter.plugin.common.MethodCall
import android.content.ContentResolver
import android.net.Uri
import android.provider.MediaStore
import android.provider.Settings
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val RINGTONE_GIVER = "ringtonegiver"
    private val NOTIFICATION_TONE_GIVER = "notificationtonegiver"
    private val DISK_SPACE_GIVER = "freediskspacegiver"
    private val TOAST_SHOWER_CHANNEL = "toastshowerchannel"
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, RINGTONE_GIVER)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getDeviceRingtoneName" -> result.success(getDeviceRingtoneName())
                    else -> result.notImplemented()
                }
            }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, NOTIFICATION_TONE_GIVER)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getDeviceNotificationToneName" -> result.success(getDeviceNotificationToneName())
                    else -> result.notImplemented()
                }
            }
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, DISK_SPACE_GIVER)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getFreeDiskSpace" -> result.success(getFreeDiskSpace())
                    else -> result.notImplemented()
                }

            }
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, TOAST_SHOWER_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "showToast" -> {
                        val message = call.argument<String>("message")
                        showToast(message)
                        result.success(null)
                    }

                    else -> result.notImplemented()
                }
            }
    }

    // methods
     private fun getDeviceRingtoneName(): String {
        val ringtoneUri = Settings.System.DEFAULT_RINGTONE_URI
        return getRingtoneName(contentResolver, ringtoneUri)
    }

    private fun getDeviceNotificationToneName(): String {
        val notificationUri = Settings.System.DEFAULT_NOTIFICATION_URI
        return getRingtoneName(contentResolver, notificationUri)
    }

    private fun getRingtoneName(contentResolver: ContentResolver, uri: Uri): String {
        val ringtone = RingtoneManager.getRingtone(applicationContext, uri)
        return ringtone.getTitle(applicationContext) ?: "Unknown"
    }



    private fun getFreeDiskSpace(): Double {
        val stat = StatFs(
            getExternalFilesDir(null)?.path ?: Environment.getExternalStorageDirectory().path
        )
        val bytesAvailable: Long
        bytesAvailable = if (VERSION.SDK_INT >= VERSION_CODES.JELLY_BEAN_MR2) {
            stat.blockSizeLong * stat.availableBlocksLong
        } else {
            stat.blockSize.toLong() * stat.availableBlocks.toLong()
        }
        return bytesAvailable.toDouble() / (1024 * 1024) // Return the result in MB
    }

    private fun showToast(message: String?) {
        if (message != null) {
            Toast.makeText(context, message, Toast.LENGTH_SHORT).show()
        }
    }
}