import Foundation
import Alamofire
import SwiftyJSON
import Kingfisher


struct IndecatorImgeSelector {
    var finedustGrade : Int = 0
    var ultraFinedustGrade : Int = 0
    var imageUrl : URL?

    var getUFdustGradeName : String {
        var result = "finedustGood".localized
        switch self.ultraFinedustGrade {
        case IndicatorGradeCase.good.rawValue :
            result = "finedustGood".localized
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
    
    var getFinedustGradeName : String {
        var result = "finedustGood".localized
        switch self.finedustGrade {
        case IndicatorGradeCase.good.rawValue :
            result = "finedustGood".localized
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

    func getFinedustGradeName(data : Int) -> String {
        let results : [Int : String] = [
            IndicatorGradeCase.good.rawValue : "finedustGood".localized, IndicatorGradeCase.moderate.rawValue : "finedustModerate".localized,
            IndicatorGradeCase.bad.rawValue : "finedustbad".localized, IndicatorGradeCase.veryBad.rawValue : "finedustVeryBad".localized]
        return results[data] ?? "finedustGood".localized
    }
        
    func getIndicatorImageUrl(finedustGrade : Int, completion:@escaping (URL) -> Void){
        let queryUrl = "http://0.0.0.0:8000/\(finedustGrade)"
        let urlForError : URL = URL(string : "https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FkIqsC%2FbtqEGT92fDc%2FHdq9Qowhgxvbrn94igvzMK%2Fimg.png")!
        AF.request(queryUrl).validate(statusCode: 200..<300).responseJSON(completionHandler: { response in
            switch(response.result) {
            case .success(let value) :
                let json = JSON(value)
                let responseURL = URL(string: json["url"].stringValue)
                guard let url = responseURL else { return }
                completion(url)
            case .failure(_) :
                print("[Log] data request is failed, \(response.result)")
                completion(urlForError)
            }
        })
    }
}

enum IndicatorGradeCase : Int {
    case good = 1
    case moderate = 2
    case bad = 3
    case veryBad = 4
}
