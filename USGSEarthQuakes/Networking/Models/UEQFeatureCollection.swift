//
//  UEQFeatureCollection.swift
//  USGSEarthQuakes
//
//  Created by Sreekanth Ruthala on 1/27/20.
//  Copyright © 2020 Sreekanth Ruthala. All rights reserved.
//

import Foundation

struct UEQFeatureCollection: Decodable {
    let features: [UEQFeatureModel]
    
    enum CodingKeys: String, CodingKey {
        case features
    }
    
    init(features: [UEQFeatureModel]) {
        self.features = features
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let features = try container.decode([UEQFeatureModel].self, forKey: .features)
        self.init(features: features)
    }
}
