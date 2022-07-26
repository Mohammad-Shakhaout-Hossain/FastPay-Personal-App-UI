//
//  UserSettings.swift
//  Fastpay
//
//  Created by Anamul Habib on 5/27/20.
//  Copyright © 2020 Fastpay. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class UserSettings{
	
	static let shared = UserSettings()
	private init(){
		sessionId = UUID().uuidString
	}
	
	let sessionId: String
	
	//TODO: Need to store api token in keychain
	var apiToken: String?{
		get{
			return UserDefaults.standard.string(forKey: K.UserDefaultsKey.APITokenKey)
		}set(apiToken){
			guard let apiToken = apiToken else {
				UserDefaults.standard.removeObject(forKey: K.UserDefaultsKey.APITokenKey)
				UserDefaults.standard.synchronize()
				return
			}
			
			UserDefaults.standard.set(apiToken, forKey: K.UserDefaultsKey.APITokenKey)
			UserDefaults.standard.synchronize()
		}
	}
	
	var isLoggedIn: Bool = false
	
//	var biometricAuthType: BiometricAuthType?{
//		get{
//			return BiometricAuthType.init(id: UserDefaults.standard.integer(forKey: K.UserDefaultsKey.BiometricAuthTypeId))
//		}set(biometricAuthType){
//			guard let biometricAuthType = biometricAuthType else {
//				UserDefaults.standard.removeObject(forKey: K.UserDefaultsKey.BiometricAuthTypeId)
//				UserDefaults.standard.synchronize()
//				return
//			}
//
//			UserDefaults.standard.set(biometricAuthType.id, forKey: K.UserDefaultsKey.BiometricAuthTypeId)
//			UserDefaults.standard.synchronize()
//		}
//	}
	
	var userBasicInfo: BasicUserInfoData?
//	var countryData: CountryData?
//	var cityDataOfBaseCountry: CityData?
	var userLocation: CLLocation?
	
	var userMobileNo: String?{
		get{
			return UserDefaults.standard.string(forKey: K.UserDefaultsKey.UserMobileNo)
		}set(userMobileNo){
			guard let userMobileNo = userMobileNo else {
				UserDefaults.standard.removeObject(forKey: K.UserDefaultsKey.UserMobileNo)
				UserDefaults.standard.synchronize()
				return
			}
			
			UserDefaults.standard.set(userMobileNo, forKey: K.UserDefaultsKey.UserMobileNo)
			UserDefaults.standard.synchronize()
		}
	}
	
	//TODO: Need to store password in keychain
	/*var userPassword: String?{
		get{
			return UserDefaults.standard.string(forKey: K.UserDefaultsKey.UserPassword)
		}set(userPassword){
			guard let userPassword = userPassword else {
				UserDefaults.standard.removeObject(forKey: K.UserDefaultsKey.UserPassword)
				UserDefaults.standard.synchronize()
				return
			}
			
			UserDefaults.standard.set(userPassword, forKey: K.UserDefaultsKey.UserPassword)
			UserDefaults.standard.synchronize()
		}
	}*/
	
	
	var mainNav: UINavigationController?
	
	var kcTabBar: KCTabBarController?
	
	var fcmToken: String?{
		get{
			return UserDefaults.standard.string(forKey: K.UserDefaultsKey.FCMToken)
		}set(fcmToken){
			guard let fcmToken = fcmToken else {
				UserDefaults.standard.removeObject(forKey: K.UserDefaultsKey.FCMToken)
				UserDefaults.standard.synchronize()
				return
			}
			
			if fcmToken != self.fcmToken{
				sendFCMTokenToServer(fcmToken)
			}
			
			UserDefaults.standard.set(fcmToken, forKey: K.UserDefaultsKey.FCMToken)
			UserDefaults.standard.synchronize()
		}
	}
    var isUserRemembered: Bool?{
        get{
            return UserDefaults.standard.bool(forKey: K.UserDefaultsKey.RememberUserKey)
        }set(isUserRemembered){
            guard let isUserRemembered = isUserRemembered else {
                UserDefaults.standard.removeObject(forKey: K.UserDefaultsKey.RememberUserKey)
                UserDefaults.standard.synchronize()
                return
            }
            
            UserDefaults.standard.set(isUserRemembered, forKey: K.UserDefaultsKey.RememberUserKey)
            UserDefaults.standard.synchronize()
        }
    }
	
	var firebaseTopics: [String?]?
	
	var notificationCount: NSNumber? = NSNumber.init(value: -1)
	
    func invalidateSession(){
        WebServiceHandler.shared.accessToken = nil
        WebServiceHandler.shared.refreshToken = nil
        mainNav = nil
        fcmToken = nil
        //userMobileNo = nil
        //userPassword = nil
    }
	
	func logout(){
		invalidateSession()
		//(UIApplication.shared.delegate as? AppDelegate)?.loadLoginScene()
	}
	
	func softLogout(){
		(UIApplication.shared.delegate as? AppDelegate)?.loadLoginScene()
	}
	
	private func sendFCMTokenToServer(_ token: String){
//		if apiToken != nil{
//			WebServiceHandler.shared.updateFCMToken(token, onCompletion: { ( _,  _) in
//			}, onFailure: { ( _) in
//			}, shouldShowLoader: false)
//		}
	}
	
}

