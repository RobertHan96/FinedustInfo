import Foundation
import UIKit
import Alamofire
import SwiftyJSON

extension Float {
    var getDegreeFromKelvin: Float {return (self - 273)}
}

extension String {
    var localized : String {
          return NSLocalizedString(self, tableName: "Localizable", value: self, comment: "")
       }
    var finedustGradeGood : String { return "Good" }
    var finedustGradeModerate : String { return "Moderate" }
    var finedustGradeBad : String { return "Bad" }
    var makeStringKoreanEncoded : String {
        return self.removingPercentEncoding ?? ""
    }
    
    func urlEncodingForString(string:String) -> String{
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }

}

extension Int {
    var getFinedustGradeNumber : Int {
        if self < 16 {
            return 1
        } else if self > 15 || self < 36 {
            return 2
        } else if self > 35 || self < 76 {
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



