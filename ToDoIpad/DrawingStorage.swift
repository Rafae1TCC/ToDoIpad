//
//  DrawingStorage.swift
//  ToDoIpad
//
//  Created by Rafael Cabrera on 10/20/26.
//


import UIKit

enum DrawingStorage {
    private static func url(for fileName: String) -> URL {
        URL.documentsDirectory.appendingPathComponent(fileName)
    }

    static func save(_ image: UIImage) -> String? {
        guard let data = image.pngData() else { return nil }
        let fileName = UUID().uuidString + ".png"
        do {
            try data.write(to: url(for: fileName))
            return fileName
        } catch {
            return nil
        }
    }

    static func load(_ fileName: String) -> UIImage? {
        UIImage(contentsOfFile: url(for: fileName).path)
    }

    static func delete(_ fileName: String) {
        try? FileManager.default.removeItem(at: url(for: fileName))
    }
}