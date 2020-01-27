//
//  UEQFeaturePropertyModel.swift
//  USGSEarthQuakes
//
//  Created by Sreekanth Ruthala on 1/26/20.
//  Copyright © 2020 Sreekanth Ruthala. All rights reserved.
//

import Foundation

struct UEQFeaturePropertyModel: Decodable {
    let mag: Float
    let place: String
    let url: String
    let title: String
        
    enum CodingKeys: String, CodingKey {
        case mag
        case place
        case url
        case title
    }
    
    init(magnitude: Float, place: String, url: String, title: String) {
        self.mag = magnitude
        self.place = place
        self.url = url
        self.title = title
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let magnitude = try container.decode(Float.self, forKey: .mag)
        let place = try container.decode(String.self, forKey: .place)
        let url = try container.decode(String.self, forKey: .url)
        let title = try container.decode(String.self, forKey: .title)
        self.init(magnitude: magnitude, place: place, url: url, title: title)
    }
}
