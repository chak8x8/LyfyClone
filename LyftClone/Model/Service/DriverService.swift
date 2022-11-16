//
//  DriverService.swift
//  LyftClone
//
//  Created by Won Chak Leung on 7/11/2022.
//

import Foundation
import CoreLocation

class DriverService{
   
    static let shared = DriverService()
    
    private init(){}
    
    func getDriver(pickupLocation: Location) -> (Driver, Int) {
        
        let locations = LocationService.shared.getRecentLocations()
        let randomLocation = locations[Int(arc4random_uniform(UInt32(locations.count)))]
        let coordinate = CLLocationCoordinate2D(latitude: randomLocation.latitude, longitude: randomLocation.longitude)
        
        let driver = Driver(name: "Alicia Castillo", thumbnail: "driver", licenseNumber: "7WB312S", rating: 5.0, car: "Hyundai Sonata", coordinate: coordinate)
        return (driver, 10)
    }
}
