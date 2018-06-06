# Core Location Helper

[![CI Status](http://img.shields.io/travis/greenSyntax/CLHelper.svg?style=flat)](https://travis-ci.org/greenSyntax/CLHelper)
[![Version](https://img.shields.io/cocoapods/v/CLHelper.svg?style=flat)](http://cocoapods.org/pods/CLHelper)
[![License](https://img.shields.io/cocoapods/l/CLHelper.svg?style=flat)](http://cocoapods.org/pods/CLHelper)
[![Platform](https://img.shields.io/cocoapods/p/CLHelper.svg?style=flat)](http://cocoapods.org/pods/CLHelper)

## Features

Core Location framework supports majorly,
- [x] User Current Location
- [x] Geocoding (via Apple Geocoder)
- [x] Reverse Geocoding (via Apple Geocoder)
- [ ] Geocoding (via Google Places APIs)
- [ ] Near By Places (via Google Landark APIs)
- [ ] Geofencing

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

    // Latest Coordinate
    print(locations?.last)
}

```

* If you have error occured, then there is an object of CLHelperError

```swift

CLHelper.shared.getLocation { (locations, error) in

    print(error?.localizedText)
}
```

#### Geocoding

It will convert your address string into coordinate (lat-long).

```swift

CLHelper.shared.getCoordinate(fromAddress: "New Delhi") { (coordinate, error) in

        guard error == nil else {

            print(error.localizedText)
            return
        }

        // Get Coordinate
        print(coordinate?.latitude)
        print(coordinate?.longitude)

}

```

#### Reverse Geocoding

It will convert your coordinate (i.e. latitude longitude) into human-readable geographical address.

```swift

// Gurgaon Coordinate
let coordinate = Coordinate(latitude: 28.4595, longitude: 77.0266)

CLHelper.shared.getAddress(fromCoordinate: coordinate) { (address, error) in

        guard error == nil else {
            print(error?.localizedText)
            return
        }

        if let suitedAddress: GeographicalAddress = address?.first {
        print(suitedAddress)
    }
}

```

## Versions Log

**v1.0.5**
- [x] README Updated

**v1.0.4** 
- [x] Singleton Class
- [x] Example Project Added
- [x] Added Comments in CLHelper.

**v1.0.1**
- [x] User Current Location
- [x] Geocoding (via Apple Geocoder)
- [x] Reverse Geocoding (via Apple Geocoder)



## Contributor

[Abhishek Kumar Ravi]((https://greensyntax.co.in))

ab.abhshe.ravi@gmail.com

## License

CLHelper is available under the MIT license. See the LICENSE file for more info.
