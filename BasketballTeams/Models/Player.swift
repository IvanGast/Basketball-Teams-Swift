//
//  Playeri.swift
//  BasketballTeams
//
//  Created by Ivan on 15/07/2019.
//  Copyright © 2019 Ivan. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class Player: Object {
    @objc dynamic var id: String? = ""
    @objc dynamic var teamId: String? = ""
    @objc dynamic var position: String? = ""
    @objc dynamic var name: String? = ""
    @objc dynamic var descriptionPlayer: String? = ""
    @objc dynamic var weight: String? = ""
    @objc dynamic var height: String? = ""
    @objc dynamic var date: String? = ""
    @objc dynamic var cutoutUrl: String? = ""
    @objc dynamic var thumbUrl: String? = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(_ id: String?,_ teamId: String?, _ position: String?, _ name: String?, _ descriptionPlayer: String?, _ weight:                       String?, _ height: String?, _ date: String?, _ cutoutUrl: String?, _ thumbUrl: String?) {
        self.init()
        self.id = id
        self.teamId = teamId
        self.position = position
        self.name = name
        self.date = date
        self.descriptionPlayer = descriptionPlayer
        self.weight = weight
        self.height = height
        self.cutoutUrl = cutoutUrl
        self.thumbUrl = thumbUrl
    }
    
    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let teamId = try container.decodeIfPresent(String.self, forKey: .teamId)
        let position = try container.decodeIfPresent(String.self, forKey: .position)
        let descriptionPlayer = try container.decodeIfPresent(String.self, forKey: .descriptionPlayer)
        let name = try container.decodeIfPresent(String.self, forKey: .name)
        let weight = try container.decodeIfPresent(String.self, forKey: .weight)
        let height = try container.decodeIfPresent(String.self, forKey: .height)
        let date = try container.decodeIfPresent(String.self, forKey: .date)
        let cutoutUrl = try container.decodeIfPresent(String.self, forKey: .cutoutUrl)
        let thumbUrl = try container.decodeIfPresent(String.self, forKey: .thumbUrl)
        let id = try container.decodeIfPresent(String.self, forKey: .id)
        self.init(id, teamId, position, name, descriptionPlayer, weight, height, date, cutoutUrl, thumbUrl)
    }
    
    required init() {
        super.init()
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
}
extension Player: Decodable {
    enum CodingKeys: String, CodingKey {
        case id = "idPlayer"
        case teamId = "idTeam"
        case position = "strPosition"
        case name = "strPlayer"
        case descriptionPlayer = "strDescriptionEN"
        case weight = "strWeight"
        case height = "strHeight"
        case date = "dateBorn"
        case cutoutUrl = "strCutout"
        case thumbUrl = "strThumb"
    }
}
struct PlayerList : Decodable {
    let player: [Player]
}

