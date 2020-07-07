import UIKit
import SnapKit
import Then

class MainViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        makeConstraints()
    }
    
    func setupUI() {
        view.backgroundColor = .groupTableViewBackground
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
        let face = UIImage(named: "fail_to_load")
        $0.image = face
    }
    let indicatorLabel = UILabel().then {
        $0.text = "매우 좋음"
        $0.adjustsFontSizeToFitWidth = true
        $0.font = UIFont.systemFont(ofSize: 35)
        $0.textColor = .black
    }
    let finedustNameLabel = UILabel().then {
        $0.text = "finedust".localized
        $0.adjustsFontSizeToFitWidth = true
        $0.font = UIFont.systemFont(ofSize: 24)
        $0.textColor = .black
    }
    let ultraFinedustNameLabel = UILabel().then {
        $0.text = "ultraFinedust".localized
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

