

import Foundation
import CoreLocation

public class CLHelper: NSObject {

    fileprivate var locationHandler: (( _ locations: [CLLocation]?, _ error: Error?)->())?
    fileprivate var manager = CLLocationManager()

    public override init() {}

    public func getLocation(onCompletion:@escaping ( _ locations: [CLLocation]?, _ error: Error?)->()) {

        self.locationHandler = onCompletion

        if self.checkUsageDescription() {
            self.initializeService()
        }
        else {
            onCompletion(nil, CLHelperError.noAuthorizationKey)
        }
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
        self.manager.requestAlwaysAuthorization()
        self.manager.delegate = self

    }

    fileprivate func startUpdatingLocation() {
        self.manager.startUpdatingLocation()
    }

    fileprivate func stopUpdatingLocation() {
        self.manager.stopUpdatingLocation()
    }

    fileprivate func checkUsageDescription()->Bool{

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

    public func createGeofence(name: String, radius:Double = 500, coordinate:CLLocationCoordinate2D, onGeofenceEnter:()->(), onGeofenceExit:()->()) {

        let region = CLCircularRegion(center: coordinate, radius: radius, identifier: name)
        manager.startMonitoring(for: region)
    }

    public func deleteGeofence(name:String, coordinate:CLLocationCoordinate2D) {

        let region = CLCircularRegion(center: coordinate, radius: 500, identifier: name)
        manager.stopMonitoring(for: region)
    }

}

// Geocoding
extension CLHelper {

    public func getAddress(fromCoordinate coordinate:Coordinate, onCompletion: @escaping (_ address:[GeographicalAddress]?, _ error:CLHelperError?)->()) {

        GeocodingHelper.reverseGeocoding(coordinate: CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude), address: { (address) in

            //onAddress
            onCompletion(address, nil)

        }) { (error) in

            //onError
            onCompletion(nil, error)
        }
    }

    public func getCoordinate(fromAddress address: String, onCompletion: @escaping (_ coodinate:Coordinate?, _ error: CLHelperError?)->()) {

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
