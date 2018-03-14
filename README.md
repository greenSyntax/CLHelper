# Core Location Helper

[![CI Status](http://img.shields.io/travis/greenSyntax/CLHelper.svg?style=flat)](https://travis-ci.org/greenSyntax/CLHelper)
[![Version](https://img.shields.io/cocoapods/v/CLHelper.svg?style=flat)](http://cocoapods.org/pods/CLHelper)
[![License](https://img.shields.io/cocoapods/l/CLHelper.svg?style=flat)](http://cocoapods.org/pods/CLHelper)
[![Platform](https://img.shields.io/cocoapods/p/CLHelper.svg?style=flat)](http://cocoapods.org/pods/CLHelper)

## Features

Core Location framework supports majorly,
[*] User Current Location
[ ] Geocoding (via Apple Geocoder)
[ ] Reverse Geocoding (via Apple Geocoder)
[ ] Geocoding (via Google Places APIs)
[ ] Near By Places (via Google Landark APIs)
[ ] Geofencing

And, this helper class will cover all the functionality under the single hood. 

## Installation

CLHelper is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'CLHelper'
```

## Usage

First, import the module in your screen,

```swift
import CLHelper
```

####  Current Location Update

*If There is sucess, then you'll get an array of locations of CLLocation type.

```swift

CLHelper.shared.getLocation { (locations, error) in

    print(locations)
}

```

* If you have error occured, then there is an object of CLHelperError

```swift
CLHelper.shared.getLocation { (locations, error) in

    print(error?.localizedText)
}
```

#### Geocoding

It will convert your coordinate (i.e. latitude longitude) into human-readable geographical address.

```swift

// Coordinate
let myCoordinate = CLLocationCoordinate2D(latitude: 28.581407, longitude: 77.321507)

CLHelper.shared.getAddess(coodinate: myCoordinate) { (address, error) in

guard error == nil else{

//Handle error

return
}

// Return Full Formatted Address
print(address)
}

```

## Contributor

[Abhishek Kumar Ravi]((https://greensyntax.co.in))
ab.abhshe.ravi@gmail.com

## License

CLHelper is available under the MIT license. See the LICENSE file for more info.
