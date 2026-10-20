//
//  TestAPIService.swift
//  CancunConcierge
//
//  Created by luisr on 19/10/26.
//
import Foundation

final class TestAPIService {
    
    func fetchArticle() async throws -> TestArticleResponse {
        
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts/1")!
        
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,(200...299).contains(httpResponse.statusCode) else {
            
            throw URLError(.badServerResponse)
        }
        
        let article =  try JSONDecoder().decode(TestArticleResponse.self, from: data)
        
        return article
    }
}
