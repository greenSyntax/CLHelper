//
//  GeocodingHelper.swift
//  Guardian
//
//  Created by Abhishek Ravi on 22/05/17.
//  Copyright © 2017 Abhishek Ravi. All rights reserved.
//

import Foundation
import CoreLocation


/// Geocoding Error
///
/// - notFound: When Requested Object is Not Found
enum GeoCodingError: Error {
    
    case notFound
}

/// Wrapper Around CLLocation Object
struct UserCoordinate {
    
    var latitude: Double
    var longitude: Double
    
    init(latitude: Double, longitude: Double) {
        
        self.latitude = latitude
        self.longitude = longitude
    }
}

/// Wrapper around CLPlacemark
struct GeographicalAddress {
    
    var landmark: String?
    var timestamp: Date?
    var country: String?
    var postalCode: String?
    var countryCode: String?
    var state: String?
    var district: String?
    var nearByPlace: String?
    var locality: String?
    var popularVisit: [String]?
    var address: String?
}

class GeocodingHelper {
    
    fileprivate static let geocodingLocation = CLGeocoder()
    
    private init() {}
    
    // FIXME
    //MARK:- Private Parse CLPacemark in Custom Model
    
    /// parseGeocodePlaces method is used for wrappping CLPlacemark array into GeographicalAddress
    ///
    /// - Parameter placemarks: [CLPlacemark]
    /// - Returns: [GeographicalAddress]
    private static func parseGeocodePlaces(placemarks: [CLPlacemark]) -> [GeographicalAddress] {
        
        var arrayLandmarks: [GeographicalAddress] = []
        
        for placemark in placemarks {
            
            var singlePlacemark = GeographicalAddress()
            
            singlePlacemark.countryCode = placemark.isoCountryCode ?? ""
            singlePlacemark.country = placemark.country ?? ""
            singlePlacemark.postalCode = placemark.postalCode ?? ""
            singlePlacemark.state = placemark.administrativeArea ?? ""
            singlePlacemark.district = placemark.subLocality ?? ""
            singlePlacemark.nearByPlace = placemark.locality ?? ""
            singlePlacemark.landmark = placemark.name ?? ""
            singlePlacemark.locality = placemark.thoroughfare ?? ""
            singlePlacemark.popularVisit = placemark.areasOfInterest ?? []
            singlePlacemark.address = getAddresString(place: placemark)
            
            arrayLandmarks.append(singlePlacemark)
        }
        
        return arrayLandmarks
    }
    
    private static func getAddresString(place: CLPlacemark) -> String? {
        
        var address: String = ""
        if let locality = place.locality {
            
            address.append("\(locality), ")
        }
        if let district = place.subLocality {
            
            address.append("\(district), ")
        }
        if let country = place.country {
            
            address.append("\(country)")
        }
        return address
    }
    
    //MAKR:- Coordinates into Address 
    // === Reverse Geocoding ===
    
    /// Method used to get Geographical Address from custom UserCoordinate Object
    ///
    /// - Parameters:
    ///   - coordinate: UserCoordinate Object
    ///   - address: Geographical Address
    ///   - error: Geocoding Error Onject
    static func getAddressFromCoordinate(coordinate: CLLocationCoordinate2D, gotAddress address: @escaping ([GeographicalAddress]) -> Void, onError error: @escaping (ErrorModel) -> Void) {
        
        // Get Location
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        //Forward Geocoding
        geocodingLocation.reverseGeocodeLocation(location) { (placemarks, placeError) in
            
            guard placeError == nil else{
                
                let err = ErrorManager.processError(error: placeError, errorCode: nil, errorMsg: nil)
                error(err)
                return
            }
            
            if let lamdmarks = placemarks {
                
                address(parseGeocodePlaces(placemarks: lamdmarks))
            }
        }
    }
    
    //MARK:- Cordinate into Address 
    //=== Forward Geocoding ===
    static func getCoordinatedFromAddress(address: String, gotCoordinate: @escaping (UserCoordinate) -> Void, onError: @escaping (GeoCodingError) -> Void) {
        
        CLGeocoder().geocodeAddressString(address) { (placemarks, error) in
            
            guard error == nil else{
                
                // Can't Get the Coordinate
                onError(GeoCodingError.notFound)
                return
            }
            
            if let location = placemarks?.first?.location {
                
                // Location Object of desired Address
                let parsedCoordinate = UserCoordinate(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                
                gotCoordinate(parsedCoordinate)
            }
        }
    }
    
}
