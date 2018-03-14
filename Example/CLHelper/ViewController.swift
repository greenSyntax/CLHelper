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

    var authorizationText: String = "App wants to access your location"
    var googleAPIKey: String = "NA"

    override func viewDidLoad() {
        super.viewDidLoad()

        getLocation()
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

