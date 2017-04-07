
import UIKit
import Alamofire

//MARK:- Protocols

protocol loginServiceAlamofire {
    func loginResult(_ result:AnyObject)
    func ServerError()
}

protocol RegisterationServiceAlamofire {
    func registerationResult(_ result:AnyObject)
    func ServerError()
}

protocol ForgotPasswordServiceAlamofire {
    func forgotPasswordResult(_ result:AnyObject)
    func ServerError()
}

//MARK:- Class

class AlamofireIntegration: NSObject {
    
    class var sharedInstance : AlamofireIntegration{
        struct Singleton{
            static let instance = AlamofireIntegration()
        }
        return Singleton.instance;
    }
    
    //MARK:- Properties

    var loginServiceDelegate:loginServiceAlamofire?
    var registerationServiceDelegate:RegisterationServiceAlamofire?
    var forgotPasswordServiceDelegate: ForgotPasswordServiceAlamofire?
    var createEventServiceDelegate: CreateEventServiceAlamofire?
    
    //MARK:- Api's Methods

    //Login Api
    func loginApi(_ parameters:[String : String]) {
        print(parameters)
        Alamofire.request("\(baseUrl)login.php", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            switch (response.result) {
            case .success:
                if let json = response.result.value {
                    print(json)
                    self.loginServiceDelegate?.loginResult(json as AnyObject)
                }
                break
            case .failure:
                self.loginServiceDelegate?.ServerError()
                break
            }
        }
    }
    
    //Registeration Api
    func registerationApi(_ parameters:[String : String]) {
        print(parameters)
        Alamofire.request("\(baseUrl)registration.php", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            switch (response.result) {
            case .success:
                if let json = response.result.value {
                    print(json)
                    self.registerationServiceDelegate?.registerationResult(json as AnyObject)
                }
                break
            case .failure:
                self.registerationServiceDelegate?.ServerError()
                break
            }
        }
    }
    
    //Forgot password Api
    func forgotPasswordApi(_ parameters:[String : String]) {
        print(parameters)
        Alamofire.request("\(baseUrl)forgotPassword.php", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            switch (response.result) {
            case .success:
                if let json = response.result.value {
                    print(json)
                    self.forgotPasswordServiceDelegate?.forgotPasswordResult(json as AnyObject)
                }
                break
            case .failure:
                self.forgotPasswordServiceDelegate?.ServerError()
                break
            }
        }
    }

}



