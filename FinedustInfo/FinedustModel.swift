import Foundation

extension String {
    func makeStringKoreanEncoded(_ string: String) -> String {
        return string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? string
    }
}
struct FinedustInfo {
    var finedustValue : Int
    var finedustGrade : Int
    var ultraFineDuestValue : Int
    var ultraFineDustGrade : Int
    var dateTime : String
    
}
