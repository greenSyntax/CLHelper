//
//  GeographicalAddress.swift
//  CLHelper
//
//  Created by Abhishek Kumar Ravi on 22/03/18.
//

import Foundation

/// Wrapper around CLPlacemark
public struct GeographicalAddress {

    public var landmark: String?
    public var timestamp: Date?
    public var country: String?
    public var postalCode: String?
    public var countryCode: String?
    public var state: String?
    public var district: String?
    public var nearByPlace: String?
    public var locality: String?
    public var popularVisit: [String]?
    public var address: String?
}
