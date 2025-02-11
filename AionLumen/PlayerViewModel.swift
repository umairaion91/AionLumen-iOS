//
//  PlayerViewModel.swift
//  AionLumen
//
//  Created by Aoin Digital on 24/01/2025.
//
import Foundation
import AVFoundation
import SwiftData

class PlayerViewModel: ObservableObject {
    @Published var isPlaying: Bool = false
    @Published var currentTime: TimeInterval = 0
    @Published var duration: TimeInterval = 0
    @Published var transcription: String?
    
    private var audioPlayer: AVAudioPlayer?
    private var timer: Timer?
    
    /// Loads the audio file from the given file path.
    func loadAudio(filePath: String, id: String) {
        guard let url = URL(string: filePath) else { return }
        AudioRecorder.shared.setupAudioSession()
        let localPath =  AudioRecorder.shared.getDocumentsDirectory().appendingPathComponent(id).path
        let localURL = URL(fileURLWithPath: localPath)
        FileManager.default.fileExists(atPath: url.path) ? print("File exists at path: \(url.path)") :
        print("File does not exist at path: \(url.path)")
        self.startPlayer(with: localURL)
    }
    
    
    private func startPlayer(with url: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            duration = audioPlayer?.duration ?? 0
            audioPlayer?.prepareToPlay()
        } catch {
            print("Failed to initialize audio player: \(error.localizedDescription)")
        }
    }
    
    /// Starts or resumes audio playback and initializes the timer.
    func startPlayback() {
        guard let player = audioPlayer else { return }
        player.play()
        isPlaying = true
        startTimer()
    }
    
    /// Pauses audio playback and invalidates the timer.
    func stopPlayback() {
        guard let player = audioPlayer else { return }
        player.pause()
        isPlaying = false
        stopTimer()
    }
    
    /// Seeks to the specified time in the audio file.
    func seek(to time: TimeInterval) {
        guard let player = audioPlayer else { return }
        player.currentTime = time
        currentTime = time
    }
    
    /// Starts a timer to update the current playback time.
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self, let player = self.audioPlayer else { return }
            self.currentTime = player.currentTime
        }
    }
    
    /// Stops the timer.
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func transcribeAudio(for model: RecordingModel, context: ModelContext) {
        guard let audioFileURL = audioPlayer?.url else { return }
       
        if model.transcript != nil {
            self.transcription = model.transcript
            return
        } else {
            SpeechToTextEngine.shared.transcribeAudioFromFile(url: audioFileURL) { result in
                switch result {
                case .success(let response):
                    self.transcription = response
                    RecordingFileManager.shared.update(item: model,
                                                       context: context, transcript: response)
                case .failure(let failure):
                    print(failure)
                    return
                }
            }
        }
    }
}
