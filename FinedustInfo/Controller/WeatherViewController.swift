import UIKit
import SnapKit
import Then
import GoogleMobileAds
import CoreLocation

class WeatherViewController: UIViewController, CLLocationManagerDelegate {
    var locationManager : CLLocationManager = CLLocationManager()
    var currentLocation : CLLocation!
    var userLocation : UserLocationManager = UserLocationManager()
    let ad = AppDelegate()
    var bannerView : GADBannerView!
    
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
        self.tempLabelContainerView.minTempValueLabel.text = "\(weatherData.minTemp)℃"
        self.tempLabelContainerView.maxTempValueLabel.text = "\(weatherData.maxTemp)℃"
        self.tempLabelContainerView.humidityValueLabel.text = "\(weatherData.humidity)%"
        self.weatherNameLabel.text = weatherData.weatherName
        self.tempLabel.text = "\(weatherData.temp)℃"
        
        let imageName = Weather().getImageName(weatherData.weatherName)
        let imageUrl = URL(string: weatherData.imageUrl)
        let backgroundImage = UIImage(named: imageName)
        let urlData = try? Data(contentsOf: imageUrl!)
        self.backgroundImageView.image = backgroundImage
        self.weatherIconImageView.image = UIImage(data: urlData!)
        self.ad.imageName = imageName
    }
        
    let currentViewIndicatorCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout()).then {
        let layout = UICollectionViewFlowLayout()
        $0.register(UINib(nibName: "CurrentViewIndicatorCell", bundle: nil),
            forCellWithReuseIdentifier: "CurrentViewIndicatorCell")
        $0.backgroundColor = .none
        layout.minimumLineSpacing = 1
        layout.scrollDirection = .vertical
        layout.itemSize = .init(width: 20, height: 20)
        $0.collectionViewLayout = layout
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

extension WeatherViewController :  UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MainPageViewController().viewContorllerList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CurrentViewIndicatorCell", for: indexPath) as? CurrentViewIndicatorCell else { return UICollectionViewCell() }
        if indexPath.row == 0 {
            let image = UIImage(named: "fillCircle")
            cell.currentViewImage.image = image
        }
        return cell
    }
}
