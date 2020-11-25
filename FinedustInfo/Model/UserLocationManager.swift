import Foundation
import CoreLocation

struct UserLocationManager {
    
    func saveLocationToUserDefault(location : CLLocation) {
        let coord = location.coordinate
        let currentLocation = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
        let geoCoorder = CLGeocoder()
        let locale : Locale = Locale(identifier: "Ko-kr")
        geoCoorder.reverseGeocodeLocation(currentLocation, preferredLocale: locale) { (place, error) in
            if let address: [CLPlacemark] = place {
                let province = (address.last?.administrativeArea)! as String
                let city = (address.last?.locality)! as String
                let provinceShortForm = String(province[province.startIndex ..< province.index(province.startIndex, offsetBy: 2)])
                
                UserDefaults.standard.set(province.makeStringKoreanEncoded, forKey: "encodedUserProvince")
                UserDefaults.standard.set(city, forKey: "unEncodedUserCity")
                UserDefaults.standard.set(city.makeStringKoreanEncoded, forKey: "encodedUserCity")
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    func getUnEncodedUserCity() -> String {
        guard let city = UserDefaults.standard.object(forKey: "unEncodedUserCity") as? String else { return ""}
        return city
    }

    func getEncodedUserCity() -> String {
        guard let city = UserDefaults.standard.object(forKey: "encodedUserCity") as? String else { return ""}
        return city
    }
  
    func getEencodedUserProvince() -> String {
        guard let city = UserDefaults.standard.object(forKey: "encodedUserProvince") as? String
                        else { return ""}
        let strIndex = city.index(city.startIndex, offsetBy: 2)
        let location = city.substring(to: strIndex)

        return location
    }

}
