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
    
    func addPostcard(_ images: [UIImage], fromWhere: String = "", toWhere: String = "",
                     fromWho: String = "", toWho: String = "", description: String = "", date: Date = Date()) {
        let newPostcard = Postcard(images: images, fromWhere: fromWhere, toWhere: toWhere,
                                   fromWho: fromWho, toWho: toWho, description: description, date: date)
        postcards.append(newPostcard)
        savePostcards()
    }

    func deletePostcard(at offsets: IndexSet) {
        offsets.forEach { index in
            deleteImages(postcards[index].id)
        }
        postcards.remove(atOffsets: offsets)
        savePostcards()
    }

    func updatePostcard(_ postcard: Postcard, fromWhere: String = "", toWhere: String = "",
                        fromWho: String = "", toWho: String = "", description: String = "", date: Date) {
        if let index = postcards.firstIndex(of: postcard) {
            postcards[index].fromWhere = fromWhere
            postcards[index].toWhere = toWhere
            postcards[index].fromWho = fromWho
            postcards[index].toWho = toWho
            postcards[index].description = description
            postcards[index].date = date
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

            // Save each postcard's images
            for postcard in postcards {
                saveImages(postcard)
            }
        } catch {
            print("Error saving postcards: \(error)")
        }
    }

    private func saveImages(_ postcard: Postcard) {
        do {
            let directory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(folderName)

            if !fileManager.fileExists(atPath: directory.path) {
                try fileManager.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
            }

            for (index, image) in postcard.images.enumerated() {
                guard let data = image.jpegData(compressionQuality: 0.8) else { continue }
                let fileURL = directory.appendingPathComponent("\(postcard.id.uuidString)-\(index)").appendingPathExtension("jpg")
                try data.write(to: fileURL)
            }
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
                postcards[index].images = loadImages(for: postcards[index].id)
            }
        } catch {
            print("Error loading postcards: \(error)")
        }
    }

    private func loadImages(for id: UUID) -> [UIImage] {
        var images = [UIImage]()
        let directory = try? fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(folderName)

        if let directory = directory {
            for i in 0..<2 { // Assuming max 2 images per postcard
                let fileURL = directory.appendingPathComponent("\(id.uuidString)-\(i)").appendingPathExtension("jpg")
                if let imageData = try? Data(contentsOf: fileURL), let image = UIImage(data: imageData) {
                    images.append(image)
                }
            }
        }
        return images
    }

    private func deleteImages(_ id: UUID) {
        do {
            let directory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(folderName)

            for i in 0..<2 { // Assuming max 2 images per postcard
                let fileURL = directory.appendingPathComponent("\(id.uuidString)-\(i)").appendingPathExtension("jpg")
                if fileManager.fileExists(atPath: fileURL.path) {
                    try fileManager.removeItem(at: fileURL)
                }
            }
        } catch {
            print("Error deleting images: \(error)")
        }
    }
}
