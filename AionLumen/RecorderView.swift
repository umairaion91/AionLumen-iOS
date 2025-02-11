//
//  RecorderView.swift
//  AionLumen
//
//  Created by Aoin Digital on 23/01/2025.
//

import SwiftUI
import SwiftData

struct RecorderView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query private var recordings: [RecordingModel]
    @ObservedObject var viewModel = RecordingViewModel()
    
   
    var body: some View {
        VStack(spacing: 20) {
            NavigationStack {
                VStack(spacing: 20) {
                    Text("Duration: \(viewModel.recordingDuration)")
                        .padding(.top, 30)
                        .font(.headline)
                    if viewModel.isRecording {
                        Button(action: {
                            withAnimation {
                                viewModel.stopRecording(with: modelContext)
                            }
                        }) {
                            Text("Stop Recording")
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                    else {
                        Button(action: {
                            viewModel.startRecording()
                        }) {
                            Text("Start Recording")
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                }
                
                List {
                    ForEach(recordings) { record in
                        NavigationLink(destination: RecordingDetailView(record: record)) {
                            VStack(alignment: .leading) {
                                Text("Recording at: \(record.timestamp)")
                                    .font(.subheadline)
                                Text(record.filePath)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .onDelete { offsets in
                        RecordingFileManager.shared.delete(
                            items: recordings,
                            offsets: offsets,
                            context: modelContext
                        )
                        //RecordingFileManager.shared.delete(from: )
                    }
                }
                .navigationTitle("Aion Lumen's")
            }
        }
        .padding()
        .navigationTitle("Lumen")
    }
}

#Preview {
    RecorderView()
}
