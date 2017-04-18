//
//  SearchLocationVC.swift
//  cityfam
//
//  Created by Piyush Gupta on 3/6/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit
import MapKit

protocol SearchedLocationServiceProtocol {
    func getSelectedAddressDetail(_ placemark: MKPlacemark)
}

class SearchLocationVC: UIViewController,UITextFieldDelegate,CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource {

    //MARK:- Outlets & Properties

    @IBOutlet var searchTxtField: UITextFieldCustomClass!
    @IBOutlet var tableView: UITableView!
    
    var mapView: MKMapView?
    var matchedLocationsListArr: [MKMapItem] = []
    let locationManager = CLLocationManager()
    var searchedLocationServiceDelegate:SearchedLocationServiceProtocol?
    
    //MARK:- View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()

        let searchBar = self.searchTxtField
        searchBar?.sizeToFit()
        searchBar?.placeholder = "Search for places"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    //MARK:- Methods

    func updateSearchResults() {
        let searchBarText = searchTxtField.text
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchBarText
//        request.region = (mapView?.region)!
        let search = MKLocalSearch(request: request)
        
        search.start { response, _ in
            guard let response = response else {
                return
            }
            self.matchedLocationsListArr = response.mapItems
            self.tableView.reloadData()
            print("matching locations" , self.matchedLocationsListArr)
        }
    }
    
    func parseAddress(_ selectedItem:MKPlacemark) -> String {
        
        // put a space between "4" and "Melrose Place"
        let firstSpace = (selectedItem.subThoroughfare != nil &&
            selectedItem.thoroughfare != nil) ? " " : ""
        
        // put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) &&
            (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        
        // put a space between "Washington" and "DC"
        let secondSpace = (selectedItem.subAdministrativeArea != nil &&
            selectedItem.administrativeArea != nil) ? " " : ""
        
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            // city
            selectedItem.locality ?? "",
            secondSpace,
            // state
            selectedItem.administrativeArea ?? ""
        )
        
        return addressLine
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapView?.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
    
    // dismissing keyboard on pressing return key
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: UITableView Delgates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return matchedLocationsListArr.count
    }
    
    @IBAction func searchTxtFieldEditingAction(_ sender: Any) {
        updateSearchResults()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SearchLocationsTableViewCell
        let selectedItem = matchedLocationsListArr[indexPath.row].placemark
        //cell.textLabel?.text = selectedItem.name
        //cell.detailTextLabel?.text = parseAddress(selectedItem)
        
        cell.searchLocationNameLbl.text = selectedItem.name
        cell.searchLocationAddressLbl.text = parseAddress(selectedItem)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? SearchLocationsTableViewCell
        
        let selectedItem = matchedLocationsListArr[indexPath.row].placemark
        self.searchTxtField.text = cell?.searchLocationAddressLbl.text
                
        NotificationCenter.default.post(name:NSNotification.Name(rawValue: "getSearchedLocationNotification"),
                                        object: nil,userInfo:["selectedItemDetail":selectedItem,
        "address":self.searchTxtField.text!])
        self.searchedLocationServiceDelegate?.getSelectedAddressDetail(selectedItem)
        _ = self.navigationController?.popViewController(animated: true)
    }

    //MARK:- Button Actions
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }

}




    
