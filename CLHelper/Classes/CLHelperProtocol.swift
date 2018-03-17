//
//  CLHelperProtocol.swift
//  CLHelper
//
//  Created by Abhishek Kumar Ravi on 18/03/18.
//

import Foundation

public protocol CLHelperProtocol {

    var googleAPIKey: String {get set}
}

extension CLHelperProtocol {

    var googleAPIKey: String {
        return "NA"
    }
}
