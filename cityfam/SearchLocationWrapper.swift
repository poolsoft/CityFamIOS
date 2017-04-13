//
//  SearchLocationWrapper.swift
//  cityfam
//
//  Created by i mark on 12/04/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit
import MapKit
//protocol GetListOfPeopleInterestedInEventServiceAlamofire {
//    func getListOfPeopleInterestedInEventResult(_ result:AnyObject)
//    func ServerError()
//}

class SearchLocationWrapper: NSObject {
    
    class var sharedInstance : SearchLocationWrapper{
        struct Singleton{
            static let instance = SearchLocationWrapper()
        }
        return Singleton.instance;
    }
    //    weak var handleMapSearchDelegate: HandleMapSearch?
    var matchingItems: [MKMapItem] = []
    var mapView: MKMapView?
    var LocationSearchTable = UITableView()
    
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
    
}


