//
//  HomeViewController.swift
//  LyftClone
//
//  Created by Won Chak Leung on 27/10/2022.
//

import UIKit
import CoreLocation
import MapKit


class HomeViewController: UIViewController, UITableViewDataSource,UITableViewDelegate, CLLocationManagerDelegate, MKMapViewDelegate{
    
    @IBOutlet weak var searchButton: UIButton!
    
    var locations = [Location]()
    
    var locationManager: CLLocationManager!
    
    var currentUserLocation: Location!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let recentLocations = LocationService.shared.getRecentLocations()
        
        
        locations = [recentLocations[0], recentLocations[1]]
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
       
        
// Old Style:
//        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
//            locationManager.startUpdatingLocation()
//        }
        
//        DispatchQueue.global().async{
//            if CLLocationManager.locationServicesEnabled(){
//                self.locationManager.startUpdatingLocation()
//            }
//        }
        
//        if locationManager.authorizationStatus == .authorizedWhenInUse{
//            locationManager.startUpdatingLocation()
//        }
        
//        if CLLocationManager().CLAuthorizationStatus.authorizedWhenInUse{
//            locationManager.startUpdatingLocation()
//        }
        

        
        //Add shadow to searchButton
        searchButton.layer.cornerRadius = 10.0
        searchButton.layer.shadowRadius = 1.0
        searchButton.layer.shadowColor = UIColor.black.cgColor
        searchButton.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        searchButton.layer.shadowOpacity = 0.5
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let locationViewController = segue.destination as? LocationViewController{
            locationViewController.pickupLocation = currentUserLocation
        } else if let routeViewController = segue.destination as? RouteViewController, let dropoffLocation = sender as? Location{
            routeViewController.pickupLocation = currentUserLocation
            routeViewController.dropoffLocation = dropoffLocation
        }
            
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let firstLocation = locations.first!
        currentUserLocation = Location(title: "Current Location", subtitle: "", latitude: firstLocation.coordinate.latitude, longitude: firstLocation.coordinate.longitude)
        locationManager.stopUpdatingLocation()
    }
    
    
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        DispatchQueue.global().async {
//            if CLLocationManager.locationServicesEnabled(){
//                self.locationManager.startUpdatingLocation()
//            }
//        }
//    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            locationManager.startUpdatingLocation()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell") as! LocationCell
        let location = locations[indexPath.row]
        cell.update(location: location)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dropoffLocation = locations[indexPath.row]
        performSegue(withIdentifier: "RouteSegue", sender: dropoffLocation)
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        //Zoom in to the user location
        let distance = 200.0
        let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: distance, longitudinalMeters: distance)
        mapView.setRegion(region, animated: true)
        
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        let offset = 0.00075
        
        let coord1 = CLLocationCoordinate2D(latitude: latitude - offset, longitude: longitude - offset)
        let coord2 = CLLocationCoordinate2D(latitude: latitude, longitude: longitude + offset)
        let coord3 = CLLocationCoordinate2D(latitude: latitude, longitude: longitude - offset)
        // create 3 vehicle annotations and add them to the mapview
        mapView.addAnnotations([
            VehicleAnnotation(coordinate: coord1),
            VehicleAnnotation(coordinate: coord2),
            VehicleAnnotation(coordinate: coord3)
        ])
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil
        }
        
        //Create our custom annotation with vehicle image
        let reuseIdentifier = "VehicleAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        if annotationView == nil{
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.image = UIImage(named: "car")
        annotationView?.transform = CGAffineTransform(rotationAngle: CGFloat(CGFloat(arc4random_uniform(360)) * 180 / CGFloat.pi))
        return annotationView
    }
}
