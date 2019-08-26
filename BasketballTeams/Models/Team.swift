//
//  Teamas.swift
//  BasketballTeams
//
//  Created by Ivan on 15/07/2019.
//  Copyright © 2019 Ivan. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class Team: Object, Decodable {
    @objc dynamic var superId: String? = ""
    @objc dynamic var leagueId: String? = ""
    @objc dynamic var id: String? = ""
    @objc dynamic var country: String? = ""
    @objc dynamic var name: String? = ""
    @objc dynamic var descriptionTeam: String? = ""
    @objc dynamic var badgeUrl: String? = ""
    @objc dynamic var stadiumUrl: String? = ""
    
    override static func primaryKey() -> String? {
        return "superId"
    }
    
    enum CodingKeys: String, CodingKey {
        case leagueId = "idLeague"
        case id = "idTeam"
        case country = "strCountry"
        case name = "strTeam"
        case descriptionTeam = "strDescriptionEN"
        case badgeUrl = "strTeamBadge"
        case stadiumUrl = "strStadiumThumb"
    }
    
    convenience init(_ leagueId: String?, _ id: String?, _ country: String?, _ name: String?, _ descriptionTeam: String?, _ badgeUrl: String?, _ stadiumUrl: String?) {
        self.init()
        self.superId = (leagueId ?? "") + (id ?? "")
        self.leagueId = leagueId
        self.id = id
        self.country = country
        self.name = name
        self.descriptionTeam = descriptionTeam
        self.badgeUrl = badgeUrl
        self.stadiumUrl =  stadiumUrl
    }
    
    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decodeIfPresent(String.self, forKey: .id)
        let leagueId = (try container.decodeIfPresent(String.self, forKey: .leagueId) ?? "")
        let country = try container.decodeIfPresent(String.self, forKey: .country)
        let name = try container.decodeIfPresent(String.self, forKey: .name)
        let descriptionTeam = try container.decodeIfPresent(String.self, forKey: .descriptionTeam)
        let badgeUrl = try container.decodeIfPresent(String.self,forKey: .badgeUrl)
        let stadiumUrl =  try container.decodeIfPresent(String.self,forKey: .stadiumUrl)
        self.init(leagueId, id, country, name, descriptionTeam, badgeUrl, stadiumUrl)
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
struct TeamList: Decodable {
    let teams: [Team]
}
