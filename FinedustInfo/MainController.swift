import UIKit
import CoreLocation
import SwiftyJSON
import Alamofire
import Kingfisher
import FirebaseMessaging
import FirebaseInstanceID

class MainController: MainViewController , CLLocationManagerDelegate{
    var locationManager : CLLocationManager!
    private let serviceKey : String =        "Rj3kKMVbru0VayKTDlnSUCjbsuko3ZKRyXCKckQ%2Fe2lGHsThH3i6W07DfKPezNmNuAzD%2FpZBhOOTIGbIs3gOXg%3D%3D"
    var encodedUserProvince = ""
    var encodedUserCity = ""
    var unEncodedUserCity = ""
    var baesUrl : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setValues()
        refreshBtn.addTarget(self, action: #selector(refreshFinedustInfo(_:)), for: .touchUpInside)
        printDeviceToken()
    }
    
    @objc func refreshFinedustInfo(_ sender : UIButton!) {
        setValues()
    }

    func printDeviceToken() {
        InstanceID.instanceID().instanceID { (result, error) in
          if let error = error {
            print("Error fetching remote instance ID: \(error)")
          } else if let result = result {
            print("Remote instance ID token: \(result.token)")
          }
        }
    }

    func locationPermissionCheck() -> Bool {
        let status = CLLocationManager.authorizationStatus()
        if status == CLAuthorizationStatus.denied || status == CLAuthorizationStatus.restricted {
            
            let alter = UIAlertController(title: "permissionDeniedAlertTitle".localized, message: "permissionDeniedAlertContent".localized, preferredStyle: UIAlertController.Style.alert)
            let logOkAction = UIAlertAction(title: "네", style: UIAlertAction.Style.default){
                (action: UIAlertAction) in
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(NSURL(string:UIApplication.openSettingsURLString)! as URL)
                } else {
                    UIApplication.shared.openURL(NSURL(string: UIApplication.openSettingsURLString)! as URL)
                }
            }
            let logNoAction = UIAlertAction(title: "아니오", style: UIAlertAction.Style.destructive){
                (action: UIAlertAction) in
                exit(0)}
            alter.addAction(logOkAction)
            alter.addAction(logNoAction)
            self.present(alter, animated: true, completion: nil)
            return false
        } else {
            return true
        }
    }
    
    func fetchUserLocation(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        if locationPermissionCheck() == true {
            let coord = locationManager.location?.coordinate
            if let lat = coord?.latitude, let lng = coord?.longitude {
                let currentLocation = CLLocation(latitude: lat, longitude: lng)
                let geoCoorder = CLGeocoder()
                let locale : Locale = Locale(identifier: "Ko-kr")
                geoCoorder.reverseGeocodeLocation(currentLocation, preferredLocale: locale) { (place, error) in
                        if let address: [CLPlacemark] = place {
                            let province = (address.last?.administrativeArea)! as String
                            let city = (address.last?.locality)! as String
                            let provinceShortForm = String(province[province.startIndex ..< province.index(province.startIndex, offsetBy: 2)])
                            print("유저 위치 정보 : \(province)(\(provinceShortForm)) \(city)")
                            self.encodedUserProvince = province.makeStringKoreanEncoded(provinceShortForm)
                            self.encodedUserCity = city.makeStringKoreanEncoded(city)
                            self.unEncodedUserCity = city
                            self.LocationNameLabel.text = city
                            
                    }
                }
            }
        } else {
            print("위치 권한 요청 거부됨")
        }
    }
    
    func setValues() {
        activityIndicator.startAnimating()
        fetchUserLocation()
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1500)) {
            FinedustInfo.sendRequest(userLocation: self.encodedUserProvince, cityName: self.unEncodedUserCity, serviceKey: self.serviceKey, completion: { (nowFinedust) in
    
                let userLanguage = Locale.current.languageCode
                let finedustGradeName = FinedustInfo.getFinedustGradeName(data: nowFinedust.finedustGrade)
                let userCityName = nowFinedust.cityName
                let ultraFinedustGradeName = FinedustInfo.getFinedustGradeName(data: nowFinedust.ultraFineDustGrade)
                
                // 이미지 url 파싱 후 적용하는 부분
                let url = URL(string: FinedustInfo.getImgUrl(gradeName: finedustGradeName))
                let processor = DownsamplingImageProcessor(size: self.indicatorFaceImageView.bounds.size)
                    |> RoundCornerImageProcessor(cornerRadius: 100)
                self.indicatorFaceImageView.kf.indicatorType = .activity
                self.indicatorFaceImageView.kf.setImage(with: url, options:
                    [ .processor(processor) ]
                )

                // 이미지 외 다른 UI컴포넌트에 값 할당
                if userLanguage != "ko" {
                    self.LocationNameLabel.text = userCityName
                }
                self.indicatorLabel.text = finedustGradeName
                self.finedustIndexLabel.text =  String(nowFinedust.finedustValue)
                self.finedustGradeLabel.text = finedustGradeName
                self.ultraFinedustIndexLabel.text =  String(nowFinedust.ultraFineDuestValue)
                self.ultraFinedustGradeLabel.text = ultraFinedustGradeName
                self.dateTimeLabel.text = String(nowFinedust.dateTime)
                self.activityIndicator.stopAnimating()
            })
            
        }


    }

}
