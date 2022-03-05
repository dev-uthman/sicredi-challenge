//
//  HomeService.swift
//  SicrediChallenge
//
//  Created by Diego Rodrigues Abdala Uthman on 05/03/22.
//

import UIKit

class HomeService {
    func fetchEvent(completion: @escaping (Result<[Event], Error>) -> Void) {
        let url = URL(string: "https://5f5a8f24d44d640016169133.mockapi.io/api/events")!
        
        let task = URLSession.shared.dataTask(with: url) { data, response, sessionError in
            if let error  = sessionError {
                completion(.failure(error))
            }
            let decoder = JSONDecoder()
            do{
                let response = try decoder.decode([Event].self, from: data ?? Data())
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
