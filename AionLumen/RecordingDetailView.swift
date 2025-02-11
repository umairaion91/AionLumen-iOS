//
//  RecordingDetailView.swift
//  AionLumen
//
//  Created by Aoin Digital on 24/01/2025.
//
import SwiftUI

struct RecordingDetailView: View {
    let record: RecordingModel
    @StateObject private var viewModel = PlayerViewModel()
    @Environment(\.modelContext) private var modelContext
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Recording Details")
                .font(.headline)
            
            Text("Timestamp: \(record.timestamp)")
                .font(.subheadline)
            
            Text("File Path: \(record.filePath)")
                .font(.caption)
                .foregroundColor(.gray)
            
            Spacer()
            
            VStack {
                Slider(
                    value: Binding(
                        get: { viewModel.currentTime },
                        set: { newValue in
                            viewModel.seek(to: newValue)
                        }
                    ),
                    in: 0...viewModel.duration
                )
                .padding()
                
                HStack {
                    Text(formatTime(viewModel.currentTime))
                        .font(.caption)
                    Spacer()
                    Text(formatTime(viewModel.duration))
                        .font(.caption)
                }
                .padding(.horizontal)
            }
            
            HStack {
                Button(action: {
                    if viewModel.isPlaying {
                        viewModel.stopPlayback()
                    } else {
                        viewModel.startPlayback()
                    }
                }) {
                    Text(viewModel.isPlaying ? "Pause" : "Play")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(viewModel.isPlaying ? Color.red : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Transcription")
                    .font(.headline)
                
                if let transcription = viewModel.transcription {
                    ScrollView {
                        Text(transcription)
                            .font(.body)
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(8)
                    }
                } else {
                    Text("Transcription not available.")
                        .font(.body)
                        .foregroundColor(.gray)
                }
            }
            .padding()
            
            Spacer()
        }
        .padding()
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.loadAudio(filePath: record.filePath, id: record.timestamp)
            viewModel.transcribeAudio(for: record, context: modelContext)
        }
    }
}
