//
//  Progressbar.swift
//  CLHelper_Example
//
//  Created by Abhishek  Kumar Ravi on 06/06/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class Progressbar {
    
    static let activityIndicator = UIActivityIndicatorView()
    
    static func show() {
        activityIndicator.activityIndicatorViewStyle = .gray
        activityIndicator.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        activityIndicator.startAnimating()
        
        UIApplication.shared.keyWindow?.addSubview(activityIndicator)
    }
    
    static func hide() {
        activityIndicator.removeFromSuperview()
    }
    
}
