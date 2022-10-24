# SimpleWeather
A basic weather app written in SwiftUI for iOS and iPad OS.

<table>
  <tr>
    <td><img src="https://user-images.githubusercontent.com/359394/197612828-17df3b13-77bd-4c2b-b453-902b6c071cbb.png" alt="Screen shot of list of cities with weather" width="250" /></td>
    <td><img src="https://user-images.githubusercontent.com/359394/197612029-6901a42f-2acf-47d4-bb84-56bc986290ff.png" alt="Screenshot of weather details for Detroit" width="250" /></td> 
  </tr>
</table>

# Set Up
## Install Dependencies 

SimpleWeather uses CocoaPods to manage dependencies. It's only dependency is the `GooglePlaces` framework, used for quering city names and locations. 
To install dependencies navigate to the root repo directoy and run:
 ```bash
 pod install
 ```
 
 ## Configure API
 SimpleWeather requires API keys for GooglePlaces and OpenWeather in order to function properly. 
 
 - The GooglePlaces API Key [can be obtained here](https://developers.google.com/maps/documentation/places/ios-sdk/get-api-key).
 - The OpenWeather API Key [can be obtained here](https://openweathermap.org/api). 
    - NOTE: Please use the OneCall 3.0 API. 

Once you obtain the API keys please update the `API-Config.plist` in the `SimpleWeather` folder with the appropriate values. 
 
