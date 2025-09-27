package com.example.medinote

import android.content.Intent
import androidx.annotation.NonNull
import com.example.medinote.record.AndroidAudioRecorder
import com.example.medinote.playback.AndroidAudioPlayer
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val channelName = "com.example.medinote/speech"
    private val player = AndroidAudioPlayer()

    @androidx.annotation.RequiresPermission(android.Manifest.permission.RECORD_AUDIO)
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler  { call, result ->
                when (call.method) {
                    "startRecording" -> {
                        try {
                            val intent = Intent(this, AndroidAudioRecorder::class.java)
                            startService(intent)
                            result.success(null)
                        } catch (e: Exception) {
                            result.error("RECORDING_ERROR", "Failed to start recording", e.message)
                        }
                    }
                    "stopRecording" -> {
                        try {
                            val intent = Intent(this, AndroidAudioRecorder::class.java)
                            stopService(intent)
                            result.success(null)
                        } catch (e: Exception) {
                            result.error("RECORDING_ERROR", "Failed to stop recording", e.message)
                        }
                    }
                    "startPlaying" -> {
                        try {
                            val data = AndroidAudioRecorder.getRecordedBytes()
                            player.play(data)
                            result.success(null)
                        } catch (e: Exception) {
                            result.error("PLAYBACK_ERROR", "Failed to play audio", e.message)
                        }
                    }
                    "stopPlaying" -> {
                        try {
                            player.stop()
                            result.success(null)
                        } catch (e: Exception) {
                            result.error("PLAYBACK_ERROR", "Failed to stop playback", e.message)
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }

    override fun onDestroy() {
        super.onDestroy()
        player.stop()
    }
}