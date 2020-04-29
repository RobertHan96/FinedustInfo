import UIKit
import CoreLocation
import SwiftyJSON
import Alamofire

class MainController: MainViewController , CLLocationManagerDelegate{
    var finedustInfo : FinedustInfo?
    var locationManager : CLLocationManager!
    var userLocation : String = ""
    var userCityName : String = ""
    var baesUrl : String = ""
    let serviceKey : String =        "vxw6kTDU0b82BMHEWeUoQ1M61AFx%2BlCSDDTltXl7XfxhhCh9KW1VbMM%2BtxlwGq5bcoRdksnTX188kjbzL6EifQ%3D%3D"

    override func viewDidLoad() {
        super.viewDidLoad()
        refreshBtn.addTarget(self, action: #selector(refreshFinedustInfo(_:)), for: .touchUpInside)

        if locationPermissionCheck() == true {
            setValues()
        } else {
            print("위치 권한 요청 거부됨")
        }
    }

    @objc func refreshFinedustInfo(_ sender : UIButton!) {
        fetchUserLocation()
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
    
//    최초 설치 후 실행시, 권한 허용이 안되면 앱이 죽어버리므로, 권한 없을때의 예외사항 처리 필요
    func fetchUserLocation(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
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
        

    }
    func setIndicatorImageName(data : Int) -> String {
        let results : [Int : String] = [1:"good", 2:"moderate", 3:"bad", 4:"bad"]
        return results[data] ?? results[1]!
    }
    
    func checkFinedustGrade(data : Int) -> String {
        let results : [Int : String] = [1:"좋음", 2:"보통", 3:"나쁨", 4:"매우나쁨"]
        return results[data] ?? results[1]!
    }

    func sendRequest() {
        let baseURL : String = "http://openapi.airkorea.or.kr/openapi/services/rest/ArpltnInforInqireSvc/getMsrstnAcctoRltmMesureDnsty?stationName=\(self.userLocation)&dataTerm=daily&pageNo=1&numOfRows=1&ServiceKey=\(self.serviceKey)&ver=1.3(&_returnType=json"

        AF.request(baseURL).validate(statusCode: 200..<300).responseJSON(completionHandler: { response in
            switch(response.result) {
            case .success(_) :
                if let data = response.value {
                    print(data)
                }
                if let json = try? JSON(data: response.data!){
                    let pm10Value = json["list"].arrayValue.map { $0["pm10Value"].intValue}
                    let pm25Value = json["list"].arrayValue.map { $0["pm25Value"].intValue}
                    let pm10Grade = json["list"].arrayValue.map { $0["pm10Grade"].intValue}
                    let pm25Grade = json["list"].arrayValue.map { $0["pm25Grade"].intValue}
                    let datatime = json["list"].arrayValue.map { $0["dataTime"].stringValue}
                    self.finedustInfo = FinedustInfo(finedustValue: pm10Value.last ?? 0 , finedustGrade: pm10Grade.last ?? 0, ultraFineDuestValue: pm25Value.last ?? 0, ultraFineDustGrade: pm25Grade.last ?? 0, dateTime: datatime.last ?? "2020-12-31")
                }
                break ;
            case .failure(_) :
                print("data request is failed, \(response.result)")
                break;
            }
        }
    )}
    
    func setValues() {
        if locationPermissionCheck() == true {
            activityIndicator.startAnimating()
            fetchUserLocation()
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                self.sendRequest()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000)) {
                guard let finedustValue = self.finedustInfo?.finedustValue else {return }
                guard let finedustGrade = self.finedustInfo?.finedustGrade else {return}
                guard let ultraFinedustValue = self.finedustInfo?.ultraFineDuestValue else {return }
                guard let ultraFinedustGrade = self.finedustInfo?.ultraFineDustGrade else {return}
                guard let dataTime = self.finedustInfo?.dateTime else {return}
                self.indicatorFaceImageView.image = UIImage(named: self.setIndicatorImageName(data: finedustGrade))
                self.indicatorLabel.text = self.checkFinedustGrade(data: finedustGrade)
                self.finedustIndexLabel.text = String(finedustValue)
                self.ultraFinedustIndexLabel.text = String(ultraFinedustValue)
                self.finedustGradeLabel.text = self.checkFinedustGrade(data: finedustGrade)
                self.ultraFinedustGradeLabel.text = self.checkFinedustGrade(data: ultraFinedustGrade)
                self.dateTimeLabel.text = String(dataTime)
                self.activityIndicator.stopAnimating()
            }
            
        } else {
            print("권한 요청 거부됨")
        }

    }

}
