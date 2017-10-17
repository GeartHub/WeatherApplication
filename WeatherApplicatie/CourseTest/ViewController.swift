//
//  ViewController.swift
//  CourseTest
//
//  Created by Geart on 11/10/2017.
//  Copyright © 2017 Geart. All rights reserved.
//

import UIKit

struct OpenForecast: Decodable {
    //CityInfo
    let city: CityName
    struct CityName: Decodable {
        let name: String
    }
    //WeatherInfo
    let list: [WeatherForecastList]
    struct WeatherForecastList: Decodable {
        let main: WeatherForecast
        let dt_txt: String
        let dt: Int
        struct WeatherForecast: Decodable {
            let temp_max: Double
        }
        let weather: [WeatherDescription]
        struct WeatherDescription: Decodable {
            let description: String
            let icon: String
        }
    }
}
class ViewController: UIViewController, UISearchBarDelegate {
    //UI city stuff
    @IBOutlet weak var citySearchBar: UISearchBar!
    @IBOutlet weak var cityNameLabel: UILabel!
    
    //Today's weather info
    @IBOutlet weak var weatherImageToday: UIImageView!
    @IBOutlet weak var temperatureLabelToday: UILabel!
    @IBOutlet weak var weatherDescriptionLabelToday: UILabel!
    
    //Day one forecast
    @IBOutlet weak var tempatureLabelDayOne: UILabel!
    @IBOutlet weak var weatherDescriptionLabelDayOne: UILabel!
    @IBOutlet weak var weatherImageDayOne: UIImageView!
    
    //Day two forecast
    @IBOutlet weak var tempatureLabelDayTwo: UILabel!
    @IBOutlet weak var weatherDescriptionLabelDayTwo: UILabel!
    @IBOutlet weak var weatherImageDayTwo: UIImageView!
    
    //Day three forecast
    @IBOutlet weak var tempatureLabelDayThree: UILabel!
    @IBOutlet weak var weatherDescriptionLabelDayThree: UILabel!
    @IBOutlet weak var weatherImageDayThree: UIImageView!
    
    //Day four forecast
    @IBOutlet weak var tempatureLabelDayFour: UILabel!
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
        // API gets requested
        let otherOpenWeatherMapJsonURL = "https://api.openweathermap.org/data/2.5/forecast?id=524901&q=" + cityName + "&lang=en&units=metric&APPID=2ece9f6600e72596fdc7be53987f63b1"
        guard let url2 = URL(string: otherOpenWeatherMapJsonURL) else
        { return }
        
        //Downloading API Data
        URLSession.shared.dataTask(with: url2) { (data2, response, errr) in
            
            guard let data2 = data2 else{ return }
            
            do {
                //Decoding API
                let decodedJSONForecast = try JSONDecoder().decode(OpenForecast.self, from: data2)
                
                //Checking cityname
                let city = decodedJSONForecast.city.name
                
                //Checking date
                
                
               // let date2 = NSDate(timeIntervalSince1970: TimeInterval(decodedJSONForecast.list[0].dt))
                
                //Checking for Weather of Today
                let todayTemp = decodedJSONForecast.list[0].main.temp_max
                let todayWeatherDescription = decodedJSONForecast.list[0].weather[0].description
                let todayWeatherIcon = decodedJSONForecast.list[0].weather[0].icon
                
                var c: Int = 0
                var arrayPlacement: [Int] = []
                for _ in decodedJSONForecast.list{
                    let date = decodedJSONForecast.list[c].dt_txt
                    if (date.range(of: "12:00:00") != nil && c >= 3)
                    {
                        arrayPlacement.append(c)
                    }
                    c += 1
                }
                //Checking for Tempature
                let dayOneTemp = decodedJSONForecast.list[arrayPlacement[0]].main.temp_max
                let dayTwoTemp = decodedJSONForecast.list[arrayPlacement[1]].main.temp_max
                let dayThreeTemp = decodedJSONForecast.list[arrayPlacement[2]].main.temp_max
                let dayFourTemp = decodedJSONForecast.list[arrayPlacement[3]].main.temp_max
                
                //Checking for Weather Description
                let dayOneWeatherDescription = decodedJSONForecast.list[arrayPlacement[0]].weather[0].description
                let dayTwoWeatherDescription = decodedJSONForecast.list[arrayPlacement[1]].weather[0].description
                let dayThreeWeatherDescription = decodedJSONForecast.list[arrayPlacement[2]].weather[0].description
                let dayFourWeatherDescription = decodedJSONForecast.list[arrayPlacement[3]].weather[0].description
                
                //Checking for Weather Icon
                let dayOneWeatherIcon = decodedJSONForecast.list[arrayPlacement[0]].weather[0].icon
                let dayTwoWeatherIcon = decodedJSONForecast.list[arrayPlacement[1]].weather[0].icon
                let dayThreeWeatherIcon = decodedJSONForecast.list[arrayPlacement[2]].weather[0].icon
                let dayFourWeatherIcon = decodedJSONForecast.list[arrayPlacement[3]].weather[0].icon

                DispatchQueue.main.async {
                    //Adding Info to labels and Image to UIImage
                    self.cityNameLabel.text = city
                    
                    //Weather Today
                    self.temperatureLabelToday.text = String (describing: abs(Int(todayTemp))) + "°C"
                    self.weatherImageToday.image = UIImage(named: todayWeatherIcon + ".png")
                    self.weatherDescriptionLabelToday.text = todayWeatherDescription

                    
                    //Weather Tomorrow
                    self.tempatureLabelDayOne.text = String (describing: abs(Int(dayOneTemp))) + "°C"
                    self.weatherImageDayOne.image = UIImage(named: dayOneWeatherIcon + ".png")
                    self.weatherDescriptionLabelDayOne.text = dayOneWeatherDescription
                    
                    //Weather Day 2
                    self.tempatureLabelDayTwo.text = String (describing: abs(Int(dayTwoTemp))) + "°C"
                    self.weatherImageDayTwo.image = UIImage(named: dayTwoWeatherIcon + ".png")
                    self.weatherDescriptionLabelDayTwo.text = dayTwoWeatherDescription
                    
                    //Weather Day 3
                    self.tempatureLabelDayThree.text = String (describing: abs(Int(dayThreeTemp))) + "°C"
                    self.weatherImageDayThree.image = UIImage(named: dayThreeWeatherIcon + ".png")
                    self.weatherDescriptionLabelDayThree.text = dayThreeWeatherDescription
                    
                    //Weather Day 4
                    self.tempatureLabelDayFour.text = String (describing: abs(Int(dayFourTemp))) + "°C"
                    self.weatherImageDayFour.image = UIImage(named: dayFourWeatherIcon + ".png")
                    self.weatherDescriptionLabelDayFour.text = dayFourWeatherDescription
                    
                }
            }catch let jsonErr{
                print("error", jsonErr)
            }
            
        }.resume()
        
        // What I did first with other API and other way of changing Image
        
       /* let openWeatherMapJsonUrl = "https://api.openweathermap.org/data/2.5/weather?q=" + cityName + "&lang=en&units=metric&APPID=2ece9f6600e72596fdc7be53987f63b1"
        guard let url = URL(string: openWeatherMapJsonUrl) else
     { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            
            guard let data = data else{ return }
            
            do {
                let decodedJSONWeather = try JSONDecoder().decode(OpenWeather.self, from: data)
                let city = decodedJSONWeather.name
                let temp = Int (decodedJSONWeather.main.temp)
                let weatherImage = String (describing: decodedJSONWeather.weather[0].icon)
                let weatherDescription = String (decodedJSONWeather.weather[0].description)
                DispatchQueue.main.async{
         
                    switch weatherImage{
                    case "01d":
                        self.weatherImage.image = UIImage(named: "01d.png")
                    case "02d":
                        self.weatherImage.image = UIImage(named: "02d.png")
                    case "03d":
                        self.weatherImage.image = UIImage(named: "03d.png")
                    case "04d":
                        self.weatherImage.image = UIImage(named: "04d.png")
                    case "09d":
                        self.weatherImage.image = UIImage(named: "09d.png")
                    case "10d":
                        self.weatherImage.image = UIImage(named: "10d.png")
                    case "11d":
                        self.weatherImage.image = UIImage(named: "11d.png")
                    case "13d":
                        self.weatherImage.image = UIImage(named: "13d.png")
                    case "50d":
                        self.weatherImage.image = UIImage(named: "50d.png")
                    default:
                        break;
                    }
                }
                DispatchQueue.main.async {
                self.cityNameLabel.text = city
                self.temperatureLabel.text = String (temp) + "° Celcius"
                self.weatherDescriptionLabel.text = weatherDescription
                }
            }catch let jsonErr{
                print("error", jsonErr)
            }
        }.resume()*/
    }
}

