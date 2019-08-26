//
//  Gameas.swift
//  BasketballTeams
//
//  Created by Ivan on 15/07/2019.
//  Copyright © 2019 Ivan. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class Game: Object, Decodable {
    @objc dynamic var id: String? = ""
    @objc dynamic var date: String? = ""
    @objc dynamic var oponent: String? = ""
    @objc dynamic var home: String? = ""
    @objc dynamic var teamId: String? = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "idEvent"
        case date = "dateEvent"
        case oponent = "strAwayTeam"
        case home = "strHomeTeam"
        case teamId = "idHomeTeam"
    }
    
    convenience init(_ id: String?, _ date: String?, _ oponent: String?, _ home: String?, _ teamId: String?) {
        self.init()
        self.id = (id ?? "") + (teamId ?? "")
        self.date = date
        self.oponent = oponent
        self.home = home
        self.teamId = teamId
    }
    
     convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let date = try container.decodeIfPresent(String.self, forKey: .date)
        let oponent = try container.decodeIfPresent(String.self, forKey: .oponent)
        let home = try container.decodeIfPresent(String.self, forKey: .home)
        let teamId = try container.decodeIfPresent(String.self, forKey: .teamId)
        let id = try container.decodeIfPresent(String.self, forKey: .id)
        self.init(id, date, oponent, home, teamId)
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
struct GameList: Decodable {
    let results: [Game]
}
