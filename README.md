# Core Location Helper

[![CI Status](http://img.shields.io/travis/greenSyntax/CLHelper.svg?style=flat)](https://travis-ci.org/greenSyntax/CLHelper)
[![Version](https://img.shields.io/cocoapods/v/CLHelper.svg?style=flat)](http://cocoapods.org/pods/CLHelper)
[![License](https://img.shields.io/cocoapods/l/CLHelper.svg?style=flat)](http://cocoapods.org/pods/CLHelper)
[![Platform](https://img.shields.io/cocoapods/p/CLHelper.svg?style=flat)](http://cocoapods.org/pods/CLHelper)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.


## Installation

CLHelper is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'CLHelper'
```

## Usage

* Get User Current Location Update

```swift

CLHelper.shared.getLocation { (locations, error) in

    print(locations)
}

```

If you have error occured,

```swift
CLHelper.shared.getLocation { (locations, error) in

    print(error?.localizedText)
}
```

## Author

Abhishek Kumar Ravi

## License

CLHelper is available under the MIT license. See the LICENSE file for more info.
