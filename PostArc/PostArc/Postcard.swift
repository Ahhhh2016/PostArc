import Foundation
import SwiftUI

struct Postcard: Identifiable, Codable, Hashable {
    let id: UUID
    var images: [UIImage]
    var fromWhere: String
    var toWhere: String
    var fromWho: String
    var toWho: String
    var description: String
    var date: Date 

    init(id: UUID = UUID(), images: [UIImage], fromWhere: String = "", toWhere: String = "",
         fromWho: String = "", toWho: String = "", description: String = "", date: Date = Date()) {
        self.id = id
        self.images = images
        self.fromWhere = fromWhere
        self.toWhere = toWhere
        self.fromWho = fromWho
        self.toWho = toWho
        self.description = description
        self.date = date
    }

    enum CodingKeys: String, CodingKey {
        case id, images, fromWhere, toWhere, fromWho, toWho, description, date
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(fromWhere, forKey: .fromWhere)
        try container.encode(toWhere, forKey: .toWhere)
        try container.encode(fromWho, forKey: .fromWho)
        try container.encode(toWho, forKey: .toWho)
        try container.encode(description, forKey: .description)
        try container.encode(date, forKey: .date)
        
        let imageData = images.map { $0.jpegData(compressionQuality: 0.8) }
        try container.encode(imageData, forKey: .images)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        fromWhere = try container.decode(String.self, forKey: .fromWhere)
        toWhere = try container.decode(String.self, forKey: .toWhere)
        fromWho = try container.decode(String.self, forKey: .fromWho)
        toWho = try container.decode(String.self, forKey: .toWho)
        description = try container.decode(String.self, forKey: .description)
        date = try container.decode(Date.self, forKey: .date)
        
        let imageData = try container.decode([Data].self, forKey: .images)
        images = imageData.compactMap { UIImage(data: $0) }
    }
}
