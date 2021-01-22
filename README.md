# WeatherApp

## Requirements

- iOS 11.0+

## Installation

### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate WeatherFrameworkApp into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'WeatherFrameworkApp', '1.0.5'
```

## WeatherNetworkManager

**WeatherNetworkManager** offer you a function call **fetchCurrentWeatherData**so that you can get all the weather informations that you need of a location.

### Example :

```swift
WeatherNetworkManager.shared.fetchCurrentWeatherData(lat: lat, 
                                                    lon: lon, 
                                                    units: .metric, 
                                                    lang: "fr", 
                                                    exclude: [.minutely, .daily, .alerts], 
                                                    weatherApiKey: weatherApiKey) { (weatherModel, response, error) in
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = response?.statusCode {
                if statusCode == 200 {
                    print("Weather received :\(weatherModel)")
                } else {
                    print("Status code: \(statusCode)")
                }
            }
}
```

### Parameters of fetchCurrentWeatherData function :

* lat, lon	: (required)	Geographical coordinates (latitude, longitude).
* appid	: (required)	Your unique API key (you can get one here : https://home.openweathermap.org/users/sign_in, find it on your account page under the "API key" tab).
* exclude :	(optional) By using this parameter you can exclude some parts of the weather data from the API response.
Available values:

  * current
  * minutely
  * hourly
  * daily
  * alerts

* units	: (optional)	Units of measurement. standard, metric and imperial units are available. If you do not use the units parameter, standard units will be applied by default.
* lang : (optional)	You can use the lang parameter to get the output in your language.
