//
//  VoiceCommandControl.swift
//  AionLumen
//
//  Created by Aoin Digital on 23/01/2025.
//

import Speech
import AVFoundation

class VoiceCommandControl: NSObject, SFSpeechRecognizerDelegate {
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private var command: String = "start aion lumen"

    func awaitStartRecordingCommand() {
        guard let speechRecognizer = speechRecognizer, speechRecognizer.isAvailable else {
            print("Speech recognizer is unavailable.")
            return
        }

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        let audioSession = AVAudioSession.sharedInstance()

        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Audio session setup failed: \(error)")
        }

        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.recognitionRequest?.append(buffer)
        }

        audioEngine.prepare()
        try? audioEngine.start()

        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest!) { result, error in
            if let result = result {
                let spokenText = result.bestTranscription.formattedString.lowercased()
                
                print("Detected command: \(spokenText)")

                if spokenText.contains(self.command) {
                    AudioRecorder.shared.startRecording()
                }
            }
        }
    }

    func awaitStopRecordingCommand() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        print("Stopped listening for commands.")
    }
}

