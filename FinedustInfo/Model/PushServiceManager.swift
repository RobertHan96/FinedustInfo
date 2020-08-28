import Foundation
import FirebaseMessaging
import FirebaseInstanceID

class PushServiceManager {
    static let DEVICE_TOKEN = UserDefaults.standard.string(forKey: "token")
    static let pushServerUrl = "http://13.124.81.229:8000/sendToken/"

    
    static func registerTokenToDB(userToken : String) {
        InstanceID.instanceID().instanceID { (result, error) in
          if let error = error {
            print("Error fetching remote instance ID: \(error)")
          } else if let result = result{
            if result.token != DEVICE_TOKEN  {
                FinedustInfo.postDeviceToken(deviceToken: userToken)
                UserDefaults.standard.set(result.token, forKey: "token")
            } else {
                print("[Log] 이미 등록된 토큰")
            }
        }
        
        }
    }
    
}
