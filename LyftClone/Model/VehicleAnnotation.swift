//
//  VehicleAnnotation.swift
//  LyftClone
//
//  Created by Won Chak Leung on 28/10/2022.
//

import MapKit

class VehicleAnnotation: NSObject, MKAnnotation{
    
    var coordinate: CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    
    
}
