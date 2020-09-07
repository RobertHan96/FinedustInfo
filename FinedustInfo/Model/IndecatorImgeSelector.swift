import Foundation
import Alamofire
import SwiftyJSON
import Kingfisher

struct IndecatorImgeSelector {
    var finedustGrade : Int = 0
    var ultraFinedustGrade : Int = 0
    var imageUrl : URL?

    func getIndicatorImageUrl(finedustGrade : Int, completion:@escaping (Any) -> Void){
        let queryUrl = "http://0.0.0.0:8000/\(finedustGrade)"
        AF.request(queryUrl).validate(statusCode: 200..<300).responseJSON(completionHandler: { response in
            switch(response.result) {
            case .success(let value) :
                completion(response.value)
            case .failure(_) :
                print("[Log] data request is failed, \(response.result)")
                break;
            }
        })
    }

    func setIndicatorImageWithURL(img : UIImageView, url : URL) {
        DispatchQueue.main.async {
            let imageSize =  img.bounds.size
            let processor = DownsamplingImageProcessor(size: imageSize)
                |> RoundCornerImageProcessor(cornerRadius: 100)
            img.kf.indicatorType = .activity
            img.kf.setImage(with: url, options: [ .processor(processor)])
        }
    }

    func setBackgroundImagebyFinedustGrade(grade : String, currentView : MainViewController) {
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
    
    var getImageUrl : String {
        var result = ""
        let urlForGood : String = "http://asq.kr/QWBlyVLUMP4J"
        let urlForModerate : String = "http://asq.kr/IE6fBTA09oG"
        let urlForBad : String = "http://asq.kr/Kk4KMEg2QqMQ"
        let urlForVeryBad : String = "http://asq.kr/Kk4KMEg2QqMQ"
        let urlForError : String = "http://asq.kr/A01iCPQEZB1Y"

        switch self.finedustGrade {
            case 1 :
                result = urlForGood
            case 2 :
                result = urlForModerate
            case 3 :
                result = urlForBad
            case 4 :
                result = urlForVeryBad
            default:
                result = urlForError
        }
        return result
    }

    var getFinedustGradeName : String {
        var result = "finedustGood".localized
        switch self.ultraFinedustGrade {
        case IndicatorGradeCase.moderate.rawValue :
            result = "finedustModerate".localized
        case IndicatorGradeCase.bad.rawValue :
            result = "finedustbad".localized
        case IndicatorGradeCase.veryBad.rawValue :
            result = "finedustVeryBad".localized
        default:
            result = "finedustGood".localized
        }
        return result
    }
    
    static func getFinedustGradeName(data : Int) -> String {
        let results : [Int : String] = [
            IndicatorGradeCase.good.rawValue : "finedustGood".localized, IndicatorGradeCase.moderate.rawValue : "finedustModerate".localized,
            IndicatorGradeCase.bad.rawValue : "finedustbad".localized, IndicatorGradeCase.veryBad.rawValue : "finedustVeryBad".localized]
        return results[data] ?? ""
    }
}

enum IndicatorGradeCase : Int {
    case good = 1
    case moderate = 2
    case bad = 3
    case veryBad = 4
}
