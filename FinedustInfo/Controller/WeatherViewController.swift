import UIKit
import SnapKit
import Then

class WeatherViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupUI()
        makeConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let weatherData = getWeatherData{ (weather) in
            self.setupUIFromWeatherData(weatherData: weather)
        }
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
        self.minTempValueLabel.text = String(weatherData.minTemp)
        self.maxTempValueLabel.text = String(weatherData.maxTemp)
        self.weatherNameLabel.text = weatherData.weatherName
        
    }
    let backgroundImageView = UIImageView().then {
        let backgroundImage = UIImage(named: "Good")
        $0.image = backgroundImage
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
    let weatherNameLabel = UILabel().then{
        $0.text = "맑음"
        $0.adjustsFontSizeToFitWidth = true
        $0.font = UIFont.systemFont(ofSize: 70)
        $0.textColor = .black
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    let tempLabelContainerView = UIView().then { _ in }
    let minTempValueLabel = UILabel().then {
        $0.text = "2"
        $0.adjustsFontSizeToFitWidth = true
        $0.font = UIFont.systemFont(ofSize: 32)
        $0.textColor = .black
    }
    let maxTempValueLabel = UILabel().then {
        $0.text = "18"
        $0.adjustsFontSizeToFitWidth = true
        $0.font = UIFont.systemFont(ofSize: 32)
        $0.textColor = .black
    }
}
