import UIKit
import SnapKit
import Then

extension WeatherViewController {
    func setBackgroundImageByWeather(_ weather  : String) {
        let weatherImageName = weather
        backgroundImageView.image = UIImage(named: weatherImageName)
    }
    
    func setupUI() {
        currentViewIndicatorCollectionView.delegate = self
        currentViewIndicatorCollectionView.dataSource = self
        view.addSubview(backgroundImageView)
        view.addSubview(containerView)
        view.addSubview(weatherIconImageView)
        view.addSubview(cityNameLabel)
        view.addSubview(weatherNameLabel)
        view.addSubview(tempLabelContainerView)
        view.addSubview(tempLabel)
        view.addSubview(currentViewIndicatorCollectionView)
    }
    
    func makeConstraints() {
        backgroundImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top).offset(0)
            make.left.equalTo(self.view.snp.left).offset(0)
            make.right.equalTo(self.view.snp.right).offset(0)
            make.bottom.equalTo(self.view.snp.bottom).offset(0)
        }
        containerView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
            make.left.equalTo(self.backgroundImageView.snp.left).offset(20)
            make.right.equalTo(self.backgroundImageView.snp.right).offset(0)
            make.height.equalTo(self.view.safeAreaLayoutGuide.snp.height).multipliedBy(0.7)
        }
        cityNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.containerView.snp.top).offset(20)
            make.left.equalTo(self.containerView.snp.left).offset(0)
            make.right.greaterThanOrEqualTo(self.containerView.snp.right).offset(-20)
        }
        weatherIconImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.cityNameLabel.snp.bottom).offset(12)
            make.width.equalTo(100)
            make.height.equalTo(100)
            make.left.equalTo(self.containerView.snp.left).offset(0)
        }
        weatherNameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.weatherIconImageView)
            make.left.equalTo(self.weatherIconImageView.snp.right).offset(12)
            make.right.greaterThanOrEqualTo(self.tempLabel.snp.left).offset(-20)
        }
        tempLabel.snp.makeConstraints { (make) in
            make.top.equalTo(weatherIconImageView.snp.bottom).offset(12)
            make.left.equalTo(self.containerView.snp.left).offset(0)
            make.right.lessThanOrEqualTo(self.containerView.snp.right).offset(-20)
        }
        tempLabelContainerView.snp.makeConstraints { (make) in
            make.top.equalTo(tempLabel.snp.bottom).offset(14)
            make.left.equalTo(self.containerView.snp.left).offset(0)
            make.right.equalTo(self.containerView.snp.right).offset(0)
            make.height.greaterThanOrEqualTo(100)
        }
        currentViewIndicatorCollectionView.snp.makeConstraints { (make) in
            make.top.greaterThanOrEqualTo(self.tempLabelContainerView.snp.bottom).offset(0)
            make.centerX.equalTo(self.backgroundImageView).offset(0)
            make.height.equalTo(24)
            make.width.equalTo(50)
            make.bottom.equalTo(self.backgroundImageView.snp.bottom).offset(-10)
        }
        
    }
}
