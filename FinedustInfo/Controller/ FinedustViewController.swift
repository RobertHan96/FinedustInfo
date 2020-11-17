import UIKit
import CoreLocation
import SwiftyJSON
import Kingfisher

class FinedustViewController: UIViewController{
    let imageSelector = IndecatorImgeSelector()
    let encodedUserProvince = UserDefaults.standard.object(forKey: "encodedUserProvince") as! String
    let encodedUserCity = UserDefaults.standard.object(forKey: "encodedUserCity") as! String
    let unEncodedUserCity = UserDefaults.standard.object(forKey: "unEncodedUserCity") as! String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray
        setupUI()
        makeConstraints()
        refreshBtn.addTarget(self, action: #selector(refreshFinedustInfo(_:)), for: .touchUpInside)
        DispatchQueue.main.async {
            self.getFinedustInfo()
        }
    }
        
    @objc func refreshFinedustInfo(_ sender : UIButton!) {
        getFinedustInfo()
    }

    func fetchLocationLabelIfKorean(location : String, label : UILabel) {
        let userLanguage = Locale.current.languageCode
        if userLanguage == "ko" {
            DispatchQueue.main.async {
                label.text = location
            }
        }
    }
    
    func getFinedustInfo() {
        let key = FinedustInfo.apiKey
        FinedustInfo.sendRequest(userLocation: encodedUserProvince, cityName: unEncodedUserCity, serviceKey: key , completion: { (nowFinedust) in
            let userLanguage = Locale.current.languageCode
            let finedustIndex = String(nowFinedust.finedustValue)
            let indecatorImageSelector = IndecatorImgeSelector(finedustGrade: nowFinedust.finedustGrade, ultraFinedustGrade: nowFinedust.ultraFineDustGrade)
            let city = nowFinedust.cityName
            let ultraFinedustIndex = String(nowFinedust.ultraFineDuestValue)
            let ultraFinedustGrade = indecatorImageSelector.getUFdustGradeName
            let finedustGrade = indecatorImageSelector.getFinedustGradeName
            let time = String(nowFinedust.dateTime)
            if userLanguage != "ko" {
                DispatchQueue.main.async {
                    self.LocationNameLabel.text = city
                }
            }
            self.imageSelector.getIndicatorImageUrl(finedustGrade: nowFinedust.finedustGrade) { (imgURL) in
                debugPrint(imgURL)
                self.setupUI(fGrade: finedustGrade, fIndex: finedustIndex, ufGrade: ultraFinedustGrade, ufindex: ultraFinedustIndex, time: time, imgUrl: imgURL)
            }
        }) // FineduestInfo.sendRequst
    } // getFinedustInfo Function
    
    func setupUI(fGrade : String, fIndex : String, ufGrade : String,
                 ufindex: String, time : String, imgUrl : URL) {
        self.activityIndicator.startAnimating()
//        setBackgroundImagebyFinedustGrade(grade: fGrade, currentView: self)
        makeCircleImage(url: imgUrl)
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
    
    func setBackgroundImagebyFinedustGrade(grade : String, currentView : FinedustViewController) {
        let locationNameLable = currentView.LocationNameLabel
        switch grade {
            case grade.finedustGradeBad :
                    currentView.backgroundImageView.image = UIImage(named: grade.finedustGradeBad)
                    currentView.view.bringSubviewToFront(locationNameLable)
            case grade.finedustGradeModerate :
                    currentView.backgroundImageView.image = UIImage(named: grade.finedustGradeModerate)
                    currentView.view.bringSubviewToFront(locationNameLable)
            default:
                currentView.backgroundImageView.image = UIImage(named: grade.finedustGradeGood)
                currentView.view.bringSubviewToFront(locationNameLable)
        }
    }
    
    func makeCircleImage(url : URL) {
        let imageSize =  self.indicatorFaceImageView.bounds.size
        let processor = DownsamplingImageProcessor(size: imageSize)
            |> RoundCornerImageProcessor(cornerRadius: 100)
        self.indicatorFaceImageView.kf.indicatorType = .activity
        self.indicatorFaceImageView.kf.setImage(with: url, options:
            [ .processor(processor) ])
    }
    
    lazy var activityIndicator: UIActivityIndicatorView = {
            let activityIndicator = UIActivityIndicatorView()
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            activityIndicator.center = self.view.center
            activityIndicator.color = UIColor.red
            activityIndicator.hidesWhenStopped = true
            activityIndicator.style = UIActivityIndicatorView.Style.white
            activityIndicator.stopAnimating()
            return activityIndicator }()
    
    let backgroundImageView = UIImageView().then {_ in}
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
