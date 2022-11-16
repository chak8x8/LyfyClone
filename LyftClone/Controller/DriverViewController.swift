//
//  DriverViewController.swift
//  LyftClone
//
//  Created by Won Chak Leung on 8/11/2022.
//

import UIKit
import MapKit

class DriverViewController: UIViewController, MKMapViewDelegate{
    
    var pickupLocation: Location!
    
    var dropoffLocation: Location!
    
    
    @IBOutlet weak var etaLabel: UILabel!
    
    @IBOutlet weak var driverNameLabel: UILabel!
    
    @IBOutlet weak var carLabel: UILabel!
    
    @IBOutlet weak var ratingImageView: UIImageView!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var carImageView: UIImageView!
    
    @IBOutlet weak var licenseLabel: UILabel!
    
    @IBOutlet weak var driverImageView: UIImageView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var backButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        driverImageView.layer.cornerRadius = driverImageView.frame.size.width / 2.0
        licenseLabel.layer.cornerRadius = 15.0
        licenseLabel.layer.borderColor = UIColor.gray.cgColor
        licenseLabel.layer.borderWidth = 1.0
        backButton.layer.cornerRadius = backButton.frame.size.width / 2.0
        
//        For testing purpose:
//        let locations = LocationService.shared.getRecentLocations()
//        pickupLocation = locations[0]
//        dropoffLocation = locations[1]
        
        let (driver, eta) = DriverService.shared.getDriver(pickupLocation: pickupLocation)
        
        etaLabel.text = "ARRIVES IN \(eta) MIN"
        driverNameLabel.text = driver.name
        carLabel.text = driver.car
        
        let ratingString = String(format: "%.1f", driver.rating)
        ratingImageView.image = UIImage(named: "rating-\(ratingString)")
        ratingLabel.text = ratingString
        carImageView.image = UIImage(named: driver.car)
        driverImageView.image = UIImage(named: driver.thumbnail)
        licenseLabel.text = driver.licenseNumber
        
        mapView.delegate = self
        //Add annotations
        let driverAnnotation = VehicleAnnotation(coordinate: driver.coordinate)
        let pickupCoordinate = CLLocationCoordinate2D(latitude: pickupLocation.latitude, longitude: pickupLocation.longitude)
        let dropoffCoordinate = CLLocationCoordinate2D(latitude: dropoffLocation.latitude, longitude: dropoffLocation.longitude)
        let pickupAnnotation = LocationAnnotation(coordinate: pickupCoordinate, locationType: "pickup")
        let dropoffAnnotation = LocationAnnotation(coordinate: dropoffCoordinate, locationType: "dropoff")
        
        let annotations: [MKAnnotation] = [driverAnnotation, pickupAnnotation, driverAnnotation]
        mapView.addAnnotations(annotations)
        mapView.showAnnotations(annotations, animated: false)
        
        let driverLocation = Location(title: driver.name, subtitle: driver.licenseNumber, latitude: driver.coordinate.latitude, longitude: driver.coordinate.longitude)
        displayRoute(sourceLocation: driverLocation, destinationLocation: pickupLocation)
    }
    
    @IBAction func backButtonDidTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editRideButtonDidTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil
        }
        
        let reuseIdentifier = annotation is VehicleAnnotation ? "VehicleAnnotation" : "LocationAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        if annotationView == nil{
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
        } else {
            annotationView?.annotation = annotation
        }
        
        if annotation is VehicleAnnotation{
            annotationView?.image = UIImage(named: "car")
        } else if let LocationAnnotation = annotation as? LocationAnnotation{
            annotationView?.image = UIImage(named: "dot-\(LocationAnnotation.locationType)")
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.lineWidth = 5.0
        renderer.strokeColor = UIColor(red: 247.0 / 255.0, green: 66.0 / 255.0, blue: 190.0 / 255.0, alpha: 1)
        return renderer
    }
    
    func displayRoute(sourceLocation: Location, destinationLocation: Location){
           let sourceCoordinate = CLLocationCoordinate2D(latitude: sourceLocation.latitude, longitude: sourceLocation.longitude)
           let destinationCoordinate =  CLLocationCoordinate2D(latitude: destinationLocation.latitude, longitude: destinationLocation.longitude)
           let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinate)
           let destinationPlaceMark = MKPlacemark(coordinate: destinationCoordinate)
           
           let directionRequest = MKDirections.Request()
           directionRequest.source = MKMapItem(placemark: sourcePlacemark)
           directionRequest.destination = MKMapItem(placemark: destinationPlaceMark)
           directionRequest.transportType = .automobile
           
           let directions = MKDirections(request: directionRequest)
           directions.calculate { (response, error) in
               if let error = error{
                   print("There's an error with calculating route \(error)")
                   return
               }
               
               if let response = response {
                   let route = response.routes[0]
                   self.mapView.addOverlay(route.polyline, level: .aboveRoads)

               }
           }
       }
    
    
    
    
}
