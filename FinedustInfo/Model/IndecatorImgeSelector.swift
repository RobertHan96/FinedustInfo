import Foundation

struct IndecatorImgeSelector {
    var finedustGrade : Int = 0
    var ultraFinedustGrade : Int = 0

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
        // 하드코딩된 부분 enum혹은 프로퍼티화
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
