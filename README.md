# The Weather
A simple Universal (iOS and macOS) weather app that can take a location input, then display some details about the weather. 
This project was a implementend in 2 days to solve a "Take Home Code Challenge".  

## Tech stack 
- Swift 
- SwiftUI 
- async/await 
- CoreLocation
- MapKit 

The project adopts MVVM. which is a lightweight and effective architectural design pattern. MVVM helps to solve the massive View/ViewController problem and reach higher cohesion, lower coupling and improve testability.  

## Requirements  
- Xcode 13.2.1 +

## Weather API
The app uses [MetaWeather API](https://www.metaweather.com/api) for fetching locations and the 5 day forecast for a given location. 
That’s why MetaWeather was choosen: 
- has the required data to show weather details 
- it's simple to use and implement, it doesn't require account creation or auth token, that's a good thing for the propose of this project 
- excellent documentation 
- fetch both location (by name and coordinates) and weather for location  
- HTTPS 
- has some nice extra data, like icons and 5 day forecast 

### Limitations 
Although MetaWeather is great API, it has some important limitations. The main issue is in location searching. The API cannot find several cities, searching by text or searching by coordinates. The API cannot also search search locations by states or Zipcode, for example, as has some issues with queries with special characters.  

### Workarounds 
In order to minimize the poor MetaWeather location searching the app uses MKLocalSearch, an Apple native feature which allows fetch places by query and returns a placemark. As a placemark contains coordinate, the app try to fetch a location with MKLocalSearch every time MetaWeather cannot find a location by query. As soon app get a placemark with MKLocalSearch it performs a new fetching in MetaWeather, this time by latitude and longitude parameters. 

When searching in MetaWeather by coordinate it almost always returns locations. It works very well, but sometimes the service is not be able to find the exact city you are looking for. It looks MetaWeather location database is not as complete, so it returns the closest locations from the coordinate sent in parameters.   


## STORY-6: 5 day forecast 
For a given location allow see the weather not only for current day, but also the forecast for next 5 days. 
