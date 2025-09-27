package com.example.medinote

import android.content.Intent
import android.os.Bundle
import android.speech.RecognitionListener
import android.speech.RecognizerIntent
import android.speech.SpeechRecognizer
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.Locale

class MainActivity : FlutterActivity(), RecognitionListener {
    private var speech: SpeechRecognizer? = null
    private var speechChannel: MethodChannel? = null
    private var transcription: String = ""
    private var cancelled = false

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        speechChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SPEECH_CHANNEL)

        speech = SpeechRecognizer.createSpeechRecognizer(applicationContext).apply {
            setRecognitionListener(this@MainActivity)
        }

        speechChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "activate" -> {
                    result.success(true)
                }
                "start" -> {
                    val code = call.arguments.toString()
                    startListening(code)
                    result.success(true)
                }
                "cancel" -> {
                    speech?.stopListening()
                    cancelled = true
                    result.success(true)
                }
                "stop" -> {
                    speech?.stopListening()
                    cancelled = false
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun startListening(code: String) {
        val recognizerIntent = Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH).apply {
            putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL, RecognizerIntent.LANGUAGE_MODEL_FREE_FORM)
            putExtra(RecognizerIntent.EXTRA_PARTIAL_RESULTS, true)
            putExtra(RecognizerIntent.EXTRA_MAX_RESULTS, 3)
            putExtra(RecognizerIntent.EXTRA_LANGUAGE, getLocale(code))
        }
        cancelled = false
        speech?.startListening(recognizerIntent)
    }

    private fun getLocale(code: String): Locale {
        val parts = code.split("_")
        return if (parts.size >= 2) Locale(parts[0], parts[1]) else Locale.getDefault()
    }

    override fun onReadyForSpeech(params: Bundle?) {
        Log.d(LOG_TAG, "onReadyForSpeech")
        speechChannel?.invokeMethod("onSpeechAvailability", true)
    }

    override fun onBeginningOfSpeech() {
        Log.d(LOG_TAG, "onRecognitionStarted")
        transcription = ""
        speechChannel?.invokeMethod("onRecognitionStarted", null)
    }

    override fun onRmsChanged(rmsdB: Float) {
        Log.d(LOG_TAG, "onRmsChanged: $rmsdB")
    }

    override fun onBufferReceived(buffer: ByteArray?) {
        Log.d(LOG_TAG, "onBufferReceived")
    }

    override fun onEndOfSpeech() {
        Log.d(LOG_TAG, "onEndOfSpeech")
        speechChannel?.invokeMethod("onRecognitionComplete", transcription)
    }

    override fun onError(error: Int) {
        Log.d(LOG_TAG, "onError: $error")
        speechChannel?.invokeMethod("onSpeechAvailability", false)
        speechChannel?.invokeMethod("onError", error)
    }

    override fun onPartialResults(partialResults: Bundle?) {
        Log.d(LOG_TAG, "onPartialResults")
        val matches = partialResults?.getStringArrayList(SpeechRecognizer.RESULTS_RECOGNITION)
        if (!matches.isNullOrEmpty()) {
            transcription = matches[0]
            sendTranscription(false)
        }
    }

    override fun onResults(results: Bundle?) {
        Log.d(LOG_TAG, "onResults")
        val matches = results?.getStringArrayList(SpeechRecognizer.RESULTS_RECOGNITION)
        if (!matches.isNullOrEmpty()) {
            transcription = matches[0]
            sendTranscription(true)
        }
    }

    private fun sendTranscription(isFinal: Boolean) {
        speechChannel?.invokeMethod(
            if (isFinal) "onRecognitionComplete" else "onSpeech",
            transcription
        )
    }

    override fun onEvent(eventType: Int, params: Bundle?) {
        Log.d(LOG_TAG, "onEvent: $eventType")
    }

    companion object {
        private const val SPEECH_CHANNEL = "com.example.medinote/recognizer"
        private const val LOG_TAG = "MediNote"
    }
}