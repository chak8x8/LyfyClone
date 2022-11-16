//
//  LocationViewController.swift
//  LyftClone
//
//  Created by Won Chak Leung on 28/10/2022.
//

import UIKit
import MapKit

class LocationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, MKLocalSearchCompleterDelegate{
    
    var locations = [Location]()
    
    var pickupLocation: Location?
    
    var dropoffLocation: Location?
    
    var searchCompleter = MKLocalSearchCompleter()
    
    var searchResults = [MKLocalSearchCompletion]()
    
    @IBOutlet weak var dropoffTextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func cancelDidTapped(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locations = LocationService.shared.getRecentLocations()
        
        dropoffTextField.becomeFirstResponder()
       
        dropoffTextField.delegate = self
        
        searchCompleter.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let latestString = (textField.text as! NSString).replacingCharacters(in: range, with: string)
        
        if latestString.count > 3{
            searchCompleter.queryFragment = latestString
        }
        
        return true
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.isEmpty ? locations.count : searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell") as! LocationCell
        if searchResults.isEmpty{
            let location = locations[indexPath.row]
            cell.update(location: location)
        } else {
            let searchReslut = searchResults[indexPath.row]
            cell.update(searchResult: searchReslut)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchResults.isEmpty{
            let location = locations[indexPath.row]
            performSegue(withIdentifier: "RouteSegue", sender: location)
        } else {
            //Convert searchReuslt -> Location object
            let searchResult = searchResults[indexPath.row]
            let searchRequest = MKLocalSearch.Request(completion: searchResult)
            let search = MKLocalSearch(request: searchRequest)
            search.start(completionHandler: { (response, error) in
                if error == nil{
                    if let dropoffPlacemark = response?.mapItems.first?.placemark{
                        let location = Location(placemark: dropoffPlacemark);
                        self.performSegue(withIdentifier: "RouteSegue", sender: location)
                    }
                }
            })
        }
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        // Reload our TableView
        tableView.reloadData()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let routeViewController = segue.destination as? RouteViewController, let dropoffLocation = sender as? Location{
            routeViewController.pickupLocation = pickupLocation
            routeViewController.dropoffLocation = dropoffLocation
            
        }
    }
}

