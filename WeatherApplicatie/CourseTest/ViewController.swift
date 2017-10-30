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
        GetData(cityName: "Eastermar")
        citySearchBar.showsScopeBar = true
        citySearchBar.delegate = self

        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //Search button clicked
        searchBar.resignFirstResponder()
        if let locationString = searchBar.text, !locationString.isEmpty{
            GetData(cityName: locationString)
            searchBar.text = ""
        }
    }
    func GetData(cityName: String){
        
        let deviceLanguage = NSLocale.preferredLanguages[0]
        print (deviceLanguage)
        
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
                let dateToday = decodedApixuJSON.forecast.forecastday[0].date
                let todayTemp = decodedApixuJSON.current.temp_c
                let todayWeatherDescription = decodedApixuJSON.current.condition.text
                let iconUrlToday = NSURL(string: "https:" + decodedApixuJSON.current.condition.icon)
                
                //Checking Weather for tomorrow
                let dateDayOne = decodedApixuJSON.forecast.forecastday[1].date
                let highTempDayOne = decodedApixuJSON.forecast.forecastday[1].day.maxtemp_c
                let lowTempDayOne = decodedApixuJSON.forecast.forecastday[1].day.mintemp_c
                let dayOneWeatherDescription = decodedApixuJSON.forecast.forecastday[1].day.condition.text
                let dayOneWeatherIcon = NSURL(string: "https:" + decodedApixuJSON.forecast.forecastday[1].day.condition.icon)
                
                //Checking Weather for day 2
                let dateDayTwo = decodedApixuJSON.forecast.forecastday[2].date
                let highTempDayTwo = decodedApixuJSON.forecast.forecastday[2].day.maxtemp_c
                let lowTempDayTwo = decodedApixuJSON.forecast.forecastday[2].day.mintemp_c
                let dayTwoWeatherDescription = decodedApixuJSON.forecast.forecastday[2].day.condition.text
                let dayTwoWeatherIcon = NSURL(string: "https:" + decodedApixuJSON.forecast.forecastday[2].day.condition.icon)
                
                //Checking Weather for day 3
                let dateDayThree = decodedApixuJSON.forecast.forecastday[3].date
                let highTempDayThree = decodedApixuJSON.forecast.forecastday[3].day.maxtemp_c
                let lowTempDayThree = decodedApixuJSON.forecast.forecastday[3].day.mintemp_c
                let dayThreeWeatherDescription = decodedApixuJSON.forecast.forecastday[3].day.condition.text
                let dayThreeWeatherIcon = NSURL(string: "https:" + decodedApixuJSON.forecast.forecastday[3].day.condition.icon)
                
                //Checking Weather for day 4
                let dateDayFour = decodedApixuJSON.forecast.forecastday[4].date
                let highTempDayFour = decodedApixuJSON.forecast.forecastday[4].day.maxtemp_c
                let lowTempDayFour = decodedApixuJSON.forecast.forecastday[4].day.mintemp_c
                let dayFourWeatherDescription = decodedApixuJSON.forecast.forecastday[4].day.condition.text
                let dayFourWeatherIcon = NSURL(string: "https:" + decodedApixuJSON.forecast.forecastday[4].day.condition.icon)
                
                DispatchQueue.main.async {
                    
                    //Insert city name into label
                    self.cityNameLabel.text = city
                    
                    //Weather of today
                    self.dateToday.text = dateToday
                    self.temperatureLabelToday.text = String (describing: abs(Int(todayTemp))) + "°C"
                    self.weatherDescriptionLabelToday.text = todayWeatherDescription
                    if let iconDataToday = NSData(contentsOf: iconUrlToday! as URL) {
                        self.weatherImageToday.image = UIImage(data: iconDataToday as Data)
                    }
                    
                    //Weather of tomorrow
                    self.dateDayOne.text = dateDayOne
                    self.tempatureLabelHighDayOne.text = String (describing: abs(Int(highTempDayOne))) + "°C"
                    self.tempatureLabelLowDayOne.text = String (describing: abs(Int(lowTempDayOne))) + "°C"
                    self.weatherDescriptionLabelDayOne.text = dayOneWeatherDescription
                    if let iconDataDayOne = NSData(contentsOf: dayOneWeatherIcon! as URL){
                        self.weatherImageDayOne.image = UIImage(data: iconDataDayOne as Data)
                    }
                    
                    //Weather day 2
                    self.dateDayTwo.text = dateDayTwo
                    self.tempatureLabelHighDayTwo.text = String (describing: abs(Int(highTempDayTwo))) + "°C"
                    self.tempatureLabelLowDayTwo.text = String (describing: abs(Int(lowTempDayTwo))) + "°C"
                    self.weatherDescriptionLabelDayTwo.text = dayTwoWeatherDescription
                    if let iconDataDayTwo = NSData(contentsOf: dayTwoWeatherIcon! as URL){
                        self.weatherImageDayTwo.image = UIImage(data: iconDataDayTwo as Data)
                    }
                    
                    //Weather day 3
                    self.dateDayThree.text = dateDayThree
                    self.tempatureLabelHighDayThree.text = String (describing: abs(Int(highTempDayThree))) + "°C"
                    self.tempatureLabelLowDayThree.text = String (describing: abs(Int(lowTempDayThree))) + "°C"
                    self.weatherDescriptionLabelDayThree.text = dayThreeWeatherDescription
                    if let iconDataDayThree = NSData(contentsOf: dayThreeWeatherIcon! as URL){
                        self.weatherImageDayThree.image = UIImage(data: iconDataDayThree as Data)
                    }
                    
                    //Weather day 4
                    self.dateDayFour.text = dateDayFour
                    self.tempatureLabelHighDayFour.text = String (describing: abs(Int(highTempDayFour))) + "°C"
                    self.tempatureLabelLowDayFour.text = String (describing: abs(Int(lowTempDayFour))) + "°C"
                    self.weatherDescriptionLabelDayFour.text = dayFourWeatherDescription
                    if let iconDataDayFour = NSData(contentsOf: dayFourWeatherIcon! as URL){
                        self.weatherImageDayFour.image = UIImage(data: iconDataDayFour as Data)
                    }
                    
                }
            }catch let jsonErr{
                print("error", jsonErr)
            }
        }.resume()
    }
}

