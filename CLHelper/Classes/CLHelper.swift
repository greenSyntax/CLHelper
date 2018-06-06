/*
 The MIT License (MIT)
 Copyright (c) 2018 Abhishek Kumar Ravi
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import Foundation
import CoreLocation

public class CLHelper: NSObject {
    
    fileprivate var locationHandler: (( _ locations: [CLLocation]?, _ error: CLHelperError?)->())?
    
    /// As, we want CLHelper to use just single instance of CLLocationManager. It's not a good idea to create multiple instance of CLLocationManager for a app
    fileprivate var manager = CLLocationManager()
    
    
    /// Singleton Instance
    public static let shared = CLHelper()
    
    
    /// Call When You want to get array of CLLocations object. In case, it fail for a reason then you will get a ClHelperError object.
    ///
    /// - Parameter onCompletion: onCompletion you will get a closure of Locations Array and CLHelperError Object
    public func getLocation(onCompletion:@escaping ( _ locations: [CLLocation]?, _ error: CLHelperError?)->()) {
        
        self.locationHandler = onCompletion
        
        if self.checkUsageDescription() {
            
            // Request for Location Authorization
            self.initializeService()
        }
        else {
            
            // Error Occured As, there is no Key in Info.plist
            onCompletion(nil, CLHelperError.noAuthorizationKey)
        }
    }
}

extension CLHelper {
    
    
    ///When You want to convert CoreLocation's CLLocationCoordinate2D object into CLHelper's Coordinate Object
    ///
    /// - Parameter coordinate: CLLocationCoordinate2D which belongs to CoreLocation
    /// - Returns: CLhelper's Wrapper Coordinate Object which has Lat+Lon
    public func coordinate(fromCLLocationCoordinate coordinate:CLLocationCoordinate2D) -> Coordinate {
        return Coordinate(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
    
    /// Opoosite of Above
    public func coordinate(fromWrapperCoordinate coordinate: Coordinate) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
    
}

extension CLHelper {
    
    fileprivate func reportError(type: CLHelperError) {
        if let handler = self.locationHandler {
            //onError
            handler(nil, type)
        }
    }
    
    fileprivate func initializeService() {
        
        self.manager.desiredAccuracy = kCLLocationAccuracyBest
        self.manager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        self.manager.delegate = self
        self.manager.requestAlwaysAuthorization()
        //self.manager.requestWhenInUseAuthorization()
    }
    
    fileprivate func startUpdatingLocation() {
        self.manager.startUpdatingLocation()
    }
    
    fileprivate func stopUpdatingLocation() {
        self.manager.stopUpdatingLocation()
    }
    
    fileprivate func checkUsageDescription() -> Bool {
        
        let keys = ["NSLocationAlwaysUsageDescription", "NSLocationWhenInUseUsageDescription", "NSLocationAlwaysAndWhenInUseUsageDescription"]
        
        if let infoPlist = Bundle.main.path(forResource: "Info", ofType: "plist"){
            
            if let plistData = NSDictionary(contentsOfFile: infoPlist) as? [String:AnyObject]{
                
                //Check For Usage Description
                for (key, _) in plistData{
                    
                    if keys.contains(key) {
                        
                        return true
                    }
                }
            }
        }
        return false
    }
    
}

// Geofence
extension CLHelper {
    
    public func createGeofence(name: String, radius: Double = 500, coordinate:CLLocationCoordinate2D, onGeofenceEnter:()->(), onGeofenceExit:()->()) {
        
        let region = CLCircularRegion(center: coordinate, radius: radius, identifier: name)
        manager.startMonitoring(for: region)
    }
    
    public func deleteGeofence(name: String, coordinate: CLLocationCoordinate2D) {
        
        let region = CLCircularRegion(center: coordinate, radius: 500, identifier: name)
        manager.stopMonitoring(for: region)
    }
    
}

// Geocoding
extension CLHelper {
    
    
    /// If you want to get a Geographical Address Object (landmark, Place, country etc.) from a Coordinate Object (i.e. Latitude & Longitude)
    /// Call this method, with a Coordinate Object and pass a closure with [GeogrpahicalAddress] Array and CLHelperError
    ///
    /// - Parameters:
    ///   - coordinate: Wrapper Model of Latitude and Longitude
    ///   - onCompletion: Completion Closure which takes GeographicalAddress Array and CLHelperError
    public func getAddress(fromCoordinate coordinate: Coordinate, onCompletion: @escaping (_ address: [GeographicalAddress]?, _ error: CLHelperError?)->()) {
        
        GeocodingHelper.reverseGeocoding(coordinate: CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude), address: { (address) in
            
            //onAddress
            onCompletion(address, nil)
            
        }) { (error) in
            
            //onError
            onCompletion(nil, error)
        }
    }
    
    
    
    /// Get Coordinate Object from a Geographical-Address String.
    ///
    /// - Parameters:
    ///   - address: Valid Address or, Name of any Geographical Place
    ///   - onCompletion: Completion Closure, with Coordinate Optional Object and CLHelperError Optional
    public func getCoordinate(fromAddress address: String, onCompletion: @escaping (_ coodinate: Coordinate?, _ error: CLHelperError?)->()) {
        
        GeocodingHelper.forwardGeocoding(address: address, gotCoordinate: { (userCoodinate) in
            
            //onSuccess
            onCompletion(userCoodinate, nil)
            
        }) { (error) in
            
            //onError
            onCompletion(nil, error)
        }
        
    }
    
}

extension CLHelper: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let handler = self.locationHandler {
            
            //onSuccess
            handler(locations, nil)
        }
        
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
        
    }
    
    public func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        
        
    }
    
    public func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        
        
    }
    
    public func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        
        // TODO
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
            
        case .authorizedAlways:
            
            //onLocationUpdate
            self.startUpdatingLocation()
            return
            
        case .authorizedWhenInUse:
            
            //onLocationUpdate
            self.startUpdatingLocation()
            return
            
        case .denied:
            reportError(type: .deniedByUser)
            return
            
        case .notDetermined:
            self.initializeService()
            return
            
        case .restricted:
            reportError(type: .restrictedByUserSettings)
            return
            
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        if let handler = self.locationHandler {
            
            //onError
            handler(nil, CLHelperError.failedInGettingLocation)
        }
    }
    
}
