//
//  PostArcData.swift
//  PostArc
//
//  Created by Yixuan Liu on 8/12/24.
//

import Foundation
import SwiftUI

class PostcardData: ObservableObject {
    @Published var images: [UIImage] = []

    private let fileManager = FileManager.default
    private let folderName = "PostArc"
    
    init() {
        loadImages()
    }
    
    func addImage(_ image: UIImage) {
        images.append(image)
        saveImage(image)
    }

    private func saveImage(_ image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return }

        do {
            let directory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(folderName)

            if !fileManager.fileExists(atPath: directory.path) {
                try fileManager.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
            }

            let fileName = UUID().uuidString
            let fileURL = directory.appendingPathComponent(fileName).appendingPathExtension("jpg")

            try data.write(to: fileURL)
        } catch {
            print("Error saving image: \(error)")
        }
    }

    private func loadImages() {
        do {
            let directory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(folderName)

            let fileURLs = try fileManager.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil)

            for fileURL in fileURLs {
                if let data = try? Data(contentsOf: fileURL), let image = UIImage(data: data) {
                    images.append(image)
                }
            }
        } catch {
            print("Error loading images: \(error)")
        }
    }
}
