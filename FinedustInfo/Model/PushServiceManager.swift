import Foundation
import FirebaseMessaging
import FirebaseInstanceID

class PushServiceManager {
    static let DEVICE_TOKEN = UserDefaults.standard.string(forKey: "token")
    static let pushServerUrl = "http://112.149.126.160:3380/sendToken/"

    static func registerTokenToDB(userToken : String) {
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = result{
                setDeviceToken(instantResult: result, token: userToken)
            }
        }
    }

    static func setDeviceToken(instantResult : InstanceIDResult, token : String ) {
        if instantResult.token != PushServiceManager.DEVICE_TOKEN  {
                FinedustInfo.postDeviceToken(deviceToken: token)
                UserDefaults.standard.set(instantResult.token, forKey: "token")
        } else {
            print("[Log] 이미 등록된 토큰")
        }
    }
}
