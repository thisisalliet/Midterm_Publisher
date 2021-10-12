//
//  Model.swift
//  Midterm
//
//  Created by Allie T on 2021/10/12.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

// MARK: - Collections -
enum CollectionName: String {
    
    case articles = "Articles"
}

// MARK: - Collection Structure -
// send to Articles
public struct Post: Codable {
    
    let author: String
    let category: String
    let content: String
    let time: Timestamp
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case author
        case category
        case content
        case time
        case title
    }
}
