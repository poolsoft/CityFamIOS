//
//  FriendsAlamofireIntegration.swift
//  cityfam
//
//  Created by i mark on 13/04/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit
import Alamofire

//MARK:- Protocol

protocol RespondToRequestServiceAlamofire {
    func respondToRequestResult(_ result:AnyObject)
    func getFriendsRequestsResult(_ result:AnyObject)
    func getCityFamUsersResult(_ result:AnyObject)
    func ServerError()
}

protocol ManageFriendshipServiceAlamofire {
    func manageFriendshipResult(_ result:AnyObject)
    func ServerError()
}

//MARK:- Properties

class FriendsAlamofireIntegration: NSObject {
    
    class var sharedInstance :FriendsAlamofireIntegration{
        struct Singleton{
            static let instance = FriendsAlamofireIntegration()
        }
        return Singleton.instance
    }
    
    //MARK:- Properties

    var respondToRequestServiceDelegate: RespondToRequestServiceAlamofire?
    var manageFriendshipServiceDelegate:ManageFriendshipServiceAlamofire?
    
    //MARK:- Methods

    //Respond To Friend request Api
    func respondToRequestApi(anotherUserId:String,status:Int) {
        
        print("respondToRequestApi parameter", anotherUserId,status)
        Alamofire.request("\(baseUrl)respondToRequest.php?userId=\(UserDefaults.standard.string(forKey: USER_DEFAULT_userId_Key)!)&anotherUserId=\(anotherUserId)&status=\(status)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            switch (response.result) {
            case .success:
                if let json = response.result.value {
                    print(json)
                    self.respondToRequestServiceDelegate?.respondToRequestResult(json as AnyObject)
                }
                break
            case .failure:
                self.respondToRequestServiceDelegate?.ServerError()
                break
            }
        }
    }
    
    //Manage friendship Api
    func manageFriendshipApi(anotherUserId:String,status:Int) {
        print(anotherUserId,status)
        Alamofire.request("\(baseUrl)manageFriendship.php?userId=\(UserDefaults.standard.string(forKey: USER_DEFAULT_userId_Key)!)&anotherUserId=\(anotherUserId)&status=\(status)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            switch (response.result) {
            case .success:
                if let json = response.result.value {
                    print(json)
                    self.manageFriendshipServiceDelegate?.manageFriendshipResult(json as AnyObject)
                }
                break
            case .failure:
                self.manageFriendshipServiceDelegate?.ServerError()
                break
            }
        }
    }
    
    //Get Friend's request Api
    func getFriendsRequestApi(){
        Alamofire.request("\(baseUrl)getFriendsRequest.php?userId=\(UserDefaults.standard.string(forKey: USER_DEFAULT_userId_Key)!)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            switch (response.result) {
            case .success:
                if let json = response.result.value {
                    print(json)
                    self.respondToRequestServiceDelegate?.getFriendsRequestsResult(json as AnyObject)
                }
                break
            case .failure:
                self.respondToRequestServiceDelegate?.ServerError()
                break
            }
        }
    }
    
    //Get CityFam users List Api
    func getCityFamUsersApi(searchText:String,offset:Int){
        print(searchText,offset)

        print("user id ---------------------",UserDefaults.standard.string(forKey: USER_DEFAULT_userId_Key)!)
        Alamofire.request("\(baseUrl)getCityFamUsersList.php?userId=\(UserDefaults.standard.string(forKey: USER_DEFAULT_userId_Key)!)&searchText=\(searchText)&offset=\(offset)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            switch (response.result) {
            case .success:
                if let json = response.result.value {
                    print(json)
                    self.respondToRequestServiceDelegate?.getCityFamUsersResult(json as AnyObject)
                }
                break
            case .failure:
                self.respondToRequestServiceDelegate?.ServerError()
                break
            }
        }
    }
}
