import Foundation

extension String {
    func makeStringKoreanEncoded(_ string: String) -> String {
        return string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? string
    }
    
    var localized: String {
          return NSLocalizedString(self, tableName: "Localizable", value: self, comment: "")

       }
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


