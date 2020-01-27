//
//  UEQFeatureModel.swift
//  USGSEarthQuakes
//
//  Created by Sreekanth Ruthala on 1/26/20.
//  Copyright © 2020 Sreekanth Ruthala. All rights reserved.
//

import Foundation

struct UEQFeatureModel: Decodable {
    
    let properties: UEQFeaturePropertyModel
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case properties
        case id
    }
    
    init(properties: UEQFeaturePropertyModel, id: String) {
        self.properties = properties
        self.id = id
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let properties = try container.decode(UEQFeaturePropertyModel.self, forKey: .properties)
        let id = try container.decode(String.self, forKey: .id)
        self.init(properties: properties, id: id)
    }
}
