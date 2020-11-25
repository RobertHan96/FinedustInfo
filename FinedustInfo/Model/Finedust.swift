import Foundation

struct Finedust {
    var location : String = ""
    var pm10Grade : String = ""
    var pm10Value : Int = 0
    var pm25Grade : String = ""
    var pm25Value : Int = 0
    var dateTime : String = ""
    var imageUrl : URL = URL(string: FinedustApiConstant.apiKey.rawValue)!
    
    func getTimeNow() -> String {
        var formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var current_date_string = formatter.string(from: Date())
        return current_date_string
    }
}
