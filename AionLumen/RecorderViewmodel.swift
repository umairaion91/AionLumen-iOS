//
//  RecorderViewmodel.swift
//  AionLumen
//
//  Created by Aoin Digital on 23/01/2025.
//

import SwiftUI
import SwiftData

class RecordingViewModel: ObservableObject {
    
    @Published var isRecording = false
    @Published var filePath: URL?
    @Published var recordingDuration = "00:00"
    
    private var timer: Timer?
    private var startTime: Date?
    
    
    func startRecording() {
        isRecording = true
        startTime = Date()
        startTimer()
        AudioRecorder.shared.setupAudioSession()
        AudioRecorder.shared.startRecording()
    }
    
    func stopRecording(with context: ModelContext) {
        isRecording = false
        stopTimer()
        filePath = AudioRecorder.shared.getRecodingPath()
        guard let filePath else {
            return
        }
        save(filePath: filePath.absoluteString, context: context)
        AudioRecorder.shared.stopRecording()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            guard let startTime = self.startTime else { return }
            let elapsed = Int(Date().timeIntervalSince(startTime))
            self.recordingDuration = self.formatDuration(elapsed)
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        recordingDuration = "00:00"
    }
    
    private func formatDuration(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func save(filePath: String, context: ModelContext) {
        guard let fileUUID = AudioRecorder.shared.fileUUID else { return }
        let recording = RecordingModel(filePath: filePath, timestamp: fileUUID)
        RecordingFileManager.shared.save(item: recording, context: context)
    }
}
