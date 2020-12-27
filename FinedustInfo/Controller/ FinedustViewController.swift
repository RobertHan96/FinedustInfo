import UIKit
import GoogleMobileAds
import SDWebImage

class FinedustViewController: UIViewController{
    let imageSelector = IndecatorImgeSelector()
    let ad = AppDelegate()
    let userLocation = UserLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        makeConstraints()
        refreshBtn.addTarget(self, action: #selector(refreshFinedustInfo(_:)), for: .touchUpInside)
        let finedustApi = FinedustAPI(location: userLocation.getEencodedUserProvince())
        
        finedustApi.getFinedustData { (finedustData) in
            self.setupUI(finduest: finedustData)            
        }
    }
        
    @objc func refreshFinedustInfo(_ sender : UIButton!) {
        print("logHeader".localized, "미세먼지 정보 재요청...")
        getFinedustInfo()
    }
    
    func getFinedustInfo() {
        let finedustApi = FinedustAPI(location: userLocation.getEencodedUserProvince())
        finedustApi.getFinedustData { (finedustData) in
            print("logHeader".localized, finedustData.location, finedustData.pm10Grade)
            self.setupUI(finduest: finedustData)
        }
    }
    
    func setupUI(finduest : Finedust) {
        view.backgroundColor = .white
        setBackgroundImage()
        finduest.getGradeImage(grade: finduest.pm10Value.getFinedustGradeNumber) { (url) in
            self.indicatorFaceImageView.sd_setImage(with: url)
        }
        self.indicatorLabel.text = finduest.pm10Grade
        self.finedustIndexLabel.text = String(finduest.pm10Value)
        self.finedustGradeLabel.text = finduest.pm10Grade
        self.ultraFinedustIndexLabel.text = String(finduest.pm25Value)
        self.ultraFinedustGradeLabel.text = finduest.pm25Grade
        self.dateTimeLabel.text = finduest.dateTime
        self.LocationNameLabel.text = finduest.location
        self.view.layoutIfNeeded()
        print("[Log] UI셋팅 완료")
    }
    
    func setBackgroundImage() {
        guard let backgroundImage = ad.imageName else { return }
        print("Log FineImage", backgroundImage)
        self.backgroundImageView.image = UIImage(named: backgroundImage)
    }
    
    let currentViewIndicatorCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout()).then {
        let layout = UICollectionViewFlowLayout()
        $0.register(UINib(nibName: "CurrentViewIndicatorCell", bundle: nil),
            forCellWithReuseIdentifier: "CurrentViewIndicatorCell")
        $0.backgroundColor = .none
        layout.minimumLineSpacing = 1
        layout.scrollDirection = .vertical
        layout.itemSize = .init(width: 10, height: 10)
        $0.collectionViewLayout = layout
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

extension FinedustViewController :  UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MainPageViewController().viewContorllerList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CurrentViewIndicatorCell", for: indexPath) as? CurrentViewIndicatorCell else { return UICollectionViewCell() }
        if indexPath.row == 1 {
            let image = UIImage(named: "fillCircle")
            cell.currentViewImage.image = image
        }
        return cell
    }
}
