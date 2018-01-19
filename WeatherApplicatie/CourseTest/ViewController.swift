//
//  ViewController.swift
//  CourseTest
//
//  Created by Geart on 11/10/2017.
//  Copyright © 2017 Geart. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UISearchBarDelegate, UICollectionViewDataSource {

    
    @IBOutlet weak var BackgroundImage: UIImageView!
    var dateArray: [String] = []
    var averageTempatureArray: [Double] = []
    var weatherDesciptionArray: [String] = []
    var weatherIconArray: [String] = []
    //All the UI
    //UI city
    @IBOutlet weak var citySearchBar: UISearchBar!
    @IBOutlet weak var cityNameLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //Today's weather info
    @IBOutlet weak var weatherImageToday: UIImageView!
    @IBOutlet weak var temperatureLabelToday: UILabel!
    @IBOutlet weak var weatherDescriptionLabelToday: UILabel!
    
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
        
        dateArray = [String]()
        averageTempatureArray = [Double]()
        weatherDesciptionArray = [String]()
        weatherIconArray = [String]()
        // API gets requested
        let apixuJsonUrl = "https://api.apixu.com/v1/forecast.json?key=79104d19fe3947f7aaf70734171810&days=5&q=" + cityName
        
        guard let apixuUrl = URL(string: apixuJsonUrl) else
        { return }
        
        //Downloading API Data
        URLSession.shared.dataTask(with: apixuUrl) { (data2, response, err) in
            guard let data2 = data2 else{ return }
            
            do {
                let decodedApixuJSON = try JSONDecoder().decode(ApixuForecast2.self, from: data2)
               
                //Checking city name
                let city = decodedApixuJSON.location.name
                
                //Checking for Weather of Today
                var i: Int = 1
                while i < 5 {
                    let dates = decodedApixuJSON.forecast.forecastday[i].date
                    let averageTempature = decodedApixuJSON.forecast.forecastday[i].day.avgtemp_c
                    let weatherDescriptions = decodedApixuJSON.forecast.forecastday[i].day.condition.text
                    let weatherIcon = decodedApixuJSON.forecast.forecastday[i].day.condition.icon
                    
                    self.dateArray.append(dates)
                    self.averageTempatureArray.append(averageTempature)
                    self.weatherDesciptionArray.append(weatherDescriptions)
                    self.weatherIconArray.append(weatherIcon)
                    
                    i += 1
                }

                let todayTemp = decodedApixuJSON.current.temp_c
                let todayWeatherDescription = decodedApixuJSON.current.condition.text
                let iconUrlToday = NSURL(string: "https:" + decodedApixuJSON.current.condition.icon)
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.cityNameLabel.text = city
                    self.temperatureLabelToday.text = String (describing: abs(Int(todayTemp))) + "°C"
                    self.weatherDescriptionLabelToday.text = todayWeatherDescription
                    if self.weatherDescriptionLabelToday.text?.range(of: "show") != nil || self.weatherDescriptionLabelToday.text?.range(of: "rain") != nil {
                        self.BackgroundImage.image = UIImage(named: "WeatherRainy")
                    } else if self.weatherDescriptionLabelToday.text?.range(of: "sunny") != nil {
                        self.BackgroundImage.image = UIImage(named: "WeatherSunny")
                    } else if self.weatherDescriptionLabelToday.text?.range(of: "cloud") != nil {
                        self.BackgroundImage.image = UIImage(named: "WeatherCloudy")
                    }else {
                        self.BackgroundImage.image = UIImage(named: "WeatherSunny")
                    }
                    
                    if let iconDataToday = NSData(contentsOf: iconUrlToday! as URL) {
                        self.weatherImageToday.image = UIImage(data: iconDataToday as Data)
                    }
                }
            }catch let jsonErr{
                print("error", jsonErr)
            }
        
        }.resume()
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dateArray.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "forecastCell", for: indexPath) as! ForecastCell
        //testText.text = "123test"
        cell.dateLabel.text = self.dateArray[indexPath.row]
        cell.weatherDescriptionLabel.text = self.weatherDesciptionArray[indexPath.row]
        cell.tempLabel.text = String(Int(self.averageTempatureArray[indexPath.row])) + "°C"
        let iconURL = NSURL(string: "https:" + self.weatherIconArray[indexPath.row])
        if let iconData = NSData(contentsOf: iconURL! as URL){
            cell.weatherImage.image = UIImage(data: iconData as Data)
        }
        
        return cell
    }
}


