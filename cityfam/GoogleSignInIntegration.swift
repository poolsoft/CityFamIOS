
import UIKit

protocol GoogleSignInService:class{
    func googleSignInData(_ result:NSDictionary)
    func googleSignInError(_ result:String)
}

class GoogleSignInIntegration: NSObject, GIDSignInDelegate, GIDSignInUIDelegate{
    
    weak var delegate:GoogleSignInService?
    
    class var sharedInstance : GoogleSignInIntegration{
        struct Singleton{
            static let instance = GoogleSignInIntegration()
        }
        return Singleton.instance;
    }
    
    func callGoogleSignIn() {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
    }
//    
//    public func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!){
//        
//    }
//    
//    public func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!){
//       
//    }

    
    // MARK: GID sign in delegate
    
    // The sign-in flow has finished and was successful if |error| is |nil|.
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!){
        if (error == nil) {
            // Perform any operations on signed in user here.
            let userId = user.userID   // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            
            let userDataDict = [
                "googleUserId" : userId,
                "token" : idToken,
                "fullName" : fullName,
                "givenName" : givenName,
                "familyName" : familyName,
                "email" : email
            ]
            self.delegate?.googleSignInData(userDataDict as NSDictionary)
            GIDSignIn.sharedInstance().signOut()
        } else {
            let signInError = error.localizedDescription
            self.delegate?.googleSignInError(signInError)
        }
    }
    
    // Finished disconnecting |user| from the app successfully if |error| is |nil|.
    public func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!){
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
}
