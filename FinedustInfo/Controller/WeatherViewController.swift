import UIKit
import SnapKit
import Then
import CoreLocation

protocol FinedustDataSource {
}

class WeatherViewController: UIViewController, CLLocationManagerDelegate {
    var locationManager : CLLocationManager = CLLocationManager()
    var currentLocation : CLLocation!
    var userLocation : UserLocationManager = UserLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setUserLocation()
        setupUI()
        makeConstraints()
        let currentLocation = userLocation.getEencodedUserProvince()
        let weatherData = getWeatherData{ (weather) in
            self.setupUIFromWeatherData(weatherData: weather)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if CLLocationManager.locationServicesEnabled() {
            if CLLocationManager.authorizationStatus() == .denied || CLLocationManager.authorizationStatus() == .restricted {
                let alert = UIAlertController(title: "오류 발생", message: "위치 서비스 기능이 꺼져있음", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            } else {
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.delegate = self
                locationManager.requestWhenInUseAuthorization()
            }
        } else {
            let alert = UIAlertController(title: "오류 발생", message: "위치 서비스 제공 불가", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch(CLLocationManager.authorizationStatus()) {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .denied, .notDetermined, .restricted:
            locationManager.stopUpdatingLocation()
        }
    }
    
    private func setUserLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        self.currentLocation = locationManager.location
        userLocation.saveLocationToUserDefault(location: self.currentLocation)
        print("[Log] 현재 위치 : \(userLocation.getEencodedUserProvince()) - \(userLocation.getEncodedUserCity())")
    }
    
    private func getWeatherData(completion:@escaping (Weather) -> Void) -> Weather {
        var weatherData : Weather?
        WeatherApi().sendRequest { (weather) in
            weatherData = weather
            completion(weather)
        }
        guard let weatherValue = weatherData else { return Weather() }
        return weatherValue
    }
    
    private func setupUIFromWeatherData(weatherData : Weather) {
        print("Log",weatherData)
        self.tempLabelContainerView.minTempValueLabel.text = String(weatherData.minTemp)
        self.tempLabelContainerView.maxTempValueLabel.text = String(weatherData.maxTemp)
        self.tempLabelContainerView.humidityValueLabel.text = "\(weatherData.humidity)%"
        self.weatherNameLabel.text = weatherData.weatherName
        self.tempLabel.text = String(weatherData.temp)
        
        let imageUrl = URL(string: weatherData.imageUrl)
        let urlData = try? Data(contentsOf: imageUrl!)
        self.weatherIconImageView.image = UIImage(data: urlData!)
    }
        
    let backgroundImageView = UIImageView().then {
        $0.backgroundColor = .clear
    }
    let containerView = UIView().then {_ in }
    let weatherIconImageView = UIImageView().then {
        let icon = UIImage(named: "10d@4x")
        $0.image = icon
    }
    let cityNameLabel = UILabel().then {
        $0.text = "Seoul"
        $0.adjustsFontSizeToFitWidth = true
        $0.font = UIFont.systemFont(ofSize: 110)
        $0.textColor = .black
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    let tempLabel = UILabel().then {
        $0.text = "29"
        $0.adjustsFontSizeToFitWidth = true
        $0.font = UIFont.systemFont(ofSize: 54)
        $0.textColor = .black
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    let weatherNameLabel = UILabel().then{
        $0.text = "맑음"
        $0.adjustsFontSizeToFitWidth = true
        $0.font = UIFont.systemFont(ofSize: 70)
        $0.textColor = .black
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    let tempLabelContainerView = TempInfoView()
}
