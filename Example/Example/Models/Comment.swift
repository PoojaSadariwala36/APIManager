//
//  Comment.swift
//  SampleApp
//
//  Created by APIManager on 15/09/25.
//

import Foundation

struct Comment: Codable, Identifiable {
    let id: Int
    let postId: Int
    let name: String
    let email: String
    let body: String
}
