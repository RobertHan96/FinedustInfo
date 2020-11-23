import Foundation
import Alamofire
import SwiftyJSON
// OpenWatherAPI 공식문서 메인 : https://openweathermap.org/current#current_JSON
// 날씨 표기 icon 종류 정리 : https://openweathermap.org/weather-conditions

/*
1) 키, cityID를 매개변수로 날씨 객체 생성
2) 비동기로 API 호출
3) 온도, 최고 온도, 최저 온도, 습도, iconImageUrl 파싱
4) 3)에서 가져온 정보를 넣어서 Weather 객체 생성
5) Weather 객체의 정보로 ViewController에 내용 표시
 */

struct Weather {
    var weatherName = ""
    var temp : Int = 1
    var minTemp :Int = 1
    var maxTemp :Int = 1
    var humidity :Int = 1
    var imageUrl = "http://openweathermap.org/img/wn/50n@2x.png"
}

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
                    print("[Log] 날씨정보\n \(data))")
                    let weatherInfo = self.getWeatherFromJson(inputData: response.data!)
                    completion(weatherInfo)
                }
                break ;
            case .failure(_):
                print("[Log] data request is failed, \(response.result)")
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
