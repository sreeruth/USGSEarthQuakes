//
//  UEQRequestAPI.swift
//  USGSEarthQuakes
//
//  Created by Sreekanth Ruthala on 1/26/20.
//  Copyright © 2020 Sreekanth Ruthala. All rights reserved.
//

import Foundation

enum UEQRequestAPI: Int {
    case count
    case query
    
    func endpoint() -> String {
        switch self {
        case .count:
            return "https://earthquake.usgs.gov/fdsnws/event/1/count?format=geojson"
        case .query:
            return "https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson"
        }
    }
    
    func buildURL(startTime: String, and endTime: String) -> URL? {
        var endpoint = self.endpoint()
        endpoint += "&starttime=" + startTime + "&endtime=" + endTime
        return URL.init(string: endpoint)
    }
    
    func buildURL(eventId: String) -> URL? {
        var endpoint = self.endpoint()
        guard self != .count else { return nil }
        
        endpoint += "&eventid=" + eventId
        return URL.init(string: endpoint)
    }
}
