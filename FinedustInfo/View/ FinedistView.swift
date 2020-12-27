import UIKit
import SnapKit
import Then

extension FinedustViewController {    
    func setupUI() {
        currentViewIndicatorCollectionView.delegate = self
        currentViewIndicatorCollectionView.dataSource = self
        view.addSubview(currentViewIndicatorCollectionView)
        view.addSubview(backgroundImageView)
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
        view.addSubview(refreshBtn)
    }

    func makeConstraints() {
        backgroundImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top).offset(0)
            make.left.equalTo(self.view.snp.left).offset(-100)
            make.right.equalTo(self.view.snp.right).offset(0)
            make.bottom.equalTo(self.view.snp.bottom).offset(0)
        }
        containerView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top).offset(0)
            make.left.equalTo(self.view.snp.left).offset(0)
            make.right.equalTo(self.view.snp.right).offset(0)
            make.bottom.equalTo(self.view.snp.bottom).offset(0)
        }
        locationImageView.snp.makeConstraints { (make) in
            let height =  UIApplication.shared.statusBarFrame.height + 10
            make.top.equalTo(self.containerView.snp.top).offset(height)
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
            make.top.lessThanOrEqualTo(self.locationImageView.snp.bottom).offset(60)
            make.centerX.equalTo(self.containerView).offset(0)
            make.height.lessThanOrEqualTo(250)
            make.width.lessThanOrEqualTo(250)
        }
        indicatorLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.indicatorFaceImageView).offset(0)
            make.top.equalTo(self.indicatorFaceImageView.snp.bottom).offset(30)
        }
        detailInfoView.snp.makeConstraints { (make) in
            make.top.lessThanOrEqualTo(self.indicatorLabel.snp.bottom).offset(50)
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
            make.top.equalTo(self.detailInfoView.snp.bottom).offset(10)
            make.left.equalTo(self.containerView.snp.left).offset(20)
            make.right.equalTo(self.containerView.snp.right).offset(-20)
        }
        currentViewIndicatorCollectionView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.detailInfoView).offset(0)
            make.bottom.equalTo(self.backgroundImageView.snp.bottom).offset(-10)
            make.top.greaterThanOrEqualTo(self.dateTimeLabel.snp.bottom).offset(0)
            make.height.equalTo(20)
            make.width.equalTo(40)
        }
    }
}
