import Foundation
import SwiftUI

struct Postcard: Identifiable, Codable, Hashable {
    let id: UUID
    private var imageName1: String
    private var imageName2: String

    var image1: Image {
        Image(imageName1)
    }

    var image2: Image {
        Image(imageName2)
    }

    var fromWhere: String
    var toWhere: String
    var fromWho: String
    var toWho: String
    var description: String
    var date: Date

    init(id: UUID = UUID(), imageName1: String = "", imageName2: String = "", fromWhere: String = "", toWhere: String = "",
         fromWho: String = "", toWho: String = "", description: String = "", date: Date = Date()) {
        self.id = id
        self.imageName1 = imageName1
        self.imageName2 = imageName2
        self.fromWhere = fromWhere
        self.toWhere = toWhere
        self.fromWho = fromWho
        self.toWho = toWho
        self.description = description
        self.date = date
    }

    // CodingKeys, update to include imageName1 and imageName2
    enum CodingKeys: String, CodingKey {
        case id, imageName1, imageName2, fromWhere, toWhere, fromWho, toWho, description, date
    }

    // Encode method: Encode image names and other properties
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(imageName1, forKey: .imageName1)
        try container.encode(imageName2, forKey: .imageName2)
        try container.encode(fromWhere, forKey: .fromWhere)
        try container.encode(toWhere, forKey: .toWhere)
        try container.encode(fromWho, forKey: .fromWho)
        try container.encode(toWho, forKey: .toWho)
        try container.encode(description, forKey: .description)
        try container.encode(date, forKey: .date)
    }

    // Decode method: Decode image names and other properties
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        imageName1 = try container.decode(String.self, forKey: .imageName1)
        imageName2 = try container.decode(String.self, forKey: .imageName2)
        fromWhere = try container.decode(String.self, forKey: .fromWhere)
        toWhere = try container.decode(String.self, forKey: .toWhere)
        fromWho = try container.decode(String.self, forKey: .fromWho)
        toWho = try container.decode(String.self, forKey: .toWho)
        description = try container.decode(String.self, forKey: .description)
        date = try container.decode(Date.self, forKey: .date)
    }
}
