import Foundation
import UIKit

extension String {
    func makeStringKoreanEncoded(_ string: String) -> String {
        return string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? string
    }
    
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



