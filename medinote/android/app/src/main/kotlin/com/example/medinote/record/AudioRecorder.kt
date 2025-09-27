package com.example.medinote.record

import java.io.File

interface AudioRecorder {
    fun start(outputFile: File)
    fun stop()
}