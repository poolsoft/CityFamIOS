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

protocol AddMembersToGroupServiceAlamofire {
    func addMembersToGroupResult(_ result:AnyObject)
    func ServerError()
}

protocol GetMyContactsWithStatusServiceAlamofire {
    func getMyContactsWithStatusApiResult(_ result:AnyObject)
    func ServerError()
}

protocol SendMessageServiceAlamofire {
    func sendmessageApiResult(_ result:AnyObject)
    func ServerError()
}

protocol GetPrivateChatUsersListServiceAlamofire {
    func getPrivateChatUsersListResult(_ result:AnyObject)
    func ServerError()
}

protocol GetPublicOrFriendsChatServiceAlamofire {
    func getPublicOrFriendsChatResult(_ result:AnyObject)
    func ServerError()
}

protocol MessageMarkAsReadApiServiceAlamofire {
    func messageMarkAsReadApiResult(_ result:AnyObject)
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
    var addMembersToGroupServiceDelegate:AddMembersToGroupServiceAlamofire?
    var getMyContactsWithStatusServiceDelegate:GetMyContactsWithStatusServiceAlamofire?
    var messageMarkAsReadApiServiceDelegate:MessageMarkAsReadApiServiceAlamofire?
    var sendMessageServiceDelegate:SendMessageServiceAlamofire?
    var getPublicOrFriendsChatServiceDelgate:GetPublicOrFriendsChatServiceAlamofire?
    var getPrivateChatUsersListServiceDelegate:GetPrivateChatUsersListServiceAlamofire?
    
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
    func getMyGroupsListApi(type:String){
        print("user id ----------",UserDefaults.standard.string(forKey: USER_DEFAULT_userId_Key)!, "type:",type)
        Alamofire.request("\(baseUrl)getMyGroups.php?userId=\(UserDefaults.standard.string(forKey: USER_DEFAULT_userId_Key)!)&type=\(type)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
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
        print("createNewGroupApi ---------",parameters)
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
    
    //Add member to group Api
    func addMemberToGroupApi(parameters: [String:Any]){
        print("parameters", parameters)
        
        Alamofire.request("\(baseUrl)addMembersInGroup.php", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            switch (response.result) {
            case .success:
                if let json = response.result.value {
                    print(json)
                    self.addMembersToGroupServiceDelegate?.addMembersToGroupResult(json as AnyObject)
                }
                break
            case .failure:
                self.addMembersToGroupServiceDelegate?.ServerError()
                break
            }
        }
    }
    
    //getMyContactsWithStatus Api
    func getMyContactsWithStatusApi(parameters: [String:Any]){
        print("parameters", parameters)
        
        Alamofire.request("\(baseUrl)getMyContactsWithStatus.php", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            switch (response.result) {
            case .success:
                if let json = response.result.value {
                    print(json)
                    self.getMyContactsWithStatusServiceDelegate?.getMyContactsWithStatusApiResult(json as AnyObject)
                }
                break
            case .failure:
                self.getMyContactsWithStatusServiceDelegate?.ServerError()
                break
            }
        }
    }
    
    
    ////////////////////////////////////////
    
    //Send Message Api
    func sendMessageApi(parameters: [String:Any]){
        print("parameters", parameters)
        
        Alamofire.request("\(baseUrl)sendMessage.php", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            switch (response.result) {
            case .success:
                if let json = response.result.value {
                    print(json)
                    self.sendMessageServiceDelegate?.sendmessageApiResult(json as AnyObject)
                }
                break
            case .failure:
                self.sendMessageServiceDelegate?.ServerError()
                break
            }
        }
    }
    
    //getPublicOrFriendsChat Api
    func getPublicOrFriendsChatApi(type:String){
        
        Alamofire.request("\(baseUrl)getPublicOrFriendsChat.php?userId=\(UserDefaults.standard.string(forKey: USER_DEFAULT_userId_Key)!)&type=\(type)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            switch (response.result) {
            case .success:
                if let json = response.result.value {
                    print(json)
                    self.getPublicOrFriendsChatServiceDelgate?.getPublicOrFriendsChatResult(json as AnyObject)
                }
                break
            case .failure:
                self.getPublicOrFriendsChatServiceDelgate?.ServerError()
                break
            }
        }
    }
    
    //messageMarkAsRead Api
    func messageMarkAsReadApi(type:String,opponentUserId:String){
        
        Alamofire.request("\(baseUrl)messageMarkAsRead.php?userId=\(UserDefaults.standard.string(forKey: USER_DEFAULT_userId_Key)!)&opponentUserId=\(opponentUserId)&type=\(type)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            switch (response.result) {
            case .success:
                if let json = response.result.value {
                    print(json)
                    self.messageMarkAsReadApiServiceDelegate?.messageMarkAsReadApiResult(json as AnyObject)
                }
                break
            case .failure:
                self.messageMarkAsReadApiServiceDelegate?.ServerError()
                break
            }
        }
    }
    
    //getPrivateChatUsersList Api
    func getPrivateChatUsersListApi(){
        
        Alamofire.request("\(baseUrl)getPrivateChatUsersList.php?userId=\(UserDefaults.standard.string(forKey: USER_DEFAULT_userId_Key)!)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            switch (response.result) {
            case .success:
                if let json = response.result.value {
                    print(json)
                    self.getPrivateChatUsersListServiceDelegate?.getPrivateChatUsersListResult(json as AnyObject)
                }
                break
            case .failure:
                self.getPrivateChatUsersListServiceDelegate?.ServerError()
                break
            }
        }
    }
    
//    {
//    "userId" : "23",
//    "groupId":"89",
//    "opponentUserId" : "34"
//    "message": "hi, how are you ?",
//    "type":"0,1,2"
//    }
//
    
}
