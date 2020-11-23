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
}

enum IndicatorGradeCase : Int {
    case good = 1
    case moderate = 2
    case bad = 3
    case veryBad = 4
}
