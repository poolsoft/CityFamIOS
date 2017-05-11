//
//  EventsAlamofireIntegration.swift
//  cityfam
//
//  Created by i mark on 07/04/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit
import Alamofire

//MARK:- Protocols

protocol CreateEventServiceAlamofire {
    func createEventResult(_ result: AnyObject)
    func ServerError()
}

protocol GetEventCategoryServiceAlamofire {
    func getEventCategoryResult(_ result:AnyObject)
    func ServerError()
}

protocol GetEventsListOfParticularUserServiceAlamofire {
    func getEventsListOfParticularUserResult(_ result:AnyObject)
    func ServerError()
}

protocol GetEventsListServiceAlamofire {
    func getEventsListResult(_ result:AnyObject)
    func ServerError()
}

protocol ChangeStatusOfEventServiceAlamofire {
    func changeStatusOfEventResult(_ result:AnyObject)
    func ServerError()
}

protocol GetListOfPeopleAttendingTheEventServiceAlamofire {
    func getListOfPeopleAttendingTheEventResult(_ result:AnyObject)
    func ServerError()
}

protocol GetListOfPeopleInvitedToTheEventServiceAlamofire {
    func getListOfPeopleInvitedToTheEventResult(_ result:AnyObject)
    func ServerError()
}

protocol GetListOfPeopleInterestedInEventServiceAlamofire {
    func getListOfPeopleInterestedInEventResult(_ result:AnyObject)
    func ServerError()
}

protocol EventsInvitationsServiceAlamofire{
    func getInvitationsListResult(_ result:AnyObject)
    func ServerError()
}

protocol GetUserPlansServiceAlamofire{
    func getUserPlansResult(_ result:AnyObject)
    func ServerError()
}

protocol CommentsVcServiceAlamofire{
    func getCommentsApiResult(_ result:AnyObject)
    func addCommentApiResult(_ result:AnyObject)
    func ServerError()
}

//MARK:- Class

class EventsAlamofireIntegration: NSObject {

    class var sharedInstance : EventsAlamofireIntegration{
        struct Singleton{
            static let instance = EventsAlamofireIntegration()
        }
        return Singleton.instance;
    }
    
    //MARK:- Properties
    
    var createEventServiceDelegate: CreateEventServiceAlamofire?
    var getEventsListOfParticularUserServiceDelegate:GetEventsListOfParticularUserServiceAlamofire?
    var getEventsListServiceDelegate:GetEventsListServiceAlamofire?
    var getListOfPeopleAttendingTheEventServiceDelgate:GetListOfPeopleAttendingTheEventServiceAlamofire?
    var getListOfPeopleInvitedToTheEventServiceDelegate:GetListOfPeopleInvitedToTheEventServiceAlamofire?
    var getListOfPeopleInterestedInEventServiceDelegate:GetListOfPeopleInterestedInEventServiceAlamofire?
    var eventsInvitationsServiceDelegate:EventsInvitationsServiceAlamofire?
    var changeStatusOfEventServiceDelegate:ChangeStatusOfEventServiceAlamofire?
    var getUserPlansServiceDelegate:GetUserPlansServiceAlamofire?
    var commentsVcServiceDelegate:CommentsVcServiceAlamofire?
    var getEventCategoryServiceDelegate:GetEventCategoryServiceAlamofire?
    
    //MARK:- Api's Methods
    
    //getEventCategory Api for Create event Screen
    func getEventCategoryApi() {
        Alamofire.request("\(baseUrl)getEventCategories.php?userId=\(UserDefaults.standard.string(forKey: USER_DEFAULT_userId_Key)!)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            switch (response.result) {
            case .success:
                if let json = response.result.value {
                    print(json)
                    self.getEventCategoryServiceDelegate?.getEventCategoryResult(json as AnyObject)
                }
                break
            case .failure:
                self.getEventCategoryServiceDelegate?.ServerError()
                break
            }
        }
    }
    
    //CreateEvent Api
    func createEventApi(_ parameters:[String : Any]) {
        print(parameters)
        Alamofire.request("\(baseUrl)createEvent.php", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { response in

            switch (response.result) {
            case .success:
                if let json = response.result.value {
                    print(json)
                    self.createEventServiceDelegate?.createEventResult(json as AnyObject)
                }
                break
            case .failure:
                self.createEventServiceDelegate?.ServerError()
                break
            }
        }
    }
    
    //Get Evnets list of of particular user on Other user's profile screen
    func getEventsListOfParticularUserApi(parameter: String){
        print(parameter)
        Alamofire.request("\(baseUrl)getEventsListOfParticularUser.php?userId=\(UserDefaults.standard.string(forKey: USER_DEFAULT_userId_Key)!)&anotherUserId=\(parameter)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            switch(response.result){
            case .success:
                if let json = response.result.value{
                    print(json)
                    self.getEventsListOfParticularUserServiceDelegate?.getEventsListOfParticularUserResult(json as AnyObject)
                }
                break
            case .failure:
                self.getEventsListOfParticularUserServiceDelegate?.ServerError()
                break
            }
        }
    }
    
    //Get events list for Home page according to filters or without filters
    func getEventsListApi(_ parameters:[String : Any]){
        print(parameters)
        Alamofire.request("\(baseUrl)getEventsList.php", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            switch(response.result){
            case .success:
                if let json = response.result.value{
                    print(json)
                    self.getEventsListServiceDelegate?.getEventsListResult(json as AnyObject)
                }
                break
            case .failure:
                self.getEventsListServiceDelegate?.ServerError()
                break
            }
        }
    }
    
    //getListOfPeopleInterestedInEvent Api
    func getListOfPeopleInterestedInEventApi(eventId:String){
        print(eventId)
        Alamofire.request("\(baseUrl)getListOfPeopleInterestedInEvent.php?userId=\(UserDefaults.standard.string(forKey: USER_DEFAULT_userId_Key)!)&eventId=\(eventId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            switch(response.result){
            case .success:
                if let json = response.result.value{
                    print(json)
                    self.getListOfPeopleInterestedInEventServiceDelegate?.getListOfPeopleInterestedInEventResult(json as AnyObject)
                }
                break
            case .failure:
                self.getListOfPeopleInterestedInEventServiceDelegate?.ServerError()
                break
            }
        }
    }
    
    //getListOfPeopleInvitedToTheEvent Api
    func getListOfPeopleInvitedToTheEventApi(eventId:String){
        print(eventId)
        Alamofire.request("\(baseUrl)getListOfPeopleInvitedToTheEvent.php?userId=\(UserDefaults.standard.string(forKey: USER_DEFAULT_userId_Key)!)&eventId=\(eventId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            switch(response.result){
            case .success:
                if let json = response.result.value{
                    print(json)
                    self.getListOfPeopleInvitedToTheEventServiceDelegate?.getListOfPeopleInvitedToTheEventResult(json as AnyObject)
                }
                break
            case .failure:
                self.getListOfPeopleInvitedToTheEventServiceDelegate?.ServerError()
                break
            }
        }
    }
    
    //getListOfPeopleAttendingTheEvent Api
    func getListOfPeopleAttendingTheEventApi(eventId:String){
        print(eventId)
        Alamofire.request("\(baseUrl)getListOfPeopleAttendingTheEvent.php?userId=\(UserDefaults.standard.string(forKey: USER_DEFAULT_userId_Key)!)&eventId=\(eventId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            switch(response.result){
            case .success:
                if let json = response.result.value{
                    print(json)
                    self.getListOfPeopleAttendingTheEventServiceDelgate?.getListOfPeopleAttendingTheEventResult(json as AnyObject)
                }
                break
            case .failure:
                self.getListOfPeopleAttendingTheEventServiceDelgate?.ServerError()
                break
            }
        }
    }
    
    //Get Events Invitations List Api
    func getInvitationsListApi(eventId:String){
        print(eventId)
        Alamofire.request("\(baseUrl)getInvitationsList.php?userId=\(UserDefaults.standard.string(forKey: USER_DEFAULT_userId_Key)!)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            switch(response.result){
            case .success:
                if let json = response.result.value{
                    print(json)
                    self.eventsInvitationsServiceDelegate?.getInvitationsListResult(json as AnyObject)
                }
                break
            case .failure:
                self.eventsInvitationsServiceDelegate?.ServerError()
                break
            }
        }
    }
    
    //Update event status Api
    func changeStatusOfEventApi(eventId:String, status:String){
        print("change status Api------------",eventId,"status",status,"userId",UserDefaults.standard.string(forKey: USER_DEFAULT_userId_Key)!)
        
        Alamofire.request("\(baseUrl)changeStatusForEvent.php?userId=\(UserDefaults.standard.string(forKey: USER_DEFAULT_userId_Key)!)&eventId=\(eventId)&status=\(status)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            switch(response.result){
            case .success:
                if let json = response.result.value{
                    print(json)
                    self.changeStatusOfEventServiceDelegate?.changeStatusOfEventResult(json as AnyObject)
                }
                break
            case .failure:
                self.changeStatusOfEventServiceDelegate?.ServerError()
                break
            }
        }
    }
    
    //get User Plans Api
    func getUserPlansListApi(anotherUserId:String, status:Int){
        print("getUserPlansList------------",anotherUserId,"status",status,"userId",UserDefaults.standard.string(forKey: USER_DEFAULT_userId_Key)!)
        
        Alamofire.request("\(baseUrl)getUserPlans.php?userId=\(UserDefaults.standard.string(forKey: USER_DEFAULT_userId_Key)!)&anotherUserId=\(anotherUserId)&status=\(status)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            switch(response.result){
            case .success:
                if let json = response.result.value{
                    print(json)
                    self.getUserPlansServiceDelegate?.getUserPlansResult(json as AnyObject)
                }
                break
            case .failure:
                self.getUserPlansServiceDelegate?.ServerError()
                break
            }
        }
    }
    
    //Get Comments List Api
    func getCommentsListApi(eventId:String){
        print("getCommentsListApi------------",eventId,"eventId","userId",UserDefaults.standard.string(forKey: USER_DEFAULT_userId_Key)!)
        
        Alamofire.request("\(baseUrl)getListOfCommentsOfEvent.php?userId=\(UserDefaults.standard.string(forKey: USER_DEFAULT_userId_Key)!)&eventId=\(eventId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            switch(response.result){
            case .success:
                if let json = response.result.value{
                    print(json)
                    self.commentsVcServiceDelegate?.getCommentsApiResult(json as AnyObject)
                }
                break
            case .failure:
                self.commentsVcServiceDelegate?.ServerError()
                break
            }
        }
    }
    
    //Add comment Api
    func addCommentApi(parameters: [String:Any]){
        print("parameteres",parameters)
        
        Alamofire.request("\(baseUrl)addComment.php", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            switch(response.result){
            case .success:
                if let json = response.result.value{
                    print(json)
                    self.commentsVcServiceDelegate?.addCommentApiResult(json as AnyObject)
                }
                break
            case .failure:
                self.commentsVcServiceDelegate?.ServerError()
                break
            }
        }
    }

}


