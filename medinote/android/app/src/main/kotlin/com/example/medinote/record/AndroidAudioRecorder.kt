package com.example.medinote.record

import android.Manifest
import android.media.AudioFormat
import android.media.AudioRecord
import android.media.MediaRecorder
import android.util.Log
import androidx.annotation.RequiresPermission
import kotlin.concurrent.thread

class AndroidAudioRecorder {

    private var audioRecord: AudioRecord? = null
    private var recordingThread: Thread? = null
    private var isRecording = false

    private val sampleRate = 44100
    private val channelConfig = AudioFormat.CHANNEL_IN_MONO
    private val audioFormat = AudioFormat.ENCODING_PCM_16BIT
    private val bufferSize = AudioRecord.getMinBufferSize(sampleRate, channelConfig, audioFormat)

    private val recordedData = mutableListOf<ByteArray>()

    @RequiresPermission(Manifest.permission.RECORD_AUDIO)
    fun start() {
        audioRecord = AudioRecord(
            MediaRecorder.AudioSource.MIC,
            sampleRate,
            channelConfig,
            audioFormat,
            bufferSize
        )

        if (audioRecord?.state != AudioRecord.STATE_INITIALIZED) {
            Log.e("Recorder", "AudioRecord not initialized")
            return
        }

        audioRecord?.startRecording()
        isRecording = true
        recordedData.clear()

        recordingThread = thread(start = true) {
            val buffer = ByteArray(bufferSize)
            while (isRecording) {
                val read = audioRecord?.read(buffer, 0, buffer.size) ?: 0
                if (read > 0) {
                    recordedData.add(buffer.copyOf(read))
                }
            }
        }
    }

    fun stop() {
        isRecording = false
        audioRecord?.stop()
        audioRecord?.release()
        audioRecord = null
        recordingThread = null
    }

    fun getRecordedBytes(): ByteArray {
        val totalSize = recordedData.sumOf { it.size }
        val output = ByteArray(totalSize)
        var offset = 0
        for (chunk in recordedData) {
            System.arraycopy(chunk, 0, output, offset, chunk.size)
            offset += chunk.size
        }
        return output
    }
}
