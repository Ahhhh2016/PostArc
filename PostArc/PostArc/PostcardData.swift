//
//  PostArcData.swift
//  PostArc
//
//  Created by Yixuan Liu on 8/12/24.
//

import Foundation
import SwiftUI

class PostcardData: ObservableObject {
    @Published var postcards: [Postcard] = []

    private let fileManager = FileManager.default
    private let folderName = "PostArc"
    private let jsonFileName = "postcards.json"
    
    init() {
        loadPostcards()
    }
    
    func addPostcard(_ image: UIImage, fromWhere: String = "", toWhere: String = "",
                     fromWho: String = "", toWho: String = "", description: String = "") {
        let newPostcard = Postcard(image: image, fromWhere: fromWhere, toWhere: toWhere,
                                   fromWho: fromWho, toWho: toWho, description: description)
        postcards.append(newPostcard)
        savePostcards()
    }

    func deletePostcard(at offsets: IndexSet) {
        offsets.forEach { index in
            deleteImage(postcards[index].id)
        }
        postcards.remove(atOffsets: offsets)
        savePostcards()
    }

    func updatePostcard(_ postcard: Postcard, fromWhere: String = "", toWhere: String = "",
                        fromWho: String = "", toWho: String = "", description: String = "") {
        if let index = postcards.firstIndex(of: postcard) {
            postcards[index].fromWhere = fromWhere
            postcards[index].toWhere = toWhere
            postcards[index].fromWho = fromWho
            postcards[index].toWho = toWho
            postcards[index].description = description
            savePostcards()
        }
    }

    private func savePostcards() {
        do {
            let directory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(folderName)

            if !fileManager.fileExists(atPath: directory.path) {
                try fileManager.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
            }

            let fileURL = directory.appendingPathComponent(jsonFileName)
            let jsonData = try JSONEncoder().encode(postcards)
            try jsonData.write(to: fileURL)

            // Save each postcard's image
            for postcard in postcards {
                saveImage(postcard)
            }
        } catch {
            print("Error saving postcards: \(error)")
        }
    }

    private func saveImage(_ postcard: Postcard) {
        guard let data = postcard.image.jpegData(compressionQuality: 0.8) else { return }

        do {
            let directory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(folderName)

            let fileURL = directory.appendingPathComponent(postcard.id.uuidString).appendingPathExtension("jpg")
            try data.write(to: fileURL)
        } catch {
            print("Error saving image: \(error)")
        }
    }

    private func loadPostcards() {
        do {
            let directory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(folderName)

            let fileURL = directory.appendingPathComponent(jsonFileName)
            let jsonData = try Data(contentsOf: fileURL)
            postcards = try JSONDecoder().decode([Postcard].self, from: jsonData)

            // Load images for each postcard
            for index in postcards.indices {
                let imageFileURL = directory.appendingPathComponent(postcards[index].id.uuidString).appendingPathExtension("jpg")
                if let imageData = try? Data(contentsOf: imageFileURL), let image = UIImage(data: imageData) {
                    postcards[index].image = image
                }
            }
        } catch {
            print("Error loading postcards: \(error)")
        }
    }

    private func deleteImage(_ id: UUID) {
        do {
            let directory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(folderName)

            let fileURL = directory.appendingPathComponent(id.uuidString).appendingPathExtension("jpg")
            if fileManager.fileExists(atPath: fileURL.path) {
                try fileManager.removeItem(at: fileURL)
            }
        } catch {
            print("Error deleting image: \(error)")
        }
    }
}
