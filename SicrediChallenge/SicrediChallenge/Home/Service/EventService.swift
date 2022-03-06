//
//  EventService.swift
//  SicrediChallenge
//
//  Created by Diego Rodrigues Abdala Uthman on 05/03/22.
//

import UIKit

class EventService {
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
    
    func fetchEventById(id: String, completion: @escaping (Result<Event, Error>) -> Void) {
        let url = URL(string: "https://5f5a8f24d44d640016169133.mockapi.io/api/events/\(id)")!
        
        let task = URLSession.shared.dataTask(with: url) { data, response, sessionError in
            if let error  = sessionError {
                completion(.failure(error))
            }
            let decoder = JSONDecoder()
            do{
                let response = try decoder.decode(Event.self, from: data ?? Data())
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func checkIn(checkIn: CheckIn, completion: @escaping (Error?) -> Void) {
        let url = URL(string: "https://5f5a8f24d44d640016169133.mockapi.io/api/checkin")!
        
        var request = URLRequest(
            url: url,
            cachePolicy: .reloadIgnoringLocalCacheData
        )
        
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: checkIn.asDictionary(), options: .prettyPrinted)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                if (200 ..< 300).contains(httpResponse.statusCode) {
                    completion(nil)
                } else {
                    completion(NSError(domain: "Ocorreu um erro ao fazer o check-in", code: httpResponse.statusCode))
                }
            } else {
                completion(NSError(domain: "Ocorreu um erro ao fazer o check-in", code: 500))
            }
        }
        task.resume()
    }
}
