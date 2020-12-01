import Foundation
import Firebase

struct Finedust {
    var location : String = ""
    var pm10Grade : String = ""
    var pm10Value : Int = 0
    var pm25Grade : String = ""
    var pm25Value : Int = 0
    var dateTime : String = ""
    
    func getGradeImage(grade : Int, completion:@escaping (URL?) -> Void) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imagePath = storageRef.child("/images/\(grade).png")
        imagePath.downloadURL { (url, err) in
            if let error = err {
                debugPrint(imagePath.bucket,"-", error)
            } else {
                completion(url)
            }
        }
    }

}
