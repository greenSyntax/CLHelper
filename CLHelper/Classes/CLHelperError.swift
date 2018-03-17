//
//  CLHelperError.swift
//  CLHelper
//
//  Created by Abhishek Kumar Ravi on 18/03/18.
//

import Foundation

public enum CLHelperError: Error {

    case noAuthorizationKey
    case failedInGettingLocation
    case deniedByUser
    case restrictedByUserSettings
    case unknown

    case addressNotFound

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


        case .addressNotFound:
            return "There is no address for the given coordinate"

        }
    }
}

