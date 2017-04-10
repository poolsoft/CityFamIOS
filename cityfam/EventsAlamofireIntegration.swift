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
    func getEventCategoryResult(_ result:AnyObject)
    func createEventResult(_ result: AnyObject)
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

    //MARK:- Api's Methods
    
    //getEventCategory Api for Create event Screen
    func getEventCategoryApi() {
        Alamofire.request("\(baseUrl)getEventCategories.php?userId=\(UserDefaults.standard.string(forKey: USER_DEFAULT_userId_Key)!)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            switch (response.result) {
            case .success:
                if let json = response.result.value {
                    print(json)
                    self.createEventServiceDelegate?.getEventCategoryResult(json as AnyObject)
                }
                break
            case .failure:
                self.createEventServiceDelegate?.ServerError()
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
}


