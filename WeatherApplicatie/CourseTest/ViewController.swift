//
//  ViewController.swift
//  CourseTest
//
//  Created by Geart on 11/10/2017.
//  Copyright © 2017 Geart. All rights reserved.
//

import UIKit
import Foundation

struct ApixuForecast: Decodable {
    let location: Location
    struct Location: Decodable {
        let name: String
    }
    let current: CurrentWeather
        struct CurrentWeather: Decodable{
            let temp_c: Double
            let condition: Condition
            struct Condition: Decodable{
                let icon: String
                let text: String
            }
    }
    let forecast: Forecast
    struct Forecast:Decodable {
        let forecastday: [forecastday]
        struct forecastday: Decodable {
            let date: String
            let day: WeatherInformationDay
            struct WeatherInformationDay:Decodable {
                let maxtemp_c: Double
                let mintemp_c: Double
                let condition: Condition
                struct Condition:Decodable {
                    let text: String
                    let icon: String
                }
            }
        }
    }
}
class ViewController: UIViewController, UISearchBarDelegate {
    var dateToday2: String = ""
    var dateArray: [String] = []
    var highTempatureArray: [Double] = []
    var lowTempatureArray: [Double] = []
    var weatherDesciptionArray: [String] = []
    var weatherIconArray: [String] = []
    //All the UI
    //UI city
    @IBOutlet weak var citySearchBar: UISearchBar!
    @IBOutlet weak var cityNameLabel: UILabel!
    
    //Today's weather info
    @IBOutlet weak var dateToday: UILabel!
    @IBOutlet weak var weatherImageToday: UIImageView!
    @IBOutlet weak var temperatureLabelToday: UILabel!
    @IBOutlet weak var weatherDescriptionLabelToday: UILabel!
    
    //Day one forecast
    @IBOutlet weak var dateDayOne: UILabel!
    @IBOutlet weak var tempatureLabelHighDayOne: UILabel!
    @IBOutlet weak var tempatureLabelLowDayOne: UILabel!
    @IBOutlet weak var weatherDescriptionLabelDayOne: UILabel!
    @IBOutlet weak var weatherImageDayOne: UIImageView!
    
    //Day two forecast
    @IBOutlet weak var dateDayTwo: UILabel!
    @IBOutlet weak var tempatureLabelHighDayTwo: UILabel!
    @IBOutlet weak var tempatureLabelLowDayTwo: UILabel!
    @IBOutlet weak var weatherDescriptionLabelDayTwo: UILabel!
    @IBOutlet weak var weatherImageDayTwo: UIImageView!
    
    //Day three forecast
    @IBOutlet weak var dateDayThree: UILabel!
    @IBOutlet weak var tempatureLabelHighDayThree: UILabel!
    @IBOutlet weak var tempatureLabelLowDayThree: UILabel!
    @IBOutlet weak var weatherDescriptionLabelDayThree: UILabel!
    @IBOutlet weak var weatherImageDayThree: UIImageView!
    
    //Day four forecast
    @IBOutlet weak var dateDayFour: UILabel!
    @IBOutlet weak var tempatureLabelHighDayFour: UILabel!
    @IBOutlet weak var tempatureLabelLowDayFour: UILabel!
    @IBOutlet weak var weatherDescriptionLabelDayFour: UILabel!
    @IBOutlet weak var weatherImageDayFour: UIImageView!
    
    
    override func viewDidLoad() {
        //Opening of Application
        super.viewDidLoad()
        getData(cityName: "Eastermar")
        citySearchBar.showsScopeBar = true
        citySearchBar.delegate = self
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //Search button clicked
        searchBar.resignFirstResponder()
        if let locationString = searchBar.text, !locationString.isEmpty{
            getData(cityName: locationString)
            searchBar.text = ""
        }
    }
    func getData(cityName: String){
        // API gets requested
        let apixuJsonUrl = "https://api.apixu.com/v1/forecast.json?key=79104d19fe3947f7aaf70734171810&days=5&q=" + cityName
        
        guard let apixuUrl = URL(string: apixuJsonUrl) else
        { return }
        
        //Downloading API Data
        URLSession.shared.dataTask(with: apixuUrl) { (data2, response, err) in
            guard let data2 = data2 else{ return }
            
            do {
                let decodedApixuJSON = try JSONDecoder().decode(ApixuForecast.self, from: data2)
               
                //Checking city name
                let city = decodedApixuJSON.location.name
                
                //Checking for Weather of Today
                var i: Int = 1
                while i < 5 {
                    let dates = decodedApixuJSON.forecast.forecastday[i].date
                    let highTempatures = decodedApixuJSON.forecast.forecastday[i].day.maxtemp_c
                    let lowTempatures = decodedApixuJSON.forecast.forecastday[i].day.mintemp_c
                    let weatherDescriptions = decodedApixuJSON.forecast.forecastday[i].day.condition.text
                    let weatherIcon = decodedApixuJSON.forecast.forecastday[i].day.condition.icon
                    
                    self.dateArray.append(dates)
                    self.highTempatureArray.append(highTempatures)
                    self.lowTempatureArray.append(lowTempatures)
                    self.weatherDesciptionArray.append(weatherDescriptions)
                    self.weatherIconArray.append(weatherIcon)
                    
                    i += 1
                }
                
                let dateToday = decodedApixuJSON.forecast.forecastday[0].date
                let todayTemp = decodedApixuJSON.current.temp_c
                let todayWeatherDescription = decodedApixuJSON.current.condition.text
                let iconUrlToday = NSURL(string: "https:" + decodedApixuJSON.current.condition.icon)
                
                DispatchQueue.main.async {
                    self.cityNameLabel.text = city
                    self.dateToday.text = dateToday
                    self.temperatureLabelToday.text = String (describing: abs(Int(todayTemp))) + "°C"
                    self.weatherDescriptionLabelToday.text = todayWeatherDescription
                    if let iconDataToday = NSData(contentsOf: iconUrlToday! as URL) {
                        self.weatherImageToday.image = UIImage(data: iconDataToday as Data)
                    }
                    var b: Int = 0
                    while b < 4 {
                        switch b{
                        case 0:
                            self.dateDayOne.text = self.dateArray[b]
                            self.tempatureLabelHighDayOne.text = String (describing: abs(Int(self.highTempatureArray[b]))) + "°C"
                            self.tempatureLabelLowDayOne.text = String (describing: abs (Int (self.lowTempatureArray[b]))) + "°C"
                            self.weatherDescriptionLabelDayOne.text = self.weatherDesciptionArray[b]
                            let iconUrlDayOne = NSURL(string: "https:" + self.weatherIconArray[b])
                            if let iconDataDayOne = NSData(contentsOf: iconUrlDayOne! as URL){
                                self.weatherImageDayOne.image = UIImage(data: iconDataDayOne as Data)
                            }
                        case 1:
                            self.dateDayTwo.text = self.dateArray[b]
                            self.tempatureLabelHighDayTwo.text = String (describing: abs(Int(self.highTempatureArray[b]))) + "°C"
                            self.tempatureLabelLowDayTwo.text = String (describing: abs (Int (self.lowTempatureArray[b]))) + "°C"
                            self.weatherDescriptionLabelDayTwo.text = self.weatherDesciptionArray[b]
                            let iconUrlDayTwo = NSURL(string: "https:" + self.weatherIconArray[b])
                            if let iconDataDayTwo = NSData(contentsOf: iconUrlDayTwo! as URL){
                                self.weatherImageDayTwo.image = UIImage(data: iconDataDayTwo as Data)
                            }
                        case 2:
                            self.dateDayThree.text = self.dateArray[b]
                            self.tempatureLabelHighDayThree.text = String (describing: abs(Int(self.highTempatureArray[b]))) + "°C"
                            self.tempatureLabelLowDayThree.text = String (describing: abs (Int (self.lowTempatureArray[b]))) + "°C"
                            self.weatherDescriptionLabelDayThree.text = self.weatherDesciptionArray[b]
                            let iconUrlDayThree = NSURL(string: "https:" + self.weatherIconArray[b])
                            if let iconDataDayThree = NSData(contentsOf: iconUrlDayThree! as URL){
                                self.weatherImageDayThree.image = UIImage(data: iconDataDayThree as Data)
                            }
                        case 3:
                            self.dateDayFour.text = self.dateArray[b]
                            self.tempatureLabelHighDayFour.text = String (describing: abs(Int(self.highTempatureArray[b]))) + "°C"
                            self.tempatureLabelLowDayFour.text = String (describing: abs (Int (self.lowTempatureArray[b]))) + "°C"
                            self.weatherDescriptionLabelDayFour.text = self.weatherDesciptionArray[b]
                            let iconUrlDayFour = NSURL(string: "https:" + self.weatherIconArray[b])
                            if let iconDataDayFour = NSData(contentsOf: iconUrlDayFour! as URL){
                                self.weatherImageDayFour.image = UIImage(data: iconDataDayFour as Data)
                            }
                        default:
                            break
                        }
                        b += 1
                    }
                }
            }catch let jsonErr{
                print("error", jsonErr)
            }
        }.resume()
    }
}

