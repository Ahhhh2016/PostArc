//
//  Postcard.swift
//  PostArc
//
//  Created by Yixuan Liu on 8/12/24.
//

import SwiftUI

struct Postcard: Identifiable, Codable, Equatable {
    let id: UUID
    var image: UIImage
    var fromWhere: String
    var toWhere: String
    var fromWho: String
    var toWho: String
    var description: String

    init(id: UUID = UUID(), image: UIImage, fromWhere: String = "", toWhere: String = "",
         fromWho: String = "", toWho: String = "", description: String = "") {
        self.id = id
        self.image = image
        self.fromWhere = fromWhere
        self.toWhere = toWhere
        self.fromWho = fromWho
        self.toWho = toWho
        self.description = description
    }

    // Encoding/decoding the UIImage as Data
    enum CodingKeys: String, CodingKey {
        case id, imageData, fromWhere, toWhere, fromWho, toWho, description
    }

    var imageData: Data? {
        return image.jpegData(compressionQuality: 0.8)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        let imageData = try container.decode(Data.self, forKey: .imageData)
        image = UIImage(data: imageData) ?? UIImage()
        fromWhere = try container.decode(String.self, forKey: .fromWhere)
        toWhere = try container.decode(String.self, forKey: .toWhere)
        fromWho = try container.decode(String.self, forKey: .fromWho)
        toWho = try container.decode(String.self, forKey: .toWho)
        description = try container.decode(String.self, forKey: .description)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        if let imageData = imageData {
            try container.encode(imageData, forKey: .imageData)
        }
        try container.encode(fromWhere, forKey: .fromWhere)
        try container.encode(toWhere, forKey: .toWhere)
        try container.encode(fromWho, forKey: .fromWho)
        try container.encode(toWho, forKey: .toWho)
        try container.encode(description, forKey: .description)
    }
}
