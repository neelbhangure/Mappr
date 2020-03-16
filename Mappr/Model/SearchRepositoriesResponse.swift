//
//  SearchRepositoriesResponse.swift
//  Mappr
//
//  Created by neel on 14/03/20.
//  Copyright © 2020 neel. All rights reserved.
//

import Foundation
protocol Base {
     
}
struct GitHubRepository: Codable , Base{
    public let id: Int
    public let watchersCount : Int
    public let fullName : String?
    public let name : String?
    public let commitcount : Int?
    public let forks : Int?
    public let owner : SearchRepositoriesOwner?
    public let contributersUrl : String?
     public let description : String?
    public let url : String?
    public let language : String?
    private enum CodingKeys: String, CodingKey {
        case description , url = "html_url"
        case forks , language
        case id
        case watchersCount = "watchers_count"
        case fullName = "full_name"
        case owner
        case name
        case commitcount = "stargazers_count"
        case contributersUrl = "contributors_url"
    }
}

struct SearchRepositoriesResponse: Codable {
    let items: [GitHubRepository]
}

public struct SearchRepositoriesOwner : Codable {
    public let avatarUrl : String?
    public let gravatarId : String?
    public let id : Int?
    public let login : String?
    public let receivedEventsUrl : String?
    public let type : String?
    public let url : String?
    
    enum CodingKeys: String, CodingKey {
        case avatarUrl = "avatar_url"
        case gravatarId = "gravatar_id"
        case id
        case login
        case receivedEventsUrl = "received_events_url"
        case type
        case url
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        avatarUrl = try values.decodeIfPresent(String.self, forKey: .avatarUrl)
        gravatarId = try values.decodeIfPresent(String.self, forKey: .gravatarId)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        login = try values.decodeIfPresent(String.self, forKey: .login)
        receivedEventsUrl = try values.decodeIfPresent(String.self, forKey: .receivedEventsUrl)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        url = try values.decodeIfPresent(String.self, forKey: .url)
    }
}
