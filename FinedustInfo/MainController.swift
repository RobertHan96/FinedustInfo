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
        refreshBtn.addTarget(self, action: #selector(refreshFinedustInfo(_:)), for: .touchUpInside)
        DispatchQueue.global(qos: .userInitiated).async {
            self.fetchUserLocation()
            DispatchQueue.main.async {
                self.getFinedustInfo()
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        DispatchQueue.global(qos: .userInitiated).async {
            let delay = DispatchTime.now() + .milliseconds(500)
            self.fetchUserLocation()
            DispatchQueue.main.asyncAfter(deadline: delay) {
                self.getFinedustInfo()
            }
        }
    }
    
    @objc func refreshFinedustInfo(_ sender : UIButton!) {
        fetchUserLocation()
        getFinedustInfo()
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
    } // fetchUserLocation
    
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
                            print("Log : 유저위치 : \(province)(\(provinceShortForm)) \(city)")
                            self.encodedUserProvince = province.makeStringKoreanEncoded(provinceShortForm)
                            self.encodedUserCity = city.makeStringKoreanEncoded(city)
                            self.unEncodedUserCity = city
                            self.LocationNameLabel.text = city
                            
                    }
                }
            }
        } else {
            print("Log : 위치 권한 요청 거부됨")
        }
    } // fetchUserLocation
        
    func getFinedustInfo() {
        FinedustInfo.sendRequest(userLocation: self.encodedUserProvince, cityName: self.unEncodedUserCity, serviceKey: self.serviceKey, completion: { (nowFinedust) in
            let userLanguage = Locale.current.languageCode
            let finedustIndex = String(nowFinedust.finedustValue)
            let finedustGrade = FinedustInfo.getFinedustGradeName(data: nowFinedust.finedustGrade)
            let city = nowFinedust.cityName
            let ultraFinedustIndex = String(nowFinedust.ultraFineDuestValue)
            let ultraFinedustGrade = FinedustInfo.getFinedustGradeName(data: nowFinedust.ultraFineDustGrade)
            let time = String(nowFinedust.dateTime)
            // 이미지 url 파싱 후 적용하는 부분
            let url = URL(string: FinedustInfo.getImgUrl(gradeName: finedustGrade))
                if userLanguage != "ko" { self.LocationNameLabel.text = city }
            self.setupUI(fGrade: finedustGrade, fIndex: finedustIndex, ufGrade: ultraFinedustGrade, ufindex: ultraFinedustIndex, time: time, imgUrl: url!)
            // DispatchQueue.main.async
        }) // FineduestInfo.sendRequst
    } // getInfo Function
    
    func setupUI(fGrade : String, fIndex : String, ufGrade : String,
                 ufindex: String, time : String, imgUrl : URL) {
        self.activityIndicator.startAnimating()
        let processor = DownsamplingImageProcessor(size: self.indicatorFaceImageView.bounds.size)
            |> RoundCornerImageProcessor(cornerRadius: 100)
        self.indicatorFaceImageView.kf.indicatorType = .activity
        self.indicatorFaceImageView.kf.setImage(with: imgUrl, options:
            [ .processor(processor) ])

        self.indicatorLabel.text = fGrade
        self.finedustIndexLabel.text = fIndex
        self.finedustGradeLabel.text = fGrade
        self.ultraFinedustIndexLabel.text = ufindex
        self.ultraFinedustGradeLabel.text = ufGrade
        self.dateTimeLabel.text = time
        self.activityIndicator.stopAnimating()
        self.view.layoutIfNeeded()
        print("[Log] UI셋팅 완료")
    } // setupUI

}
