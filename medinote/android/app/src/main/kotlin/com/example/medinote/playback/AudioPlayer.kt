package com.example.medinote.playback

import java.io.File

interface AudioPlayer {
    fun play(bytes: ByteArray)
    fun stop()
}