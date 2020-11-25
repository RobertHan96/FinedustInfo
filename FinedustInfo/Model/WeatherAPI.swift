import Foundation
import Alamofire
import SwiftyJSON

struct WeatherApi {
    let baseUrl = "http://api.openweathermap.org/data/2.5/weather"
    let iconBaseUrl = "http://openweathermap.org/img/wn/"
    let iconImageFormat = "@2x.png"
    let defaultImageIconName = "10d@2x.png"
    let params = ["id": "1835841", "appid" : "d75a52a08cd06e4d197f13e394125180"]
    
    func sendRequest(completion:@escaping (Weather) -> Void) {
        AF.request(baseUrl, method: .get, parameters: params).validate(statusCode: 200..<300).responseJSON { response in
            switch(response.result) {
            case .success(_) :
                if let data = response.value {
                    print("logHeader".localized ,data)
                    let weatherInfo = self.getWeatherFromJson(inputData: response.data!)
                    completion(weatherInfo)
                }
                break ;
            case .failure(_):
                print("logHeader".localized, response.result)
                break;

            }
        }
    }
    
    func getWeatherFromJson(inputData : Data?) -> Weather {
        guard let jsonData = inputData else { return Weather() }
        guard let weatherData = try? JSON(data: jsonData) else { return Weather() }
        let weatherName = weatherData["weather"][0]["main"].stringValue
        let weatherIconName = weatherData["weather"][0]["icon"].stringValue
        let temp = Int(weatherData["main"]["temp"].floatValue.getDegreeFromKelvin)
        let minTemp = Int(weatherData["main"]["temp_min"].floatValue.getDegreeFromKelvin)
        let maxTemp = Int(weatherData["main"]["temp_max"].floatValue.getDegreeFromKelvin)
        let humidity = weatherData["main"]["humidity"].intValue
        return Weather(weatherName: weatherName, temp: temp, minTemp: minTemp, maxTemp: maxTemp, humidity: humidity, imageUrl: iconBaseUrl + weatherIconName + iconImageFormat)
    }
 
}
