import Foundation
import FirebaseMessaging
import FirebaseInstanceID

class PushServiceManager {
    let userDefaults = UserDefaults.standard
    
    func registerTokenToDB() {
        InstanceID.instanceID().instanceID { (result, error) in
          if let error = error {
            print("Error fetching remote instance ID: \(error)")
          } else if let result = result {
            print("Remote instance ID token: \(result.token)")
            if self.userDefaults.string(forKey: "token") == nil {
                FinedustInfo.postDeviceToken(deviceToken: result.token)
                self.userDefaults.set(result.token, forKey: "token")
            } else {
                print("[Log] : 디바이스 토큰이 이미 등록되어 있습니다.")
            }
          }
        }
    }

}
