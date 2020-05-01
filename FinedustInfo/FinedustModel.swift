import Foundation
import CoreLocation
import Alamofire
import SwiftyJSON

extension String {
    func makeStringKoreanEncoded(_ string: String) -> String {
        return string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? string
    }
}

class FinedustInfo {
    var finedustValue : Int = 0
    var finedustGrade : Int
    var ultraFineDuestValue : Int
    var ultraFineDustGrade : Int
    var dateTime : String
    
    init(pm10Value : Int, pm10Grade : Int, pm25Value : Int, pm25Grade : Int, dateTime : String) {
        self.finedustValue = pm10Value
        self.finedustGrade = pm10Grade
        self.ultraFineDuestValue = pm25Value
        self.ultraFineDustGrade = pm25Grade
        self.dateTime = dateTime
    }
    
    static func setIndicatorImageName(data : Int) -> String {
        let results : [Int : String] = [1:"good", 2:"moderate", 3:"bad", 4:"bad"]
        return results[data] ?? results[1]!
    }
    
    static func checkFinedustGrade(data : Int) -> String {
        let results : [Int : String] = [1:"좋음", 2:"보통", 3:"나쁨", 4:"매우나쁨"]
        return results[data] ?? results[1]!
    }
    
    static func getFinedustInfoFromJson(inputData : Data) -> FinedustInfo {
            if let json = try? JSON(data: inputData) {
                let pm10Value = json["list"].arrayValue.map { $0["pm10Value"].intValue}.last ?? 1
                let pm25Value = json["list"].arrayValue.map { $0["pm25Value"].intValue}.last ?? 1
                let pm10Grade = json["list"].arrayValue.map { $0["pm10Grade"].intValue}.last ?? 1
                let pm25Grade = json["list"].arrayValue.map { $0["pm25Grade"].intValue}.last ?? 1
                let datatime = json["list"].arrayValue.map { $0["dataTime"].stringValue}.last ?? "2020-12-31"
            let parsedData = FinedustInfo(pm10Value: pm10Value, pm10Grade: pm10Grade, pm25Value: pm25Value, pm25Grade: pm25Grade, dateTime: datatime)
                return parsedData
            } else {
                return FinedustInfo(pm10Value: 1, pm10Grade: 1, pm25Value: 1, pm25Grade: 1, dateTime: "2020-12-31")
        }
    }
    
    
    static func sendRequest(userLocation : String, serviceKey : String, completion:@escaping (FinedustInfo) -> Void) {
        let baseURL : String = "http://openapi.airkorea.or.kr/openapi/services/rest/ArpltnInforInqireSvc/getMsrstnAcctoRltmMesureDnsty?stationName=\(userLocation)&dataTerm=daily&pageNo=1&numOfRows=1&ServiceKey=\(serviceKey)&ver=1.3(&_returnType=json"
        
        AF.request(baseURL).validate(statusCode: 200..<300).responseJSON(completionHandler: { response in
            switch(response.result) {
            case .success(_) :
                if let data = response.value {
                    print(data)
                }
                let data = FinedustInfo.getFinedustInfoFromJson(inputData: response.data!)
                completion(data)
                break ;
            case .failure(_) :
                print("data request is failed, \(response.result)")
                break;
            }
        }
        )

    }
}
