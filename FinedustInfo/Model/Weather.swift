import Foundation

struct Weather {
    let weathers = ["Good" : ["Clear", "Clear sky", "Few clouds"],
                   "Moderate" : ["Scattered clouds", "Broken clouds", "Shower rain", "Clouds"],
                   "Bad" : ["Rain","Thunderstorm", "Snow", "Mist"]]
    var weatherName = ""
    var temp : Int = 1
    var minTemp :Int = 1
    var maxTemp :Int = 1
    var humidity :Int = 1
    var imageUrl = "http://openweathermap.org/img/wn/50n@2x.png"
    
    func getImageName(_ name : String) -> String {
        var imageName = ""
        for grade in weathers {
            if grade.value.contains(name) {
                imageName =  grade.key
            }
        }
        return imageName
    }
    
}

