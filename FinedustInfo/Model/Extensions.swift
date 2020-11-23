import Foundation
import UIKit
import Alamofire
import SwiftyJSON


extension Float {
    var getDegreeFromKelvin: Float {return (self - 273)}
}

extension String {
    var makeStringKoreanEncoded : String {
        return self.removingPercentEncoding ?? ""
    }
    
    func urlEncodingForString(string:String) -> String{
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }

    func decodeUrl() -> String?{ return String(describing: self.cString(using: String.Encoding.utf8))}
    func encodeUrl() -> String?{ return self.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed) }

    var localized : String {
          return NSLocalizedString(self, tableName: "Localizable", value: self, comment: "")
       }
    var finedustGradeGood : String { return "Good" }
    var finedustGradeModerate : String { return "Moderate" }
    var finedustGradeBad : String { return "Bad" }

}

extension Int {
    func checkFinedustGrade(data : Int) -> Int {
        if data < 16 {
            return 1
        } else if data > 15 || data < 36 {
            return 2
        } else if data > 35 || data < 76 {
            return 3
        } else {
            return 4
        }
    }
    
    var finedustGradeName : String {
        let results : [Int : String] = [
            IndicatorGradeCase.good.rawValue : "finedustGood".localized, IndicatorGradeCase.moderate.rawValue : "finedustModerate".localized,
            IndicatorGradeCase.bad.rawValue : "finedustbad".localized, IndicatorGradeCase.veryBad.rawValue : "finedustVeryBad".localized]
        return  results[self] ?? "finedustGood".localized
    }
    
    var getIndicatorImageUrl : URL {
        let queryUrl = "http://112.149.126.160:3370/\(self)"
        var defaultUrl = URL(string: FinedustInfo.defaultUrl)!
        AF.request(queryUrl).validate(statusCode: 200..<300).responseJSON(completionHandler: { response in
            switch(response.result) {
            case .success(let value) :
                let json = JSON(value)
                let responseURL = URL(string: json["url"].stringValue)
                guard let url = responseURL else { return }
                defaultUrl = url
            case .failure(_) :
                print("[Log] data request is failed, \(response.result)")
            }
        })
        return defaultUrl
    }
    
//    func getIndicatorImageUrl(finedustGrade : Int, completion:@escaping (URL) -> Void){
//        let queryUrl = "http://112.149.126.160:3370/\(finedustGrade)"
//        let urlForError : URL = URL(string : "https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FkIqsC%2FbtqEGT92fDc%2FHdq9Qowhgxvbrn94igvzMK%2Fimg.png")!
//        AF.request(queryUrl).validate(statusCode: 200..<300).responseJSON(completionHandler: { response in
//            switch(response.result) {
//            case .success(let value) :
//                let json = JSON(value)
//                let responseURL = URL(string: json["url"].stringValue)
//                guard let url = responseURL else { return }
//                completion(url)
//            case .failure(_) :
//                print("[Log] data request is failed, \(response.result)")
//                completion(urlForError)
//            }
//        })
//    }
}

extension UIAlertController {
    func okAction() -> UIAlertAction {
        let okAction = UIAlertAction(title: "yesAlertBtnTitle".localized, style: UIAlertAction.Style.default){ (action: UIAlertAction) in
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(NSURL(string:UIApplication.openSettingsURLString)! as URL)
            } else {
                UIApplication.shared.openURL(NSURL(string: UIApplication.openSettingsURLString)! as URL)
            }
        }
        return okAction
    }
    
    func noAction() -> UIAlertAction {
        let noAction = UIAlertAction(title: "noAlertBtnTitle".localized, style: UIAlertAction.Style.destructive){
            (action: UIAlertAction) in
            exit(0)}
        return noAction
    }
    
    func setupAlertActions() {
        self.addAction(okAction())
        self.addAction(noAction())
    }

}



