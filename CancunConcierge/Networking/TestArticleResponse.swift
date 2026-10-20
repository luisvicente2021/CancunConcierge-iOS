//
//  TestArticleResponse.swift
//  CancunConcierge
//
//  Created by luisr on 19/10/26.
//

import Foundation

struct TestArticleResponse: Decodable {
    
    let userId: Int
    let id: Int
    let title: String
    let body: String
    
}

