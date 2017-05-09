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

protocol GetMyFriendsListServiceAlamofire{
    func getMyFriendsListResult(_ result:AnyObject)
    func ServerError()
}

protocol MyGroupsVcServiceAlamofire {
    func getMyGroupsListResult(_ result:AnyObject)
    func createNewGroupResult(_ result:AnyObject)
    func deleteGroupApiResult(_ result: AnyObject)
    func ServerError()
}

protocol GroupDetailVcServiceAlamofire {
    func getMembersOfGroupResult(_ result:AnyObject)
    func deleteMemberOfGroupResult(_ result:AnyObject)
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
    var getMyFriendsListServiceDelegate:GetMyFriendsListServiceAlamofire?
    var myGroupsVcServiceDelegate:MyGroupsVcServiceAlamofire?
    var groupDetailVcServiceDelegate:GroupDetailVcServiceAlamofire?
    
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
    
    //Get MyFriends List Api
    func getMyFriendsListApi(){
        print("user id ---------------------",UserDefaults.standard.string(forKey: USER_DEFAULT_userId_Key)!)
        Alamofire.request("\(baseUrl)getMyFriendsList.php?userId=\(UserDefaults.standard.string(forKey: USER_DEFAULT_userId_Key)!)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            switch (response.result) {
            case .success:
                if let json = response.result.value {
                    print(json)
                    self.getMyFriendsListServiceDelegate?.getMyFriendsListResult(json as AnyObject)
                }
                break
            case .failure:
                self.getMyFriendsListServiceDelegate?.ServerError()
                break
            }
        }
    }
    
    //Get My groups List Api
    func getMyGroupsListApi(){
        print("user id ---------------------",UserDefaults.standard.string(forKey: USER_DEFAULT_userId_Key)!)
        Alamofire.request("\(baseUrl)getMyGroups.php?userId=\(UserDefaults.standard.string(forKey: USER_DEFAULT_userId_Key)!)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            switch (response.result) {
            case .success:
                if let json = response.result.value {
                    print(json)
                    self.myGroupsVcServiceDelegate?.getMyGroupsListResult(json as AnyObject)
                }
                break
            case .failure:
                self.myGroupsVcServiceDelegate?.ServerError()
                break
            }
        }
    }
    
    //Create new group Api
    func createNewGroupApi(parameters:[String:Any]){
        print("createNewGroupApi user id ---------",UserDefaults.standard.string(forKey: USER_DEFAULT_userId_Key)!)
        Alamofire.request("\(baseUrl)createGroup.php", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            switch (response.result) {
            case .success:
                if let json = response.result.value {
                    print(json)
                    self.myGroupsVcServiceDelegate?.createNewGroupResult(json as AnyObject)
                }
                break
            case .failure:
                self.myGroupsVcServiceDelegate?.ServerError()
                break
            }
        }
    }
    
    //Get Members Of group Api
    func getMembersOfGroupApi(groupId: String){
        print("user id ---------------------",UserDefaults.standard.string(forKey: USER_DEFAULT_userId_Key)!)
        
        Alamofire.request("\(baseUrl)getMembersOfGroup.php?userId=\(UserDefaults.standard.string(forKey: USER_DEFAULT_userId_Key)!)&groupId=\(groupId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            switch (response.result) {
            case .success:
                if let json = response.result.value {
                    print(json)
                    self.groupDetailVcServiceDelegate?.getMembersOfGroupResult(json as AnyObject)
                }
                break
            case .failure:
                self.groupDetailVcServiceDelegate?.ServerError()
                break
            }
        }
    }

    //Get Members Of group Api
    func deleteMemberOfGroupApi(groupId: String,emailId: String){
        print("user id ---------------------",UserDefaults.standard.string(forKey: USER_DEFAULT_userId_Key)!)
        
        Alamofire.request("\(baseUrl)deleteMemberFromGroup.php?userId=\(UserDefaults.standard.string(forKey: USER_DEFAULT_userId_Key)!)&groupId=\(groupId)&emailId=\(emailId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            switch (response.result) {
            case .success:
                if let json = response.result.value {
                    print(json)
                    self.groupDetailVcServiceDelegate?.deleteMemberOfGroupResult(json as AnyObject)
                }
                break
            case .failure:
                self.groupDetailVcServiceDelegate?.ServerError()
                break
            }
        }
    }

    //Delete group Api
    func deleteGroupApi(groupId: String){
        print("user id ---------------------",UserDefaults.standard.string(forKey: USER_DEFAULT_userId_Key)!)
        
        Alamofire.request("\(baseUrl)deleteGroup.php?userId=\(UserDefaults.standard.string(forKey: USER_DEFAULT_userId_Key)!)&groupId=\(groupId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            switch (response.result) {
            case .success:
                if let json = response.result.value {
                    print(json)
                    self.myGroupsVcServiceDelegate?.deleteGroupApiResult(json as AnyObject)
                }
                break
            case .failure:
                self.myGroupsVcServiceDelegate?.ServerError()
                break
            }
        }
    }
    
}
