//
//  ViewController.swift
//  CLHelper
//
//  Created by greenSyntax on 03/14/2018.
//  Copyright (c) 2018 greenSyntax. All rights reserved.
//

import UIKit
import CLHelper

class ViewController: UIViewController, CLHelperProtocol {

    var googleAPIKey: String = "NA"

    override func viewDidLoad() {
        super.viewDidLoad()

        //1
        //getLocation()

        // 2
        //getCoordinate()

        // 3
        getAddress()

    }


    func getAddress() {

        // Gurgaon Coordinate
        let coordinate = Coordinate(latitude: 28.4595, longitude: 77.0266)

        let helper = CLHelper()

        helper.getAddress(fromCoordinate: coordinate) { (address, error) in

            guard error == nil else {

                print(error?.localizedText)
                return
            }

            if let suitedAddress: GeographicalAddress = address?.first {
                print(suitedAddress)
            }
        }
    }

    func getCoordinate() {

        let helper = CLHelper()
        helper.getCoordinate(fromAddress: "New Delhi") { (coordinate, error) in

            guard error == nil else {

                print(error?.localizedText)
                return
            }

            // Get Coordinate
            print(coordinate?.latitude)
            print(coordinate?.longitude)

        }

    }

    func getLocation() {

        let helper = CLHelper()
        helper.getLocation { (locations, error) in

            // Latest Coordinate
            print(locations?.last)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

