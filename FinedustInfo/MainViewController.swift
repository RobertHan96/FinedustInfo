import UIKit
import CoreLocation

import SwiftyJSON
import SnapKit
import Then
import Alamofire



class MainViewController: UIViewController, CLLocationManagerDelegate {
    var finedustInfo : FinedustInfo?
    var locationManager : CLLocationManager!
    var userLocation : String = ""
    var userCityName : String = ""
    var baesUrl : String = ""
    let serviceKey : String =        "vxw6kTDU0b82BMHEWeUoQ1M61AFx%2BlCSDDTltXl7XfxhhCh9KW1VbMM%2BtxlwGq5bcoRdksnTX188kjbzL6EifQ%3D%3D"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        makeConstraints()
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
                            self.userLocation = self.makeStringKoreanEncoded(gu)
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
    
    func makeStringKoreanEncoded(_ string: String) -> String {
        return string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? string
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
            
    func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(LocationNameLabel)
        view.addSubview(containerView)
        view.addSubview(dateTimeLabel)
        view.addSubview(locationImageView)
        view.addSubview(indicatorFaceImageView)
        view.addSubview(indicatorLabel)
        view.addSubview(detailInfoView)
        view.addSubview(finedustNameLabel)
        view.addSubview(ultraFinedustNameLabel)
        view.addSubview(finedustGradeLabel)
        view.addSubview(ultraFinedustGradeLabel)
        view.addSubview(finedustIndexLabel)
        view.addSubview(ultraFinedustIndexLabel)
        view.addSubview(activityIndicator)
        view.addSubview(refreshBtn)
        refreshBtn.addTarget(self, action: #selector(refreshFinedustInfo(_:)), for: .touchUpInside)
    }
    func makeConstraints() {
        containerView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(30)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(10)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-10)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-10)
        }
        locationImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.containerView.snp.top).offset(0)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(20)
            make.height.equalTo(15)
            make.width.equalTo(20)
        }
        LocationNameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(locationImageView).offset(0)
            make.left.equalTo(locationImageView.snp.right).offset(10)
        }
        refreshBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-20)
            make.centerY.equalTo(locationImageView).offset(0)
            make.height.equalTo(20)
            make.width.equalTo(20)
        }
        indicatorFaceImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.locationImageView.snp.bottom).offset(40)
            make.centerX.equalTo(self.containerView).offset(0)
            make.height.lessThanOrEqualTo(200)
            make.width.lessThanOrEqualTo(200)
        }
        indicatorLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.indicatorFaceImageView).offset(0)
            make.top.equalTo(self.indicatorFaceImageView.snp.bottom).offset(30)
        }
        detailInfoView.snp.makeConstraints { (make) in
            make.top.equalTo(self.indicatorLabel.snp.bottom).offset(30)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(20)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-20)
            make.bottom.equalTo(self.ultraFinedustIndexLabel.snp.bottom).offset(20)
        }
        finedustNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.detailInfoView.snp.top).offset(20)
            make.left.equalTo(self.detailInfoView.snp.left).offset(20)
        }
        finedustGradeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.finedustNameLabel.snp.bottom).offset(10)
            make.centerX.equalTo(self.finedustNameLabel).offset(0)
        }
        finedustIndexLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.finedustGradeLabel.snp.bottom).offset(10)
            make.centerX.equalTo(self.finedustGradeLabel).offset(0)
        }
        ultraFinedustNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.detailInfoView.snp.top).offset(20)
            make.left.greaterThanOrEqualTo(self.finedustNameLabel.snp.right).offset(0)
            make.right.equalTo(self.detailInfoView.snp.right).offset(-20)
        }
        ultraFinedustGradeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.ultraFinedustNameLabel.snp.bottom).offset(10)
            make.centerX.equalTo(self.ultraFinedustNameLabel).offset(0)
        }
        ultraFinedustIndexLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.ultraFinedustGradeLabel.snp.bottom).offset(10)
            make.centerX.equalTo(self.ultraFinedustGradeLabel).offset(0)
        }
        dateTimeLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.containerView.snp.bottom).offset(-10)
            make.left.equalTo(self.containerView.snp.left).offset(20)
            make.right.equalTo(self.containerView.snp.right).offset(-20)
        }
    }

    lazy var activityIndicator: UIActivityIndicatorView = {
            let activityIndicator = UIActivityIndicatorView()
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            activityIndicator.center = self.view.center
            activityIndicator.color = UIColor.red
            // Also show the indicator even when the animation is stopped.
            activityIndicator.hidesWhenStopped = true
            activityIndicator.style = UIActivityIndicatorView.Style.white
            // Start animation.
            activityIndicator.stopAnimating()
            return activityIndicator }()

    let containerView = UIView().then { _ in    }
    let detailInfoView = UIView().then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.cornerRadius = 10
    }
    let locationImageView = UIImageView().then {
        let locationIcon = UIImage(named: "pin")
        $0.image = locationIcon
    }
    let LocationNameLabel = UILabel().then {
        $0.text = ""
        $0.adjustsFontSizeToFitWidth = true
        $0.font = UIFont.systemFont(ofSize: 18)
        $0.textColor = .black
    }
    let refreshBtn = UIButton().then {
        let image = UIImage(named: "refresh")
        $0.setImage(image, for: .normal)
    }
    let indicatorFaceImageView = UIImageView().then {
        let face = UIImage(named: "good")
        $0.image = face
    }
    let indicatorLabel = UILabel().then {
        $0.text = "매우 좋음"
        $0.adjustsFontSizeToFitWidth = true
        $0.font = UIFont.systemFont(ofSize: 35)
        $0.textColor = .black
    }
    let finedustNameLabel = UILabel().then {
        $0.text = "미세먼지"
        $0.adjustsFontSizeToFitWidth = true
        $0.font = UIFont.systemFont(ofSize: 24)
        $0.textColor = .black
    }
    let ultraFinedustNameLabel = UILabel().then {
        $0.text = "초미세먼지"
        $0.adjustsFontSizeToFitWidth = true
        $0.font = UIFont.systemFont(ofSize: 24)
        $0.textColor = .black
    }
    let finedustGradeLabel = UILabel().then {
        $0.text = ""
        $0.adjustsFontSizeToFitWidth = true
        $0.font = UIFont.boldSystemFont(ofSize: 24)
        $0.textColor = .black
    }
    let ultraFinedustGradeLabel = UILabel().then {
        $0.text = ""
        $0.adjustsFontSizeToFitWidth = true
        $0.font = UIFont.boldSystemFont(ofSize: 24)
        $0.textColor = .black
    }
    let finedustIndexLabel = UILabel().then {
        $0.text = "00"
        $0.adjustsFontSizeToFitWidth = true
        $0.font = UIFont.boldSystemFont(ofSize: 24)
        $0.textColor = .black
    }
    let ultraFinedustIndexLabel = UILabel().then {
        $0.text = "00"
        $0.adjustsFontSizeToFitWidth = true
        $0.font = UIFont.boldSystemFont(ofSize: 24)
        $0.textColor = .black
    }
    let dateTimeLabel = UILabel().then {
        $0.text = "2020-01-01 23:00"
        $0.adjustsFontSizeToFitWidth = true
        $0.font = UIFont.systemFont(ofSize: 18)
        $0.textColor = .darkGray
    }

}

