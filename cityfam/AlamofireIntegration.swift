
import UIKit
import Alamofire

protocol loginServiceAlamofire {
    func loginResult(_ result:AnyObject)
    func loginError()
}


class AlamofireIntegration: NSObject {
    
    class var sharedInstance : AlamofireIntegration{
        struct Singleton{
            static let instance = AlamofireIntegration()
        }
        return Singleton.instance;
    }
    
    var loginServiceDelegate:loginServiceAlamofire?

    
    
//    func login(_ parameters:[String : String]) {
//        print(parameters)
//        Alamofire.request(baseUrl+"", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
//            if response.result.isFailure{
//                self.loginServiceDelegate?.loginError()
//            }
//            else{
//                if let JSON = response.result.value {
//                    print(JSON)
//                    self.loginServiceDelegate?.loginResult(JSON as AnyObject)
//                }
//            }
//        }
//    }
//    
//    


}



