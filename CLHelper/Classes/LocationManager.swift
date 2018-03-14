//
//  LocationManager.swift
//  Guardian
//
//  Created by Abhishek Ravi on 22/05/17.
//  Copyright © 2017 Abhishek Ravi. All rights reserved.
//

import Foundation
import CoreLocation

/*
 
 NOTE: Add Usage Description in Your Info.plist file, else Core Location will not work.
 
 NSLocationAlwaysUsageDescription = When You want your CoreLocation in Always Usage Mode.
 

 */

//MARK:- Exceptions

/// Location Manager Error
///
/// - errorWhileGettingLocation: Can't get Location
/// - deviceLocationCapabilityOff: Location Service has No Permission
/// - userDeniedPermission: User Denied The While OS alerts for the Location Usage
/// - locationRestricted: Location Service has been Restricted from Settings> Privacy
enum LocationError:Error{
    
    case errorWhileGettingLocation
    case deviceLocationCapabilityOff
    case userDeniedPermission
    case locationRestricted
    case usageDescriptionNoDefined
}


/// User Wants Current Location for One-Time or Everytime when Location Changes
///
/// - onlyCurrentLocation: User Location for Once
/// - locationsOnChange: Everytime when Location changes
enum typeOfLocation{
    
    case onlyCurrentLocation
    case locationsOnChange
}

//MARK:- Location Model

/// User Location is Custom Type which consume CLLocation type of CoreLocation
struct UserLocation {
    
    var latitude:Double
    var longitude:Double
    var altitude:Double
    var timestamp:Date
    
    init(latitude:Double, longitude:Double, altitude:Double, timestamp:Date) {
        
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
        self.timestamp = timestamp
    }
}

//MARK:- Location Manager

class LocationManager:NSObject {
    
    //Core CLLocationManager Singleton Object
    fileprivate var manager = CLLocationManager()
    
    //Private Closures
    fileprivate var gotLocation:(([UserLocation])->Void)?
    fileprivate var hasError:((LocationError)->Void)?
    fileprivate var stateOfLocationType:typeOfLocation?
    
    static let shared = LocationManager()
    private override init(){}
    
    //MARK:- Constants
    fileprivate let locationHasTurnedOff = "locationHasTurnedOff"
    fileprivate let locationHasTurnedOn = "locationHasTurnedOn"
    
    
    //Notificate Identifer
    fileprivate var deviceLocationHasTurnedOff:Notification{
        
        return Notification(name: Notification.Name(rawValue: locationHasTurnedOff))
    }
    
    fileprivate var deviceLocationHasTurnedOn:Notification{
        
        return Notification(name: Notification.Name(rawValue: locationHasTurnedOn))
    }
    
    
    //MARK:- Manager Accessible Methods
    func intializeLocationService(){
        
        guard checkUsageDescription() == true else{
            
            // You've not defined usage in Info.plist
            
            return
        }
        
        // Location Property
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        
        //Always Autherization
        manager.requestAlwaysAuthorization()
        manager.delegate = self
        updateLocation()
    }
    
    func getCurrentLocation(hasLocation:@escaping ([UserLocation])->Void, onError error:@escaping (LocationError)->Void){
        
        //Set Only User Location for Single Time
        stateOfLocationType = typeOfLocation.onlyCurrentLocation
        
        if CLLocationManager.locationServicesEnabled(){
            
            gotLocation = hasLocation
            hasError = error
        }
        else{
            
            error(.deviceLocationCapabilityOff)
        }
    }
    
    // Array of Updated Location
    func getUpdatedLocations(hasLocation:@escaping ([UserLocation])->Void, onError error:@escaping (LocationError)->Void){
        
        //Set Only User Location for Single Time
        stateOfLocationType = typeOfLocation.locationsOnChange
        
        if CLLocationManager.locationServicesEnabled(){
            
            gotLocation = hasLocation
            hasError = error
        }
        else{
            
            error(.deviceLocationCapabilityOff)
        }
    }
    
    //MARK:- Private Methods
    fileprivate func updateLocation(){
        
        //Start Updating Location
        LocationManager.shared.manager.startUpdatingLocation()
    }
    
    fileprivate func stopLocationUpdate(){
        
        //Stop Updating Location
        LocationManager.shared.manager.stopUpdatingLocation()
    }
    
    
    /// Method will parse CLLocation Type into custom UserLocation Type
    ///
    /// - Parameter locations: Array of CLLocation
    /// - Returns: Array of Custom User Location
    fileprivate func parseCoreLocation(coreLocations locations:[CLLocation])->[UserLocation]{
        
        var userLocations:[UserLocation] = []
        
        for location in locations{
            
            let userLocation = UserLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, altitude: location.altitude, timestamp: location.timestamp)
            
            userLocations.append(userLocation)
        }
        
        return userLocations
    }
    
    fileprivate func checkUsageDescription()->Bool{
        
        if let infoPlist = Bundle.main.path(forResource: "Info", ofType: "plist"){
            
            if let plistData = NSDictionary(contentsOfFile: infoPlist) as? [String:AnyObject]{
                
                //Check For Usage Description
                for (key, _) in plistData{
                    
                    if key == "NSLocationAlwaysUsageDescription"{
                        
                        return true
                    }
                }
            }
        }
        return false
    }
}

//MARK:- Broadcast Notifier
extension LocationManager{
    
    fileprivate func haslocationHasTurnedOff(){
        
        NotificationCenter.default.post(deviceLocationHasTurnedOff as Notification)
    }
    
    fileprivate func haslocationHasTurnedOn(){
        
        NotificationCenter.default.post(deviceLocationHasTurnedOn as Notification)
    }
    
}

//MARK:- Location Manager Delegate Methods

extension LocationManager: CLLocationManagerDelegate{
    
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        
        if stateOfLocationType == typeOfLocation.onlyCurrentLocation{
            
            // Current Location for Once
            stopLocationUpdate()
        }
        
        //onLocation
        if let gotLocation = gotLocation{
            
            gotLocation(parseCoreLocation(coreLocations: locations))
        }
    }
    
    internal func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        
        if let hasError = hasError{
            
            //Due to some external issue.
            hasError(.errorWhileGettingLocation)
        }
    }
    
    internal func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
        
        switch status {
        case .authorizedAlways:
            
            // Update Location
            updateLocation()
            
            break
            
        case .authorizedWhenInUse:
            
            // Update Location
            updateLocation()
            
            break
            
        case .denied:
            
            // User has Denied
            if let hasError = hasError{
                
                hasError(.userDeniedPermission)
            }
            
            break
            
        case .notDetermined:
            
            //Again, Request for Location
            intializeLocationService()
            
            break
            
        case .restricted:
            
            if let hasError = hasError{
                
                hasError(.locationRestricted)
            }
            
            break
        }
    }
}

//Geofence # WORKING
extension LocationManager{
    
    func setupGeofence(location:UserLocation){
        
        let regionCoordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        
        let geoFence = CLCircularRegion(center: regionCoordinate, radius: 10.0, identifier: "MyHome")
        geoFence.notifyOnExit = true
        geoFence.notifyOnEntry = true
        
        manager.startMonitoring(for: geoFence)
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
        // On Enter Region
        
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        
        //On Exit Region
        
    }
}
