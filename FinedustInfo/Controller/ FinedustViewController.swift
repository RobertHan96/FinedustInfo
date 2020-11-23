import UIKit
import Kingfisher

class FinedustViewController: UIViewController{
    let imageSelector = IndecatorImgeSelector()
    let encodedUserProvince = UserDefaults.standard.object(forKey: "encodedUserProvince") as? String
    let encodedUserCity = UserDefaults.standard.object(forKey: "encodedUserCity") as? String
    let unEncodedUserCity = UserDefaults.standard.object(forKey: "unEncodedUserCity") as? String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        makeConstraints()
        refreshBtn.addTarget(self, action: #selector(refreshFinedustInfo(_:)), for: .touchUpInside)
        DispatchQueue.main.async {
            self.getFinedustInfo()
        }
    }
        
    @objc func refreshFinedustInfo(_ sender : UIButton!) {
        print("Log 미세먼지 정보 재요청...")
        getFinedustInfo()
    }
    
    func getFinedustInfo() {
        let defaultProvince = "%EC%84%9C%EC%9A%B8"
        let defaultCity = "%EA%B4%91%EC%A7%84%EA%B5%AC"
        FinedustInfo.getFinedustData(sido: defaultProvince, city: defaultCity) { (data) in
            self.setupUI(componets: data)
        }
    }
    
    func setupUI(componets : FinedustViewComponents) {
        makeCircleImage(url: componets.imageUrl!)
        self.indicatorLabel.text = componets.pm10Grade
        self.finedustIndexLabel.text = String(componets.pm10Value)
        self.finedustGradeLabel.text = componets.pm10Grade
        self.ultraFinedustIndexLabel.text = String(componets.pm25Value)
        self.ultraFinedustGradeLabel.text = componets.pm25Grade
        self.dateTimeLabel.text = componets.datetime
        self.LocationNameLabel.text = componets.currentLoction
        self.view.layoutIfNeeded()
        print("[Log] UI셋팅 완료")
    }
    
    func makeCircleImage(url : URL) {
        let imageSize =  self.indicatorFaceImageView.bounds.size
        let processor = DownsamplingImageProcessor(size: imageSize)
            |> RoundCornerImageProcessor(cornerRadius: 10)
        self.indicatorFaceImageView.kf.indicatorType = .activity
        self.indicatorFaceImageView.kf.setImage(with: url, options:
            [ .processor(processor) ])
    }
    let backgroundImageView = UIImageView().then { _ in }
    let containerView = UIImageView().then {_ in }
    let detailInfoView = UIView().then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.cornerRadius = 10
    }
    let locationImageView = UIImageView().then {
        let locationIcon = UIImage(named: "locationIndicatorImageName".localized)
        $0.image = locationIcon
    }
    let LocationNameLabel = UILabel().then {
        $0.text = ""
        $0.adjustsFontSizeToFitWidth = true
        $0.font = UIFont.systemFont(ofSize: 18)
        $0.textColor = .black
    }
    let refreshBtn = UIButton().then {
        let image = UIImage(named: "refreschBtnImageName".localized)
        $0.setImage(image, for: .normal)
    }
    let indicatorFaceImageView = UIImageView().then {
        let face = UIImage(named: "loadFailErrorImageName".localized)
        $0.image = face
    }
    let indicatorLabel = UILabel().then {
        $0.text = "finedustGradeDefaultText".localized
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
        $0.text = "finedustIndexDefaultText".localized
        $0.adjustsFontSizeToFitWidth = true
        $0.font = UIFont.boldSystemFont(ofSize: 24)
        $0.textColor = .black
    }
    let ultraFinedustIndexLabel = UILabel().then {
        $0.text = "finedustIndexDefaultText".localized
        $0.adjustsFontSizeToFitWidth = true
        $0.font = UIFont.boldSystemFont(ofSize: 24)
        $0.textColor = .black
    }
    let dateTimeLabel = UILabel().then {
        $0.text = ""
        $0.adjustsFontSizeToFitWidth = true
        $0.font = UIFont.systemFont(ofSize: 18)
        $0.textColor = .darkGray
    }

}
