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
    private val recorder = AndroidAudioRecorder()
    private val player = AndroidAudioPlayer()

    @androidx.annotation.RequiresPermission(android.Manifest.permission.RECORD_AUDIO)
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler  { call, result ->
                when (call.method) {
                    "startRecording" -> {
                        val intent = Intent(this, AndroidAudioRecorder::class.java)
                        startService(intent)
                        result.success(null)
                    }
                    "stopRecording" -> {
                        val intent = Intent(this, AndroidAudioRecorder::class.java)
                        stopService(intent)
                        result.success(null)
                    }
                    "startPlaying" -> {
                        val data = AndroidAudioRecorder.getRecordedBytes()
                        player.play(data)
                        result.success(null)
                    }
                    "stopPlaying" -> {
                        player.stop()
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }
}