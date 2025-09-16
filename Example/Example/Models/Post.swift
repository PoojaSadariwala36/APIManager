//
//  Post.swift
//  SampleApp
//
//  Created by APIManager on 15/09/25.
//

import Foundation

struct Post: Codable, Identifiable {
    let id: Int
    let userId: Int
    let title: String
    let body: String
}
