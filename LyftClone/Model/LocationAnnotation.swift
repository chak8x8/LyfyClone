//
//  LocationAnnotation.swift
//  LyftClone
//
//  Created by Won Chak Leung on 3/11/2022.
//

import Foundation
import MapKit

class LocationAnnotation: NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    
    var locationType: String
    
    init(coordinate: CLLocationCoordinate2D, locationType: String) {
        self.coordinate = coordinate
        self.locationType = locationType
    }
    
    
}
