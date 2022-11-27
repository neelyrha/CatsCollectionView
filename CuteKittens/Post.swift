//
//  Post.swift
//  CuteKittens
//
//  Created by Neely Rhaego on 11/14/22.
//

import Foundation

struct PostUserProfileImage: Codable {
    let small: String
    let medium: String
}

struct PostUser: Codable {
    let profileImage: PostUserProfileImage
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
    
}

struct PostUrls: Codable {
    let regular: String
}

struct Post: Codable {
    let id: String
    let description: String?
    let user: PostUser
    let urls: PostUrls
}
