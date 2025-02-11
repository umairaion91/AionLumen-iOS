//
//  RecordingFileManager.swift
//  AionLumen
//
//  Created by Aoin Digital on 23/01/2025.
//

import SwiftData
import Foundation


class RecordingFileManager {
    
    static var shared = RecordingFileManager()
    
    private init() {}
    
    
    func save(item: RecordingModel, context: ModelContext) {
        context.insert(item)
        do {
            try context.save()
        } catch {
            print("Error saving item: \(error.localizedDescription)")
        }
    }
    
    func update(item: RecordingModel, context: ModelContext, transcript: String) {
        item.transcript = transcript
        do {
            try context.save()
        } catch {
            print("Error saving item: \(error.localizedDescription)")
        }
    }
    
    func delete(items: [RecordingModel], offsets: IndexSet, context: ModelContext) {
        for index in offsets {
            context.delete(items[index])
        }
        do {
            try context.save()
        } catch {
            print("Error deleting items: \(error.localizedDescription)")
        }
    }
    
    func delete(from file: String = "recording.m4a") {
        let localPath = AudioRecorder.shared.getDocumentsDirectory().appendingPathComponent(file).path
        let localURL = URL(fileURLWithPath: localPath)
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: localPath) {
            do {
                try fileManager.removeItem(at: localURL)
                print("File deleted successfully.")
            } catch {
                print("Failed to delete file: \(error.localizedDescription)")
            }
        } else {
            print("File not found at path: \(localPath)")
        }
    }
}
