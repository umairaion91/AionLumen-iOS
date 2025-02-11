//
//  SpeechToTextEngine.swift
//  AionLumen
//
//  Created by Aoin Digital on 23/01/2025.
//

import UIKit
import Speech
import AVFoundation


class SpeechToTextEngine {
    
    static let shared = SpeechToTextEngine()
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    func startRecording(completion: @escaping (String?, Error?) -> Void) {
        
        // Check for active tasks and cancel them
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        // Configure the audio session
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            completion(nil, error)
            return
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            completion(nil, NSError(domain: "SpeechRecognition", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create a recognition request."]))
            return
        }
        
        let inputNode = audioEngine.inputNode
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                
                // Return the transcribed text
                completion(result.bestTranscription.formattedString, nil)
            }
            
            if let error = error {
                completion(nil, error)
                self.stopRecording()
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            completion(nil, error)
        }
    }
    
    func stopRecording() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        recognitionRequest = nil
        recognitionTask = nil
    }
    
    func requestSpeechAuthorization() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            switch authStatus {
            case .authorized:
                print("Speech recognition authorized")
            case .denied:
                print("Speech recognition authorization denied")
            case .restricted:
                print("Speech recognition restricted")
            case .notDetermined:
                print("Speech recognition not determined")
            @unknown default:
                fatalError()
            }
        }
    }
    
    func transcribeAudioFromFile(url: URL) {
        guard let speechRecognizer = speechRecognizer, speechRecognizer.isAvailable else {
            print("Speech recognizer is not available")
            return
        }
        
        // Cancel the current task if any
        recognitionTask?.cancel()
        recognitionTask = nil
        
        // Create a recognition request
        let recognitionRequest = SFSpeechURLRecognitionRequest(url: url)
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                print("Transcription: \(result.bestTranscription.formattedString)")
            }
            if let error = error {
                print("Error during transcription: \(error.localizedDescription)")
            }
        }
    }
    
    func transcribeAudioFromFile(url: URL, completion: @escaping (Result<String, Error>) -> Void) {
        guard let speechRecognizer = speechRecognizer, speechRecognizer.isAvailable else {
            completion(.failure(NSError(domain: "SpeechRecognizerError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Speech recognizer is not available"])))
            return
        }
        
        // Cancel the current task if any
        recognitionTask?.cancel()
        recognitionTask = nil
        
        // Create a recognition request
        let recognitionRequest = SFSpeechURLRecognitionRequest(url: url)
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            if let error = error {
                completion(.failure(error))
            } else if let result = result {
                completion(.success(result.bestTranscription.formattedString))
            }
        }
    }
}
