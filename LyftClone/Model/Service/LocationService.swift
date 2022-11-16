//
//  LocationService.swift
//  LyftClone
//
//  Created by Won Chak Leung on 27/10/2022.
//

import Foundation

class LocationService{
    static let shared = LocationService()
    
    private var recentLocations = [Location]()
    
    private init(){
        let locationsUrl = Bundle.main.url(forResource: "locations", withExtension: "json")!
        let data = try! Data(contentsOf: locationsUrl)
        let decoder = JSONDecoder()
        recentLocations = try! decoder.decode([Location].self, from: data)
    }
    
    func getRecentLocations() -> [Location]{
        return recentLocations
    }
}
