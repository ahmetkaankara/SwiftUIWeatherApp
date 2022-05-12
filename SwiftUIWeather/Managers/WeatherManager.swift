//
//  WeatherManager.swift
//  SwiftUIWeather
//
//  Created by Ahmet Kaan Kara on 11.05.2022.
//

import Foundation
import CoreLocation

class WeatherManager{
    func getCurrentWeather(latitude:CLLocationDegrees,longitude:CLLocationDegrees) async throws -> ResponseBody {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=f3165c19b2db4ab6828c60633fc4cf30&units=metric") else { fatalError("Missing Arguments") }
        
        let urlRequest = URLRequest(url: url)
        let (data , response) = try await URLSession.shared.data(for: urlRequest)
        
        guard(response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error fetching data")}
        
        let decodedData = try JSONDecoder().decode(ResponseBody.self, from: data)
        print("Success")
        return decodedData
    }
}


struct ResponseBody:Decodable{
    var coord: CoordinatesResponse
    var weather: [WeatherResponse]
    var main: MainResponse
    var name: String
    var wind: WindResponse
    
    struct CoordinatesResponse: Decodable{
        var lon: Double
        var lat: Double
    }
    
    struct WeatherResponse:Decodable {
        var id: Int
        var main: String
        var description: String
        var icon: String
        
    }
    
    struct MainResponse: Decodable{
        var temp: Double
        var feels_like: Double
        var temp_min: Double
        var temp_max: Double
        var pressure: Double
        var humidity: Double
        
    }
    
    
    struct WindResponse:Decodable{
        var speed:Double
        var deg: Double
    }
}

extension ResponseBody.MainResponse{
    var feelsLike: Double { return feels_like}
    var tempMin: Double{ return temp_min}
    var tempMax:Double{ return temp_max}
}
