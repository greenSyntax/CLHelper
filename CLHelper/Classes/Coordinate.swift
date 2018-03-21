//
//  Coordinate.swift
//  CLHelper
//
//  Created by Abhishek Kumar Ravi on 22/03/18.
//

import Foundation

/// Wrapper Around CLLocation Object
public struct Coordinate {

    public var latitude: Double
    public var longitude: Double

    public init(latitude: Double, longitude: Double) {

        self.latitude = latitude
        self.longitude = longitude
    }
}
