//
//  Event.swift
//  SicrediChallenge
//
//  Created by Diego Rodrigues Abdala Uthman on 05/03/22.
//

import UIKit

public struct Event: Codable {
    var id: String
    var date: Int64
    var description: String
    var latitude: Double
    var longitude: Double
    var price: Double
    var title: String
    var image: String 
}
