import Foundation

struct IndecatorImgeSelector {
    var finedustGrade : Int = 0
    var ultraFinedustGrade : Int = 0
    var getFinedustGradeName : String {
        var result = "good"
        switch self.finedustGrade {
        case 2 :
            result = "moderate"
        case 3, 4 :
            result = "bad"
        default:
            result = "good"
        }
        return result
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

    var getUltraFinedustGradeName : String {
        var result = "good"
        switch self.ultraFinedustGrade {
        case 2 :
            result = "moderate"
        case 3, 4 :
            result = "bad"
        default:
            result = "good"
        }
        return result
    }

    // 함수 내용, 프로퍼티로 대체
    static func setIndicatorImageName(data : Int) -> String {
        let results : [Int : String] = [1:"good", 2:"moderate", 3:"bad", 4:"bad"]
        return results[data] ?? results[1]!
    }
    
    // 로컬라이즈드가 왜 필요한지 분석한 뒤, 필요 없다면 프로퍼티 하나로 대체
    static func getFinedustGradeName(data : Int) -> String {
        // 하드코딩된 부분 enum혹은 프로퍼티화
        let results : [Int : String] = [
            1:"finedustGood".localized, 2:"finedustModerate".localized,
            3:"finedustbad".localized, 4:"finedustVeryBad".localized]
        return results[data] ?? "알 수 없음"
    }
}
