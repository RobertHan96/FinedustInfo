import UIKit
import CoreLocation
import SwiftyJSON
import Alamofire

class MainController: MainViewController , CLLocationManagerDelegate{
    var nowFineustInfo : FinedustInfo?
    var locationManager : CLLocationManager!
    private let serviceKey : String =        "vxw6kTDU0b82BMHEWeUoQ1M61AFx%2BlCSDDTltXl7XfxhhCh9KW1VbMM%2BtxlwGq5bcoRdksnTX188kjbzL6EifQ%3D%3D"
    var userLocation : String = ""
    var userCityName : String = ""
    var baesUrl : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setValues()
        refreshBtn.addTarget(self, action: #selector(refreshFinedustInfo(_:)), for: .touchUpInside)
    }
    
    @objc func refreshFinedustInfo(_ sender : UIButton!) {
        setValues()
    }
    
    func locationPermissionCheck() -> Bool {
        let status = CLLocationManager.authorizationStatus()
        if status == CLAuthorizationStatus.denied || status == CLAuthorizationStatus.restricted {
            
            let alter = UIAlertController(title: "위치권한 설정이 거부됨", message: "앱 설정 화면으로 가시겠습니까? \n '아니오'를 선택하시면 앱이 종료됩니다.", preferredStyle: UIAlertController.Style.alert)
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
                            if let gu = address.last?.locality {
                                self.userLocation = gu.makeStringKoreanEncoded(gu)
                                self.userCityName = gu
                                self.LocationNameLabel.text = gu
                            }
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
            FinedustInfo.sendRequest(userLocation: self.userLocation, serviceKey: self.serviceKey, completion: { (nowFinedust) in
                let indicatorImg = FinedustInfo.setIndicatorImageName(data: nowFinedust.finedustGrade)
                let finedustGradName : String = String(FinedustInfo.checkFinedustGrade(data: nowFinedust.finedustGrade))
                let ultraFinedustGradName : String = String(FinedustInfo.checkFinedustGrade(data: nowFinedust.ultraFineDustGrade))

                self.indicatorFaceImageView.image = UIImage(named: indicatorImg)
                self.indicatorLabel.text = finedustGradName
                self.finedustIndexLabel.text = String(nowFinedust.finedustValue)
                self.finedustGradeLabel.text = finedustGradName
                self.ultraFinedustIndexLabel.text = String(nowFinedust.ultraFineDuestValue)
                self.ultraFinedustGradeLabel.text = ultraFinedustGradName
                self.dateTimeLabel.text = String(nowFinedust.dateTime)
                self.activityIndicator.stopAnimating()
            })
        }

    }

}
