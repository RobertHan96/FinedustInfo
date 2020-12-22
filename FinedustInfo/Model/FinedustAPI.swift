import Foundation
import CoreLocation
import Alamofire
import SwiftyJSON

enum FinedustApiConstant : String {
    case defaultImageUrl = "https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FkIqsC%2FbtqEGT92fDc%2FHdq9Qowhgxvbrn94igvzMK%2Fimg.png"
    case apiKey = "ZiSNIwgl%2BWu%2FVFxTGPUa%2FCHGRtQTKy4RRj88RPZbBXz0hhxW2c9L7nBijrKzinyX4dHrc%2FBhHjh6EH0nqAsJaw%3D%3D"
    case baseUrl =
 "http://apis.data.go.kr/B552584/ArpltnStatsSvc/getCtprvnMesureSidoLIst?sidoName=%EC%84%9C%EC%9A%B8&searchCondition=HOUR&pageNo=1&numOfRows=100&returnType=json&serviceKey=ZiSNIwgl%2BWu%2FVFxTGPUa%2FCHGRtQTKy4RRj88RPZbBXz0hhxW2c9L7nBijrKzinyX4dHrc%2FBhHjh6EH0nqAsJaw%3D%3D"
    
}

struct FinedustAPI {
    init(location : String) {
        self.location = location
    }

    var location = "" {
        didSet {
            let params =  ["sidoName" : UserLocationManager().getEencodedUserProvince()]
            let urlParams = params.flatMap({ (key, value) -> String in
            return "\(key)=\(value)"
            }).joined(separator: "&")
            let withURL = FinedustApiConstant.baseUrl.rawValue + "?\(urlParams)"
            let encodedUrl = withURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                + "&searchCondition=" + "DAILY" + "&serviceKey=" + FinedustApiConstant.apiKey.rawValue + "&_returnType=json"
            requestUrl = URL(string:encodedUrl)!
        }
    }
    
    var requestUrl : URL = URL(string: FinedustApiConstant.baseUrl.rawValue)!
    
    func getFinedustData(completion:@escaping (Finedust) -> Void) {
        print("LOG", self.requestUrl, self.location)
        AF.request(self.requestUrl, method : .get, encoding: JSONEncoding.default).validate(statusCode: 200..<300).responseJSON{ response in
            switch(response.result) {
            case .success(_) :
                if let data = response.data {
                    print("logHeader".localized, "미세먼지 정보 요청 성공" )
                    let finedust = getFinedustFromJson(inputData: data)
                    completion(finedust)
                }
                break ;
            case .failure(_) :
                print("logHeader".localized, response.result)
                break ;
            }
        }
    }
    
    func getFinedustFromJson(inputData : Data) -> Finedust {
        if let json = try? JSON(data: inputData) {
            let list = json["response"]["body"]["items"].arrayValue
            print("log tt", list)

            let citis = list.filter{ city -> Bool in
                return city.arrayValue != nil
        }
            
        let myCity = citis.filter { city -> Bool in
            let userCity = UserLocationManager().getUnEncodedUserCity()
            let cityName = city["cityName"].stringValue
            return cityName == userCity
        }
            
        let cityName = myCity.map{$0["cityNameEng"].stringValue}.last ?? ""
        let pm10Value = myCity.map{$0["pm10Value"].intValue}.last ?? 1
        let pm25Value = myCity.map{$0["pm25Value"].intValue}.last ?? 1
            let pm10Grade = pm10Value.getFinedustGradeNumber
            let pm25Grade = pm25Value.getFinedustGradeNumber
        let datatime = myCity.map{$0["dataTime"].stringValue}.last ?? ""
            let parsedData = Finedust(location: location, pm10Grade: pm10Grade.finedustGradeName ,
                                    pm10Value: pm10Value, pm25Grade: pm25Grade.finedustGradeName,
                                    pm25Value: pm25Value, dateTime: datatime)
            return parsedData
        } else {
            return Finedust(location: location, pm10Grade: "-", pm10Value: 1, pm25Grade: "-",
                          pm25Value: 1, dateTime: "")
        }
    }
    
}

