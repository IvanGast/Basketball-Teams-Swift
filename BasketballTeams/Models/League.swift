//
//  League.swift
//  BasketballTeams
//
//  Created by Ivan on 24/07/2019.
//  Copyright © 2019 Ivan. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

class League: Object, Decodable {
    @objc dynamic var id: String? = ""
    @objc dynamic var league: String? = ""
    @objc dynamic var sport: String? = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "idLeague"
        case league = "strLeague"
        case sport = "strSport"
    }
    
    convenience init(_ id: String?, _ league: String?, _ sport: String?) {
        self.init()
        self.id = id
        self.league = league
        self.sport = sport
    }
    
    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let sport = try container.decodeIfPresent(String.self, forKey: .sport)
        let league = try container.decodeIfPresent(String.self, forKey: .league)
        let id = try container.decodeIfPresent(String.self, forKey: .id)
        self.init(id, league, sport)
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
struct LeagueList: Decodable {
    let leagues: [League]
}
