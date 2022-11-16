//
//  Location.swift
//  LyftClone
//
//  Created by Won Chak Leung on 27/10/2022.
//

import Foundation
import MapKit

class Location: Codable{
    var title: String
    var subtitle: String
    let latitude: Double
    let longitude: Double

    init(title: String, subtitle: String, latitude: Double, longitude: Double) {
        self.title = title
        self.subtitle = subtitle
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(placemark: MKPlacemark){
        self.title = placemark.name ?? ""
        self.subtitle = placemark.title ?? ""
        self.latitude = placemark.coordinate.latitude
        self.longitude = placemark.coordinate.longitude
    }
}
