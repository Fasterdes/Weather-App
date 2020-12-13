//
//  WeatherManager.swift
//  Clima
//
//  Created by Fa Ainama Caldera S on 23/11/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(weatherManager: WeatherManager , weather: WeatherModel)
    func didFailWithEror(error: Error)
}

struct WeatherManager {
    let  weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=56bed3c0cc4f09366068a655e00f8af1&units=metric"
    var delegate: WeatherManagerDelegate?
    
    
    func fetchWeather(cityName: String){
        let urlString = "\(weatherURL)&q=\(cityName) "
       performRequest(urlString: urlString)
    }
    
    //Networking
    func performRequest(urlString: String){
        //1. Create URL
        if let url = URL(string: urlString){
            //2. Create URL session
            let session = URLSession(configuration: .default)
            //3.
            let task = session.dataTask(with: url) { (data, urlResponse, error) in
                if error != nil{
                    self.delegate?.didFailWithEror(error: error!)
                }
                
                if let safeData = data{
                   if  let weather = self.parseJSON(safeData){
                        self.delegate?.didUpdateWeather(weatherManager: self, weather: weather)
                    }
                }
          }
            task.resume()
       }
    }
    func parseJSON(_ weatherData: Data) -> WeatherModel?{
            let decoder = JSONDecoder()
            do{
                let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
                
                let id = decodedData.weather[0].id
                let temp = decodedData.main.temp
                let name = decodedData.name
                
                let wheater = WeatherModel(condition: id, name: name, temperature: temp)
                return wheater
                
                
            }catch{
                delegate?.didFailWithEror(error: error)
                return nil
            }
        }
    }

