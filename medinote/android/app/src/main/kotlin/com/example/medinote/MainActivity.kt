package com.example.medinote

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
                        recorder.start()
                        result.success(true)
                    }
                    "stopRecording" -> {
                        recorder.stop()
                        result.success(true)
                    }
                    "startPlaying" -> {
                        val data = recorder.getRecordedBytes()
                        player.play(data)
                        result.success(true)
                    }
                    "stopPlaying" -> {
                        player.stop()
                        result.success(true)
                    }
                    else -> result.notImplemented()
                }
            }
    }
}
