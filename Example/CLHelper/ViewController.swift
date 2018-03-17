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

        //getLocation()

        getCoordinate()

    }


    func getCoordinate() {

        CLHelper.shared.getCoordinate(fromAddress: "New Delhi") { (coordinate, error) in

            guard error == nil else {

                print(error?.localizedDescription)
                return
            }

            // Get Coordinate
            print(coordinate?.latitude)
            print(coordinate?.longitude)

        }

    }

    func getLocation() {

        CLHelper.shared.getLocation { (locations, error) in

            print(locations)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

