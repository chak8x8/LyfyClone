//
//  LocationCell.swift
//  LyftClone
//
//  Created by Won Chak Leung on 27/10/2022.
//

import UIKit
import MapKit


class LocationCell: UITableViewCell{
    
    @IBOutlet weak var addressLine1Label: UILabel!
    
    @IBOutlet weak var addressLine2Label: UILabel!
    
    func update(location: Location){
        addressLine1Label.text = location.title
        addressLine2Label.text = location.subtitle
    }
    
    func update(searchResult: MKLocalSearchCompletion) {
        addressLine1Label.text = searchResult.title
        addressLine2Label.text = searchResult.subtitle
    }
}
