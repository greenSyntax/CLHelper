//
//  GeographicalAddress.swift
//  CLHelper
//
//  Created by Abhishek Kumar Ravi on 22/03/18.
//

import Foundation

/// Wrapper around CLPlacemark
public struct GeographicalAddress {

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
