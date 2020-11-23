import Foundation
import CoreLocation
import Alamofire
import SwiftyJSON

class FinedustInfo {
    static let pp = ["sidoName" : "서울", "searchCondition" : "DAILY"]
    static let baseUrl = "http://openapi.airkorea.or.kr/openapi/services/rest/ArpltnInforInqireSvc/getCtprvnMesureSidoLIst"
    static let params = ["searchCondition", "ServiceKey", "_returnType"]
    static let apiKey : String = "ZiSNIwgl%2BWu%2FVFxTGPUa%2FCHGRtQTKy4RRj88RPZbBXz0hhxW2c9L7nBijrKzinyX4dHrc%2FBhHjh6EH0nqAsJaw%3D%3D"
    static let paramsValue = ["DAILY", apiKey, "json"]
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
    
    static func getFinedustData(sido : String, city : String, completion:@escaping (FinedustViewComponents) -> Void) {
        let requestUrl = getRequestUrl(cityName: "서울")
        let test = getURL(url: baseUrl, params: pp)
        AF.request(test, method : .get)
            .validate(statusCode: 200..<300)
            .responseJSON(completionHandler: { response in
            switch(response.result) {
            case .success(_) :
                if let data = response.value {
                    let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue )
                    print("[Log] \(responseString)")
                }
                let data = FinedustInfo.getFinedustInfoFromJson(inputData: response.data!, cityName: "광진구")
                completion(data)
                break ;
            case .failure(_) :
                print("[Log] data request is failed", response.request ,(response.result))
                break;
            }
        })
    }
    
    static func getURL(url:String, params:[String: Any]) -> URL {
        let urlParams = params.flatMap({ (key, value) -> String in
        return "\(key)=\(value)"
        }).joined(separator: "&")
        let withURL = url + "?\(urlParams)"
        let encoded = withURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! + "&serviceKey=" + apiKey + "&_returnType=json"
        return URL(string:encoded)!
    }
    
    static func getRequestUrl(cityName : String) -> String {
        let url = NSURLComponents(string: baseUrl)
        var items = [URLQueryItem]()
        items.append(URLQueryItem(name: "sidoName", value: cityName))
        for i in 0...2 {
            print(params[i], paramsValue[i])
            items.append(URLQueryItem(name: params[i], value: paramsValue[i]))
        }
        
        items = items.filter{!$0.name.isEmpty}
        if !items.isEmpty {
            url?.queryItems = items
        }
        guard let requestUrl = url?.string! else { return ""}
        
        return requestUrl
    }

    static func getFinedustInfoFromJson(inputData : Data, cityName : String) -> FinedustViewComponents {
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
            let parsedData = FinedustViewComponents(currentLoction: cityName, pm10Grade: pm10Grade.finedustGradeName ,
                                                    pm10Value: pm10Value, pm25Grade: pm25Grade.finedustGradeName,
                                                    pm25Value: pm25Value, datetime: datatime)
            return parsedData
        } else {
            return FinedustViewComponents(currentLoction: cityName, pm10Grade: "-", pm10Value: 1, pm25Grade: "-", pm25Value: 1, datetime: "")
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
    
}


struct FinedustViewComponents {
    var currentLoction = ""
    var pm10Grade = ""
    var pm10Value = 1
    var pm25Grade = ""
    var pm25Value = 1
    var datetime = ""

}
