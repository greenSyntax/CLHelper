

import Foundation
import CoreLocation

public enum CLHelperError: Error {

    case noAuthorizationKey
    case failedInGettingLocation
    case deniedByUser
    case restrictedByUserSettings
    case unknown

    var localizedText:String {

        switch self {

        case .noAuthorizationKey:
            return "There is No Location Usage Key in Info.plist"

        case .failedInGettingLocation:
            return "Error while getting Locations"

        case .deniedByUser:
            return "User Has Denied the Loctaion Authorization"

        case .restrictedByUserSettings:
            return "Device Settings has disabled location service"

        case .unknown:
            return "Something went wrong"

        }
    }
}

public protocol CLHelperProtocol {
    var authorizationText:String {get set}
    var googleAPIKey: String {get set}
}

public class CLHelper: NSObject {

    fileprivate var locationHandler: (( _ locations: [CLLocation]?, _ error: Error?)->())?
    fileprivate var manager = CLLocationManager()
    //private var instance: CLHelperProtocol!

    public static let shared = CLHelper()
    private override init() {}

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