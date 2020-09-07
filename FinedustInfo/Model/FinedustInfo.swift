import Foundation
import CoreLocation
import Alamofire
import SwiftyJSON

class FinedustInfo {
    static let apiKey : String = "Rj3kKMVbru0VayKTDlnSUCjbsuko3ZKRyXCKckQ%2Fe2lGHsThH3i6W07DfKPezNmNuAzD%2FpZBhOOTIGbIs3gOXg%3D%3D"
    var cityName : String = ""
    var finedustValue : Int = 0
    var finedustGrade : Int
    var ultraFineDuestValue : Int
    var ultraFineDustGrade : Int
    var dateTime : String    
    init(cityName : String, pm10Value : Int, pm10Grade : Int, pm25Value : Int, pm25Grade : Int, dateTime : String) {
        self.cityName = cityName
        self.finedustValue = pm10Value
        self.finedustGrade = pm10Grade
        self.ultraFineDuestValue = pm25Value
        self.ultraFineDustGrade = pm25Grade
        self.dateTime = dateTime
    }
        
    static func getFinedustInfoFromJson(inputData : Data, cityName : String) -> FinedustInfo {
        if let json = try? JSON(data: inputData) {
            let list = json["list"].arrayValue
            let citis = list.filter{ city -> Bool in
                return city.arrayValue != nil
            }
        let myCity = citis.filter { city -> Bool in
            return city["cityName"].stringValue == cityName
        }
        let cityName = myCity.map{$0["cityNameEng"].stringValue}.last ?? ""
        let pm10Value = myCity.map{$0["pm10Value"].intValue}.last ?? 1
        let pm25Value = myCity.map{$0["pm25Value"].intValue}.last ?? 1
        let pm10Grade = pm10Value.checkFinedustGrade(data: pm10Value)
        let pm25Grade = pm25Value.checkFinedustGrade(data: pm25Value)
        let datatime = myCity.map{$0["dataTime"].stringValue}.last ?? ""
        let parsedData = FinedustInfo(cityName: cityName, pm10Value: pm10Value, pm10Grade: pm10Grade, pm25Value: pm25Value, pm25Grade: pm25Grade, dateTime: datatime)
            return parsedData
        } else {
            return FinedustInfo(cityName: "", pm10Value: 1, pm10Grade: 1, pm25Value: 1, pm25Grade: 1, dateTime: "")
        }
    }
    
    static func postDeviceToken(deviceToken : String) {
        let pushServer = PushServiceManager.pushServerUrl
        let params = ["token": deviceToken]
        AF.request(pushServer, method: .post, parameters: params , encoding:
            URLEncoding(destination : .queryString), headers: ["Content-Type" : "application/json"]).responseJSON {
         response in
         switch response.result {
                         case .success:
                          print("[Log] \(response)")
                          break

                          case .failure(let error):
                           print("[Log] \(error)")
              }
         }
    }
    
    static func sendRequest(userLocation : String, cityName : String, serviceKey : String, completion:@escaping (FinedustInfo) -> Void) {
        let queryUrl = "http://openapi.airkorea.or.kr/openapi/services/rest/ArpltnInforInqireSvc/getCtprvnMesureSidoLIst?sidoName=\(userLocation)&searchCondition=DAILY&pageNo=1&numOfRows=20&ServiceKey=\(serviceKey)&ver=1.3(&_returnType=json"
        AF.request(queryUrl).validate(statusCode: 200..<300).responseJSON(completionHandler: { response in
            switch(response.result) {
            case .success(_) :
                if let data = response.value {
                    print("[Log] \(data)")
                }
                let data = FinedustInfo.getFinedustInfoFromJson(inputData: response.data!, cityName: cityName)
                completion(data)
                break ;
            case .failure(_) :
                print("[Log] data request is failed, \(response.result)")
                break;
            }
        }
        )

    }
    
}
