package com.example.medinote.playback

import android.media.AudioFormat
import android.media.AudioManager
import android.media.AudioTrack
import android.util.Log
import kotlin.concurrent.thread

class AndroidAudioPlayer {

    private var audioTrack: AudioTrack? = null
    private var playbackThread: Thread? = null
    private var isPlaying = false

    fun play(data: ByteArray) {
        stop()

        val bufferSize = data.size.coerceAtLeast(AudioTrack.getMinBufferSize(
            44100,
            AudioFormat.CHANNEL_OUT_MONO,
            AudioFormat.ENCODING_PCM_16BIT
        ))

        audioTrack = AudioTrack(
            AudioManager.STREAM_MUSIC,
            44100,
            AudioFormat.CHANNEL_OUT_MONO,
            AudioFormat.ENCODING_PCM_16BIT,
            bufferSize,
            AudioTrack.MODE_STREAM
        )

        isPlaying = true
        audioTrack?.play()

        playbackThread = thread(start = true) {
            try {
                audioTrack?.write(data, 0, data.size)
            } catch (e: Exception) {
                Log.e("AudioPlayer", "Error playing audio: $e")
            }
        }
    }

    fun stop() {
        isPlaying = false
        audioTrack?.stop()
        audioTrack?.release()
        audioTrack = null
        playbackThread = null
    }
}