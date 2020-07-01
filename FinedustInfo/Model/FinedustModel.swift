import Foundation
import CoreLocation
import Alamofire
import SwiftyJSON

class FinedustInfo {
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
    
    static func setIndicatorImageName(data : Int) -> String {
        let results : [Int : String] = [1:"good", 2:"moderate", 3:"bad", 4:"bad"]
        return results[data] ?? results[1]!
    }
    
    static func getImgUrl(gradeName : String) -> String {
        let results = [
            "finedustGood".localized :        "https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fk.kakaocdn.net%2Fdn%2Fccw0Ec%2FbtqEGT3j7wD%2FRgRM2mESHJ0Jcdij1vQcgK%2Fimg.png",
             "finedustModerate".localized :
                "https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fk.kakaocdn.net%2Fdn%2FcBMAPp%2FbtqEHPlyuTt%2FMJ6UjEuzPqJtXGlGODdMoK%2Fimg.png",
             "finedustbad".localized : "https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fk.kakaocdn.net%2Fdn%2FkIqsC%2FbtqEGT92fDc%2FHdq9Qowhgxvbrn94igvzMK%2Fimg.png",
             "finedustVeryBad".localized : "https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fk.kakaocdn.net%2Fdn%2FkIqsC%2FbtqEGT92fDc%2FHdq9Qowhgxvbrn94igvzMK%2Fimg.png",
             "error" : "https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fk.kakaocdn.net%2Fdn%2FcS1hww%2FbtqEHwmgknK%2FbGRKaSROZtWEeQtWtM2SCk%2Fimg.png"
            ]
        
        return results[gradeName] ?? results["error"]!
    }
    
    static func getFinedustGradeName(data : Int) -> String {
        let results : [Int : String] = [
            1:"finedustGood".localized, 2:"finedustModerate".localized,
            3:"finedustbad".localized, 4:"finedustVeryBad".localized]
        return results[data] ?? "알 수 없음"
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
                print("[Log] 파싱 결과 : ", myCity)
                
                let cityName = myCity.map{$0["cityNameEng"].stringValue}.last ?? ""
                let pm10Value = myCity.map{$0["pm10Value"].intValue}.last ?? 1
                let pm25Value = myCity.map{$0["pm25Value"].intValue}.last ?? 1
                let pm10Grade = pm10Value.checkFinedustGrade(data: pm10Value)
                let pm25Grade = pm25Value.checkFinedustGrade(data: pm25Value)
                let datatime = myCity.map{$0["dataTime"].stringValue}.last ?? ""
                
                print("[Log] 현재 시간 :", datatime)
                let parsedData = FinedustInfo(cityName: cityName, pm10Value: pm10Value, pm10Grade: pm10Grade, pm25Value: pm25Value, pm25Grade: pm25Grade, dateTime: datatime)
                
                return parsedData
            } else {
                return FinedustInfo(cityName: "", pm10Value: 1, pm10Grade: 1, pm25Value: 1, pm25Grade: 1, dateTime: "")
        }
    }
    
    static func postDeviceToken(deviceToken : String) {
        let localUrl = "http://127.0.0.1:8000/sendToken/"
        let params = ["token": deviceToken]
        AF.request(localUrl, method: .post, parameters: params , encoding:
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
        let url = "http://openapi.airkorea.or.kr/openapi/services/rest/ArpltnInforInqireSvc/getCtprvnMesureSidoLIst?sidoName=\(userLocation)&searchCondition=DAILY&pageNo=1&numOfRows=20&ServiceKey=\(serviceKey)&ver=1.3(&_returnType=json"

        print("[Log] API 요청 URL : ", url)
        
        AF.request(url).validate(statusCode: 200..<300).responseJSON(completionHandler: { response in
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
