import UIKit
import CoreLocation
import SwiftyJSON
import Alamofire
import Kingfisher

class MainController: MainViewController , CLLocationManagerDelegate{
    var locationManager : CLLocationManager!
    var encodedUserProvince = ""
    var encodedUserCity = ""
    var unEncodedUserCity = ""

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
            let alert = UIAlertController(title: "permissionDeniedAlertTitle".localized, message: "permissionDeniedAlertContent".localized, preferredStyle: UIAlertController.Style.alert)
            alert.setupAlertActions()
            self.present(alert, animated: true, completion: nil)
            return false
        } else {
            return true
        }
    } // fetchUserLocation
    
    func fetchLocationLabelIfKorean(location : String, label : UILabel) {
        let userLanguage = Locale.current.languageCode
        if userLanguage == "ko" {
            DispatchQueue.main.async {
                label.text = location
            }
        }
    }
    
    func getUserLocation() {
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
                    self.fetchLocationLabelIfKorean(location: city, label: self.LocationNameLabel)
                }
            }
        }
    }
    
    func fetchUserLocation(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        if locationPermissionCheck() == true {
            getUserLocation()
        } else {
            print("Log : 위치 권한 요청 거부됨")
        }
    } // fetchUserLocation
            
    func getFinedustInfo() {
        let key = FinedustInfo.apiKey
        FinedustInfo.sendRequest(userLocation: self.encodedUserProvince, cityName: self.unEncodedUserCity, serviceKey: key , completion: { (nowFinedust) in
            let userLanguage = Locale.current.languageCode
            let finedustIndex = String(nowFinedust.finedustValue)
            let indecatorImageSelector = IndecatorImgeSelector(finedustGrade: nowFinedust.finedustGrade, ultraFinedustGrade: nowFinedust.ultraFineDustGrade)
            let city = nowFinedust.cityName
            let ultraFinedustIndex = String(nowFinedust.ultraFineDuestValue)
            let ultraFinedustGrade = indecatorImageSelector.getFinedustGradeName
            let finedustGrade = indecatorImageSelector.getFinedustGradeName
            let time = String(nowFinedust.dateTime)
            let url = URL(string: indecatorImageSelector.getImageUrl)
            if userLanguage != "ko" { self.LocationNameLabel.text = city }
            self.setupUI(fGrade: finedustGrade, fIndex: finedustIndex, ufGrade: ultraFinedustGrade, ufindex: ultraFinedustIndex, time: time, imgUrl: url!)
            // DispatchQueue.main.async
        }) // FineduestInfo.sendRequst
    } // getInfo Function
    
    func setupUI(fGrade : String, fIndex : String, ufGrade : String,
                 ufindex: String, time : String, imgUrl : URL) {
        self.activityIndicator.startAnimating()
        setBackgroundImagebyFinedustGrade(grade: fGrade)
        let imageSize =  self.indicatorFaceImageView.bounds.size
        let processor = DownsamplingImageProcessor(size: imageSize)
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

    func setBackgroundImagebyFinedustGrade(grade : String) {
        switch grade {
            case grade.finedustGradeBad :
                    self.backgroundImageView.image = UIImage(named: grade.finedustGradeBad)
                    self.view.bringSubviewToFront(LocationNameLabel)
            case grade.finedustGradeModerate :
                    self.backgroundImageView.image = UIImage(named: grade.finedustGradeModerate)
                    self.view.bringSubviewToFront(LocationNameLabel)
            default:
                self.backgroundImageView.image = UIImage(named: grade.finedustGradeGood)
                self.view.bringSubviewToFront(LocationNameLabel)
        }
    }
}
