package com.example.medinote.record

import android.Manifest
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Intent
import android.media.AudioFormat
import android.media.AudioRecord
import android.media.MediaRecorder
import android.os.Build
import android.os.IBinder
import android.util.Log
import androidx.annotation.RequiresPermission
import androidx.core.app.NotificationCompat
import com.example.medinote.R
import java.util.concurrent.CopyOnWriteArrayList
import kotlin.concurrent.thread

class AndroidAudioRecorder : Service() {
    companion object {
        const val CHANNEL_ID = "AndroidAudioRecorderServiceChannel"

        val recordedData = CopyOnWriteArrayList<ByteArray>()

        @Synchronized
        fun getRecordedBytes(): ByteArray {
            val snapshot = ArrayList(recordedData)
            val totalSize = snapshot.sumOf { it.size }
            val output = ByteArray(totalSize)
            var offset = 0
            for (chunk in snapshot) {
                System.arraycopy(chunk, 0, output, offset, chunk.size)
                offset += chunk.size
            }
            return output
        }

        @Synchronized
        fun clearRecordedData() {
            recordedData.clear()
        }
    }

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()

        val notificationIntent = Intent(this, Class.forName("com.example.medinote.MainActivity"))
        notificationIntent.flags = Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_SINGLE_TOP

        val pendingIntent = PendingIntent.getActivity(
            this,
            0,
            notificationIntent,
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) PendingIntent.FLAG_IMMUTABLE else 0
        )

        val notification: Notification = NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("Microphone is Active")
            .setContentText("This app is accessing your microphone.")
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentIntent(pendingIntent)
            .setOngoing(true)
            .build()

        startForeground(2345678, notification)
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val serviceChannel = NotificationChannel(
                CHANNEL_ID,
                "Mic Service Channel",
                NotificationManager.IMPORTANCE_DEFAULT
            )
            val manager = getSystemService(NotificationManager::class.java)
            manager?.createNotificationChannel(serviceChannel)
        }
    }

    private var audioRecord: AudioRecord? = null
    private var recordingThread: Thread? = null
    private var isRecording = false

    private val sampleRate = 44100
    private val channelConfig = AudioFormat.CHANNEL_IN_MONO
    private val audioFormat = AudioFormat.ENCODING_PCM_16BIT
    private val bufferSize = AudioRecord.getMinBufferSize(sampleRate, channelConfig, audioFormat)

    @RequiresPermission(Manifest.permission.RECORD_AUDIO)
    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        start()
        return START_STICKY
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    override fun onTaskRemoved(rootIntent: Intent?) {
        super.onTaskRemoved(rootIntent)
        stop()
        stopSelf()
    }

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
        clearRecordedData() // Use the synchronized clear method

        recordingThread = thread(start = true) {
            val buffer = ByteArray(bufferSize)
            while (isRecording) {
                val read = audioRecord?.read(buffer, 0, buffer.size) ?: 0
                if (read > 0) {
                    // This is thread-safe with CopyOnWriteArrayList
                    recordedData.add(buffer.copyOf(read))
                }
            }
        }
    }

    private fun stop() {
        isRecording = false
        audioRecord?.stop()
        audioRecord?.release()
        audioRecord = null
        recordingThread?.join()
        recordingThread = null
    }

    override fun onDestroy() {
        super.onDestroy()
        stop()
    }
}