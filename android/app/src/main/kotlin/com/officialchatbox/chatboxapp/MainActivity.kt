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
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity(){
    private val RINGTONE_GIVER = "ringtonegiver"
    private val NOTIFICATION_TONE_GIVER = "notificationtonegiver"
    private val DISK_SPACE_GIVER = "freediskspacegiver"
    override fun configureFlutterEngine(flutterEngine:FlutterEngine){
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, NOTIFICATION_TONE_GIVER)
            .setMethodCallHandler { call, result ->
                when (call.method){
                    "getAllNotificationTones" -> {
                        val notficationTones = getAllNotificationTones(this)
                        result.success(notficationTones);
                    }
                }
            }
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, RINGTONE_GIVER)
            .setMethodCallHandler { call, result ->
                when (call.method){
                    "getAllRingtones" -> {
                        val ringtones = getAllRingtones(this)
                        result.success(ringtones);
                    }
                }
            }
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, DISK_SPACE_GIVER)
            .setMethodCallHandler { call, result ->
                when(call.method) {
                    "getFreeDiskSpace" -> result.success(getFreeDiskSpace())
                    else -> result.notImplemented()
                }

            }
    }

    // methods
    private fun getAllNotificationTones(context: Context): List<String> {
        val manager = RingtoneManager(context)
        manager.setType(RingtoneManager.TYPE_NOTIFICATION)
        val cursor: Cursor = manager.cursor
        val list: MutableList<String> = mutableListOf()
        while (cursor.moveToNext()) {
            val notificationTitle: String = cursor.getString(RingtoneManager.TITLE_COLUMN_INDEX)
            list.add(notificationTitle)
        }
        cursor.close()
        return list
    }
    private fun getAllRingtones(context: Context): List<String> {
        val manager = RingtoneManager(context)
        manager.setType(RingtoneManager.TYPE_RINGTONE)
        val cursor: Cursor = manager.cursor
        val list: MutableList<String> = mutableListOf()
        while (cursor.moveToNext()) {
            val ringtoneTitle: String = cursor.getString(RingtoneManager.TITLE_COLUMN_INDEX)
            list.add(ringtoneTitle)
        }
        cursor.close()
        return list
    }

    private fun getFreeDiskSpace(): Double {
        val stat = StatFs(getExternalFilesDir(null)?.path ?: Environment.getExternalStorageDirectory().path)
        val bytesAvailable: Long
        bytesAvailable = if (VERSION.SDK_INT >= VERSION_CODES.JELLY_BEAN_MR2) {
            stat.blockSizeLong * stat.availableBlocksLong
        } else {
            stat.blockSize.toLong() * stat.availableBlocks.toLong()
        }
        return bytesAvailable.toDouble() / (1024 * 1024) // Return the result in MB
    }
}
