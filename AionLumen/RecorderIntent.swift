//
//  RecorderIntent.swift
//  AionLumen
//
//  Created by Aoin Digital on 23/01/2025.
//

import AppIntents

struct StartRecordingIntent: AppIntent {
    
    static var title: LocalizedStringResource = "start aion lumen"

    func perform() async throws -> some IntentResult {
        await MainActor.run {
            SpeechToTextEngine.shared.startRecording { text, error in
                if let text = text {
                    print("Recorded Text: \(text)")
                } else if let error = error {
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
        print("Recording started via AppIntent.")
        return .result()
    }
}
