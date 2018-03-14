//
//  GoogleGeocodingHelper.swift
//  MovingPin
//
//  Created by Abhishek Ravi on 06/09/17.
//
//

import Foundation
import CoreLocation

enum GoogleGeocodingError: Error {
    
    case noResponse
    case parsingError
}

class GoogleGeocodingHelper {

    static let apiKey = ""

    static let googleApi = "https://maps.googleapis.com/maps/api/geocode/json?"
    
    static func getAddess(coodinate:CLLocationCoordinate2D, completionHandler handler:@escaping (String?, GoogleGeocodingError?)->Void) {
        
        let apiUrl = googleApi+"latlng=\(coodinate.latitude),\(coodinate.longitude)&key=\(apiKey)"
        
        if let requestURL = URL(string: apiUrl) {
         
            let request = URLRequest(url: requestURL)
            
            DispatchQueue.main.async {
                
                let task:URLSessionDataTask = URLSession.shared.dataTask(with: request, completionHandler: { (data, responseData, error) in
                    
                    DispatchQueue.main.sync {
                        
                        guard error == nil, data != nil else{
                            
                            // Something went Wrong
                            handler(nil, GoogleGeocodingError.noResponse)
                            return
                        }
                        
                        do{
                            
                            if let responseJSON = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary{
                                
                                //Status
                                let statusCode = responseJSON["status"] as? String
                                
                                if(statusCode == "OK") {
                                    
                                    let results = responseJSON["results"] as? NSArray
                                    
                                    let elements = results?[0] as? NSDictionary
                                    
                                    if let element = elements?["formatted_address"] as? String{
                                        
                                        handler(element, nil)
                                    }
                                }
                            }
                            
                        }
                        catch{
                            
                            // JSON Parsing Error
                            handler(nil, GoogleGeocodingError.noResponse)
                        }
                    }
                })
                
                task.resume()
            }
            
        }
        
        handler(nil, GoogleGeocodingError.noResponse)
    }
    
    static func getLandmarkAddess(coodinate:CLLocationCoordinate2D, completionHandler handler:@escaping ((address:String?, landmark:String?)?, GoogleGeocodingError?)->Void) {
        
        let apiUrl = googleApi+"latlng=\(coodinate.latitude),\(coodinate.longitude)&key=\(apiKey)"
        
        if let requestURL = URL(string: apiUrl) {
            
            let request = URLRequest(url: requestURL)
            
            DispatchQueue.main.async {
                
                let task:URLSessionDataTask = URLSession.shared.dataTask(with: request, completionHandler: { (data, responseData, error) in
                    
                    DispatchQueue.main.sync {
                        
                        guard error == nil, data != nil else{
                            
                            // Something went Wrong
                            handler(nil, GoogleGeocodingError.noResponse)
                            return
                        }
                        
                        do{
                            
                            if let responseJSON = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary{
                                
                                //Status
                                let statusCode = responseJSON["status"] as? String
                                
                                if(statusCode == "OK") {
                                    
                                    let results = responseJSON["results"] as? NSArray
                                    
                                    let elements = results?[0] as? NSDictionary
                                    
                                    if let element = elements?["formatted_address"] as? String{
                                        
                                        //Here Element is Formatted Address
                                        if let addressComponents = elements?["address_components"] as? NSArray{
                                            
                                            if let address = addressComponents[4] as? NSDictionary{
                                                
                                                let landmark = address["long_name"] as? String
                                                
                                                // Landmark
                                                handler((element,landmark), nil)
                                            }
                                        }
                                        
                                    }
                                }
                            }
                            
                        }
                        catch{
                            
                            // JSON Parsing Error
                            handler(nil, GoogleGeocodingError.noResponse)
                        }
                    }
                })
                
                task.resume()
            }
            
        }
    }
    
    static func getCoordinate(address:String) -> CLLocationCoordinate2D? {
        
        return nil
    }
 
    
    
}
