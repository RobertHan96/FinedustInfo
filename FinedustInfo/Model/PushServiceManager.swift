import Foundation
import FirebaseMessaging
import FirebaseInstanceID
import Alamofire

struct PushServiceManager {
    private let DEVICE_TOKEN = UserDefaults.standard.string(forKey: "token")
    private let pushServerUrl = "http://112.149.126.160:3380/sendToken/"

    func registerTokenToDB(userToken : String) {
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("logHeader".localized, error)
            } else if let result = result{
                setDeviceToken(instantResult: result, token: userToken)
            }
        }
    }

    func setDeviceToken(instantResult : InstanceIDResult, token : String ) {
        if instantResult.token != self.DEVICE_TOKEN  {
                self.postDeviceToken(deviceToken: token)
                UserDefaults.standard.set(instantResult.token, forKey: "token")
        } else {
            print("logHeader".localized, "이미 등록된 토큰")
        }
    }
    
    func postDeviceToken(deviceToken : String) {
        let pushServer = self.pushServerUrl
        let params = ["token": deviceToken]
        AF.request(pushServer, method: .post, parameters: params , encoding:
            URLEncoding(destination : .queryString), headers: ["Content-Type" : "application/json"]).responseJSON {
         response in
         switch response.result {
                         case .success:
                          print("logHeader".localized, response)
                          break

                          case .failure(let error):
                           print("logHeader".localized, error)
              }
         }
    }
}
