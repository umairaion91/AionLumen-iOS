//
//  AudioRecorder.swift
//  AionLumen
//
//  Created by Aoin Digital on 23/01/2025.
//

import AVFoundation

class AudioRecorder: ObservableObject {
   
    static let shared = AudioRecorder()
    
    private var audioRecorder: AVAudioRecorder?
    private var filePath: URL?
    @Published var isRecording = false
    var fileUUID: String?

    func setupAudioSession() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
            try session.setActive(true)
        } catch {
            print("Audio session setup failed: \(error)")
        }
    }

    func startRecording() {
        fileUUID = generateUUID()
        guard let fileUUID else { return }
        filePath = getDocumentsDirectory().appendingPathComponent(fileUUID)
        
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        guard let filePath else { return }
        
        do {
            audioRecorder = try AVAudioRecorder(url: filePath, settings: settings)
            audioRecorder?.record()
            isRecording = true
        } catch {
            print("Failed to start recording: \(error)")
        }
    }

    func stopRecording() {
        audioRecorder?.stop()
        isRecording = false
    }

    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func getRecodingPath() -> URL? {
        return filePath
    }
    
    private func generateUUID() -> String {
        return formatDateToString(date: Date()) + ".m4a"
    }
    
    private func formatDateToString(date: Date,
                                    format: String = "yyyy-MM-ddHH:mm:ss") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
}
