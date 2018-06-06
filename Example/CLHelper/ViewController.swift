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
    
    @IBOutlet weak var labelOutput: UILabel!
    
    var googleAPIKey: String = "NA"

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    /// Current Location
    @IBAction func buttonLocationClicked(_ sender: Any) {
        
        self.labelOutput.text = ""
        getLocation()
    }
    
    /// Reverse Geocoding
    @IBAction func buttonReverseGeocodingClicked(_ sender: Any) {
        
        self.labelOutput.text = ""
        getAddress()
    }
    
    
    /// Geocoding
    @IBAction func buttonGeocodingClicked(_ sender: Any) {
        
        self.labelOutput.text = ""
        getCoordinate()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension ViewController {
    
    func getAddress() {
        
        // Gurgaon Coordinate
        let coordinate = Coordinate(latitude: 28.4595, longitude: 77.0266) // CHANGE AS PER YOU
        
        Progressbar.show()
        CLHelper.shared.getAddress(fromCoordinate: coordinate) { (address, error) in
            
            Progressbar.hide()
            guard error == nil else {
                
                print(error?.localizedText)
                return
            }
            
            if let suitedAddress = address?.first {
                print(suitedAddress)
                
                self.labelOutput.text = "Place: \(suitedAddress.landmark ?? "")" // Avoid !
            }
        }
    }
    
    func getCoordinate() {
        
        Progressbar.show()
        CLHelper.shared.getCoordinate(fromAddress: "New Delhi") { (coordinate, error) in // CHANGE AS PER YOU
            
            Progressbar.hide()
            guard error == nil else {
                
                if let errorText = error?.localizedText {
                    print(errorText)
                }
                
                return
            }
            
            // Get Coordinate
            print("Latitude: \(String(describing: coordinate?.latitude))")
            print("Longitude: \(String(describing: coordinate?.longitude))")
            
            self.labelOutput.text = "Lat: \(coordinate?.latitude ?? 0.0) , Lon: \(coordinate?.longitude ?? 0.0)"
        }
        
    }
    
    func getLocation() {
        
        Progressbar.show()
        CLHelper.shared.getLocation { (locations, error) in
            
            Progressbar.hide()
            guard error == nil else {
                
                if let errorText = error?.localizedDescription {
                    print(errorText)
                }
                return
            }
            
            // Latest Coordinate
            print(locations?.last)
            
            self.labelOutput.text = "Coordinate: (\(locations!.last!.coordinate.latitude) , \(locations!.last!.coordinate.longitude))" // Avoid Forecefull Unwraping (!)
        }
        
    }
    
}

