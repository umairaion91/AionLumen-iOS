//
//  RecordingModel.swift
//  AionLumen
//
//  Created by Aoin Digital on 23/01/2025.
//

import SwiftData
import Foundation

@Model
final class RecordingModel {
    
    @Attribute(.unique) var id: UUID
    var filePath: String
    var timestamp: String
    var transcript: String?
    
    init(filePath: String, timestamp: String, transcript: String? = nil) {
        self.id = UUID()
        self.filePath = filePath
        self.timestamp = timestamp
        self.transcript = transcript
    }
}


