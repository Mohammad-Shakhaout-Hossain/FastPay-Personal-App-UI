//
//  Util.swift
//  Fastpay
//
//  Created by Anamul Habib on 5/27/20.
//  Copyright © 2020 Fastpay. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration
import Kingfisher

class Util{
	
	private init(){}
	
	static func heightConforming16By9Ratio(forWidth width: CGFloat) -> CGFloat{
		return width * (9/16)
	}
	
	static func widthConforming16By9Ratio(forHeight height: CGFloat) -> CGFloat{
		return height * (16/9)
	}
	
	
	static func getFormattedDateString(inputDateString: String, inputDateFormat: String, outputDateFormat: String) -> String?{
		let dateFormatterInput = DateFormatter()
		dateFormatterInput.dateFormat = inputDateFormat//"yyyy-MM-dd HH:mm:ss"
		
		let dateFormatterOutput = DateFormatter()
		dateFormatterOutput.dateFormat = outputDateFormat//"EEEE, MMM dd hh:mm a"
		
		if let date = dateFormatterInput.date(from: inputDateString) {
			return (dateFormatterOutput.string(from: date))
		} else {
			return nil
		}
	}
	
	static func showDialogOnKeyWindow(title: String, message: String, style: UIAlertController.Style = .alert, onOkTap: (()->())?){
		let alert = UIAlertController(title: title , message: message, preferredStyle: style)
		alert.addAction(UIAlertAction(title: "app_common_ok"~, style: .default, handler: { action in
			if let onOkayTap = onOkTap{
				onOkayTap()
			}
		}))
		
		alert.view.tintColor = K.UI.PrimaryTintColor
		
		if let mainNav = UserSettings.shared.mainNav{
			mainNav.present(alert, animated: true, completion: nil)
		}else{
			if let presentedViewController = UIApplication.shared.keyWindow?.rootViewController?.presentedViewController{
				presentedViewController.present(alert, animated: true, completion: nil)
			}else{
				UIApplication.shared.keyWindow?.rootViewController?.presentedViewController?.present(alert, animated: true, completion: nil)
			}
		}
	}
	
	
	static func showDialog(title: String, message: String, onOkTap: (()->())?){
		let alert = UIAlertController(title: title , message: message, preferredStyle: UIAlertController.Style.alert)
		alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
			if let onOkayTap = onOkTap{
				onOkayTap()
			}
		}))
		
		alert.view.tintColor = K.UI.PrimaryTintColor
		UserSettings.shared.mainNav?.present(alert, animated: true, completion: nil)
	}
	
	class func getDateGiveDayMonthYear(dateString: String)->(year: String, month: String,day: String){
		
		var year   = ""
		var month  = ""
		var day    = ""
		
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd"
		guard let date = formatter.date(from: dateString) else {
			return (year,month,day)
		}
		
		formatter.dateFormat = "yyyy"
		year = formatter.string(from: date)
		formatter.dateFormat = "MM"
		month = formatter.string(from: date)
		formatter.dateFormat = "dd"
		day = formatter.string(from: date)
		print(year, month, day) // 2018 12 24
		
		return (year,month,day)
		
	}
	
	class func getDateAndTimeFromDate(dateString: String)->(date: String, time: String){
		
		var dateStr  = ""
		var timeStr  = ""
		
		
		let formatter = DateFormatter()
		formatter.locale = Locale(identifier: "en_US_POSIX")
		formatter.dateFormat = "dd MMMM yyyy HH:mm a"
		guard let date = formatter.date(from: dateString) else {
			return (dateStr,timeStr)
		}
		formatter.amSymbol = "AM"
		formatter.pmSymbol = "PM"
		
		formatter.dateFormat = "dd MMMM yyyy"
		dateStr = formatter.string(from: date)
		formatter.dateFormat = "HH:mm a"
		timeStr = formatter.string(from: date)
		
		
		return (dateStr,timeStr)
		
	}
    
    class func getDateFromString(dateString: String, formate: String)->Date{
        

        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = formate
        
//        if let date = dateFormatter.date(from:dateString){
//            return date
//        }
//        return nil
        return dateFormatter.date(from:dateString) ?? Date()
    }
	
	static func beautifyMobileNumber(_ number: String) -> String{
		
		var number = number
		
		if number.hasPrefix(K.Misc.CountryCode){
			number = number.replacingOccurrences(of: K.Misc.CountryCode, with: "")
		}
		
		if number.count != 10{
			return number
		}
		
		return String(format: "%@ %@ %@", String(number[number.startIndex..<number.index(number.startIndex, offsetBy: 3)]),
					  String(number[number.index(number.startIndex, offsetBy: 3)..<number.index(number.startIndex, offsetBy: 6)]),
					  String(number[number.index(number.startIndex, offsetBy: 6)..<number.index(number.startIndex, offsetBy: 10)]))
	}
	
	static func compresseImage(_ originalImage: UIImage) -> Data?{
		
		let desiredSize = K.Misc.desiredImageSizeInBytes
		let originalSize = originalImage.jpegData(compressionQuality: 1.0)?.count ?? 0
		
		print("original size: \(originalSize)")
		
		//		let bcf = ByteCountFormatter()
		//		bcf.allowedUnits = [.useMB]
		//		bcf.countStyle = .file
		//		let string = bcf.string(fromByteCount: Int64(originalSize))
		//		print("original size in MB: \(string)")
		
		if originalSize <= desiredSize{
			return originalImage.jpegData(compressionQuality: 1.0)
		}
		
		let compressionQuality = ((100/originalSize) * desiredSize)/100
		
		let compressedData = originalImage.jpegData(compressionQuality: CGFloat(compressionQuality))
		
		print("compressed size: \(compressedData?.count ?? 0)")
		
		return compressedData
		
	}
	
	
	static func getVisibleViewController(_ rootViewController: UIViewController?) -> UIViewController? {
		var rootVC = rootViewController
		if rootVC == nil {
			rootVC = UIApplication.shared.keyWindow?.rootViewController
		}
		
		if rootVC?.presentedViewController == nil {
			return rootVC
		}
		
		if rootVC?.presentedViewController != nil {
			if (rootVC?.presentedViewController is UINavigationController) {
				let navigationController = rootVC?.presentedViewController as? UINavigationController
				return navigationController?.viewControllers.last
			}
			return getVisibleViewController(rootVC?.presentedViewController)
		}
		return nil
	}
	
	static func formattedAmountString(amountString: String?) -> String?{
		
		if let amount = amountString, let amountInt = Int(amount){
			
			let numberFormatter = NumberFormatter()
			numberFormatter.numberStyle = .decimal
			numberFormatter.locale = Locale(identifier: "en_US")
			numberFormatter.groupingSeparator = ","
			numberFormatter.decimalSeparator = "."
			
			return numberFormatter.string(from: NSNumber(value: amountInt))
		}
		
		return nil
	}
	
	static func playWithAmount(textField: UITextField, string: String){
		
		if let selectedRange = textField.selectedTextRange {

			let cursorPosition = textField.offset(from: textField.beginningOfDocument, to: selectedRange.start)
			var typedText = textField.text()
			typedText.insert(contentsOf: string, at: typedText.index(typedText.startIndex, offsetBy: cursorPosition))

			print("\(cursorPosition)")
			
			if let formattedAmount = Util.formattedAmountString(amountString: typedText.filter("0123456789.".contains)){
				
				textField.text = formattedAmount + " IQD"
				if let selectedRange = textField.selectedTextRange {
					if let newPosition = textField.position(from: selectedRange.start, offset: -" IQD".count) {
						textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
					}
				}
			}
			
		}
	}
	
	static func isConnectedToNetwork() -> Bool {
		
		var zeroAddress = sockaddr_in()
		zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
		zeroAddress.sin_family = sa_family_t(AF_INET)
		guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
			
			$0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
				
				SCNetworkReachabilityCreateWithAddress(nil, $0)
				
			}
			
		}) else {
			
			return false
		}
		var flags = SCNetworkReachabilityFlags()
		if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
			return false
		}
		let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
		let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
		return (isReachable && !needsConnection)
	}
	
}


extension UIImageView{
	
	func setImageFromURl(imageUrl: String){
		
		self.image = nil
		
		let url = URL(string: imageUrl)
		self.kf.indicatorType = .activity
		self.kf.setImage(
			with: url,
			//placeholder: UIImage(named: "placeholder_image"),
			options: [
				.transition(.fade(1)),
				.cacheOriginalImage
            ], completionHandler:
                {
                    result in
                    switch result {
                    case .success(let value):
                        print("image loading done for: \(value.source.url?.absoluteString ?? "")")
                    case .failure(let error):
                        print("image loading failed for: \(error.localizedDescription) for: \(imageUrl) and as url: \(url?.absoluteString ?? "")")
                    }
                })
	}
    
//    func setImageFromURl4Art(imageUrl: String){
//
//        self.image = nil
//        let url = URL(string: imageUrl)
//        let data = try? Data(contentsOf: url!)
//        self.image = UIImage(data: data!)
//
//    }
}


extension String{
	
	func isValidString() -> Bool{
		if (self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty){
			return false
		}else{
			return true
		}
	}
	
	func isValidEmail() -> Bool {
		let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
		
		let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
		return emailPred.evaluate(with: self)
	}
}

//extension Optional where Wrapped == String {
//
//    func isValidString() -> Bool{
//        return self?.isValidString() ?? false
//    }
//
//    func isValidEmail() -> Bool {
//        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
//
//        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
//        return emailPred.evaluate(with: self)
//    }
//}


extension UIDevice {
	
	static let modelName: String = {
		var systemInfo = utsname()
		uname(&systemInfo)
		let machineMirror = Mirror(reflecting: systemInfo.machine)
		let identifier = machineMirror.children.reduce("") { identifier, element in
			guard let value = element.value as? Int8, value != 0 else { return identifier }
			return identifier + String(UnicodeScalar(UInt8(value)))
		}
		
		func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
			#if os(iOS)
			switch identifier {
			case "iPod5,1":                                 return "iPod touch (5th generation)"
			case "iPod7,1":                                 return "iPod touch (6th generation)"
			case "iPod9,1":                                 return "iPod touch (7th generation)"
			case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
			case "iPhone4,1":                               return "iPhone 4s"
			case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
			case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
			case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
			case "iPhone7,2":                               return "iPhone 6"
			case "iPhone7,1":                               return "iPhone 6 Plus"
			case "iPhone8,1":                               return "iPhone 6s"
			case "iPhone8,2":                               return "iPhone 6s Plus"
			case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
			case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
			case "iPhone8,4":                               return "iPhone SE"
			case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
			case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
			case "iPhone10,3", "iPhone10,6":                return "iPhone X"
			case "iPhone11,2":                              return "iPhone XS"
			case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
			case "iPhone11,8":                              return "iPhone XR"
			case "iPhone12,1":                              return "iPhone 11"
			case "iPhone12,3":                              return "iPhone 11 Pro"
			case "iPhone12,5":                              return "iPhone 11 Pro Max"
			case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
			case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad (3rd generation)"
			case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad (4th generation)"
			case "iPad6,11", "iPad6,12":                    return "iPad (5th generation)"
			case "iPad7,5", "iPad7,6":                      return "iPad (6th generation)"
			case "iPad7,11", "iPad7,12":                    return "iPad (7th generation)"
			case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
			case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
			case "iPad11,4", "iPad11,5":                    return "iPad Air (3rd generation)"
			case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad mini"
			case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad mini 2"
			case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad mini 3"
			case "iPad5,1", "iPad5,2":                      return "iPad mini 4"
			case "iPad11,1", "iPad11,2":                    return "iPad mini (5th generation)"
			case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
			case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch)"
			case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
			case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
			case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch)"
			case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
			case "AppleTV5,3":                              return "Apple TV"
			case "AppleTV6,2":                              return "Apple TV 4K"
			case "AudioAccessory1,1":                       return "HomePod"
			case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
			default:                                        return identifier
			}
			#elseif os(tvOS)
			switch identifier {
			case "AppleTV5,3": return "Apple TV 4"
			case "AppleTV6,2": return "Apple TV 4K"
			case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
			default: return identifier
			}
			#endif
		}
		
		return mapToDevice(identifier: identifier)
	}()
	
}


extension UIColor {
	static func hexStringToUIColor (hex:String) -> UIColor {
		var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
		
		if (cString.hasPrefix("#")) {
			cString.remove(at: cString.startIndex)
		}
		
		if ((cString.count) != 6) {
			return UIColor.gray
		}
		
		var rgbValue:UInt32 = 0
		Scanner(string: cString).scanHexInt32(&rgbValue)
		
		return UIColor(
			red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
			green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
			blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
			alpha: CGFloat(1.0)
		)
	}
}

extension UIView {
	
	// Workaround for the UIStackView bug where setting hidden to true with animation
	// mulptiple times requires setting hidden to false multiple times to show the view.
	//https://stackoverflow.com/a/41665706/6030980
	public func workaround_nonRepeatingSetHidden(hidden: Bool) {
		if self.isHidden != hidden {
			self.isHidden = hidden
		}
	}
}

extension UIButton{
	
	func disable(){
		self.isEnabled = false
		self.backgroundColor = #colorLiteral(red: 0.168627451, green: 0.2, blue: 0.368627451, alpha: 1)
		self.setTitleColor(.white, for: .normal)
	}
	
	func enable(){
		self.isEnabled = true
		self.backgroundColor = K.UI.PrimaryTintColor
		self.setTitleColor(.white, for: .normal)
	}
	
	/*func roundedRightTopButton(){
		let maskPath1 = (FPLanguageHandler.shared.getCurrentLanguage() == .English) ? UIBezierPath(roundedRect: bounds,
																								   byRoundingCorners: [.topRight],
																								   cornerRadii: CGSize(width: 10, height: 10)) : UIBezierPath(roundedRect: bounds,
																																							  byRoundingCorners: [.topLeft],
																																							  cornerRadii: CGSize(width: 10, height: 10))
		
		let maskLayer1 = CAShapeLayer()
		maskLayer1.frame = bounds
		maskLayer1.path = maskPath1.cgPath
		layer.mask = maskLayer1
	}
	
	func roundedLeftTopButton(){
		let maskPath1 = (FPLanguageHandler.shared.getCurrentLanguage() == .English) ? UIBezierPath(roundedRect: bounds,
																								   byRoundingCorners: [.topLeft],
																								   cornerRadii: CGSize(width: 10, height: 10)) : UIBezierPath(roundedRect: bounds,
																																							  byRoundingCorners: [.topRight],
																																							  cornerRadii: CGSize(width: 10, height: 10))
		
		let maskLayer1 = CAShapeLayer()
		maskLayer1.frame = bounds
		maskLayer1.path = maskPath1.cgPath
		layer.mask = maskLayer1
	}
	
	func roundedTop2CornerButton(){
		let maskPath1 = UIBezierPath(roundedRect: bounds,
									 byRoundingCorners: [.topLeft , .topRight],
									 cornerRadii: CGSize(width: 10, height: 10))
		let maskLayer1 = CAShapeLayer()
		maskLayer1.frame = bounds
		maskLayer1.path = maskPath1.cgPath
		layer.mask = maskLayer1
	}
	*/
	
}

extension UITextField{
	
	func text() -> String{
		return self.text ?? ""
	}
	
	func addLeftView(_ imageView: UIImageView, for mode: UITextField.ViewMode){
		
		imageView.sizeToFit()
		let leftView = UIView(frame: imageView.bounds)
		leftView.backgroundColor = .clear
		leftView.frame.size.width += 10
		leftView.addSubview(imageView)
		imageView.center = leftView.center
		
		self.leftView = leftView
		self.leftViewMode = .always
		
		return
		
		let leftViewForPhoneNumberTextField = UIView()
		leftViewForPhoneNumberTextField.frame = CGRect(x: 0, y: 0, width: self.bounds.size.height, height: self.bounds.size.height)
		self.leftView = leftViewForPhoneNumberTextField
		self.leftViewMode = mode
		
		let frame = CGRect(x: 0, y: 0, width: self.bounds.size.height * 0.80, height: self.bounds.size.height * 0.80)
		imageView.frame = frame
		imageView.center = leftViewForPhoneNumberTextField.center
		imageView.contentMode = .scaleAspectFit
		leftViewForPhoneNumberTextField.frame.size.width += 10
		imageView.frame.origin.x = 0
		leftViewForPhoneNumberTextField.addSubview(imageView)
	}
	
	func addRightView(_ imageView: UIImageView, for mode: UITextField.ViewMode){
		
		imageView.sizeToFit()
		let rightView = UIView(frame: imageView.bounds)
		rightView.backgroundColor = .clear
		rightView.frame.size.width += 10
		rightView.addSubview(imageView)
		imageView.center = rightView.center
		
		self.rightView = rightView
		self.rightViewMode = .always
		
		return
		
		let rightViewForPhoneNumberTextField = UIView()
		rightViewForPhoneNumberTextField.frame = CGRect(x: 0, y: 0, width: self.bounds.size.height, height: self.bounds.size.height)
		self.rightView = rightViewForPhoneNumberTextField
		self.rightViewMode = mode
		
		let frame = CGRect(x: 0, y: 0, width: self.bounds.size.height * 0.80, height: self.bounds.size.height * 0.80)
		imageView.frame = frame
		imageView.center = rightViewForPhoneNumberTextField.center
		imageView.contentMode = .scaleAspectFit
		rightViewForPhoneNumberTextField.frame.size.width += 10
		imageView.frame.origin.x = 10
		rightViewForPhoneNumberTextField.addSubview(imageView)
	}
	
	func addLeftView(_ button: UIButton, for mode: UITextField.ViewMode){
		
		button.sizeToFit()
		let leftView = UIView(frame: button.bounds)
		leftView.backgroundColor = .clear
		leftView.frame.size.width += 10
		leftView.addSubview(button)
		button.center = leftView.center
		
		self.leftView = leftView
		self.leftViewMode = .always
		
		return
		
		let leftViewForPhoneNumberTextField = UIView()
		leftViewForPhoneNumberTextField.frame = CGRect(x: 0, y: 0, width: self.bounds.size.height, height: self.bounds.size.height)
		self.leftView = leftViewForPhoneNumberTextField
		self.leftViewMode = mode
		
		let frame = CGRect(x: 0, y: 0, width: self.bounds.size.height * 0.80, height: self.bounds.size.height * 0.80)
		button.frame = frame
		button.center = leftViewForPhoneNumberTextField.center
		button.contentMode = .scaleAspectFit
		leftViewForPhoneNumberTextField.frame.size.width += 20
		button.frame.origin.x = 10
		leftViewForPhoneNumberTextField.addSubview(button)
		leftViewForPhoneNumberTextField.backgroundColor = .green
	}
    
    func addLeftView(_ label: UILabel, for mode: UITextField.ViewMode){
            
            label.sizeToFit()
            let leftView = UIView(frame: label.bounds)
            leftView.backgroundColor = .clear
            leftView.frame.size.width += 10
            leftView.addSubview(label)
            label.center = leftView.center
            
            self.leftView = leftView
            self.leftViewMode = .always
            
        }
        
        func addRightView(_ label: UILabel, for mode: UITextField.ViewMode){
            
            label.sizeToFit()
            let rightView = UIView(frame: label.bounds)
            rightView.backgroundColor = .clear
            rightView.frame.size.width += 10
            rightView.addSubview(label)
            label.center = rightView.center
            
            self.rightView = rightView
            self.rightViewMode = .always
            
        }
	
	func addRightView(_ button: UIButton, for mode: UITextField.ViewMode){
		
		button.sizeToFit()
		let rightView = UIView(frame: button.bounds)
		rightView.backgroundColor = .clear
		rightView.frame.size.width += 10
		rightView.addSubview(button)
		button.center = rightView.center
		
		self.rightView = rightView
		self.rightViewMode = .always
		
		return
		
		let rightViewForPhoneNumberTextField = UIView()
		rightViewForPhoneNumberTextField.frame = CGRect(x: 0, y: 0, width: self.bounds.size.height, height: self.bounds.size.height)
		self.rightView = rightViewForPhoneNumberTextField
		self.rightViewMode = mode
		
		let frame = CGRect(x: 0, y: 0, width: self.bounds.size.height * 0.80, height: self.bounds.size.height * 0.80)
		button.frame = frame
		button.center = rightViewForPhoneNumberTextField.center
		button.contentMode = .scaleAspectFit
		rightViewForPhoneNumberTextField.frame.size.width += 20
		button.frame.origin.x = 10
		rightViewForPhoneNumberTextField.addSubview(button)
		rightViewForPhoneNumberTextField.backgroundColor = .red
	}
	
}

postfix operator ~
postfix func ~ (key: String) -> String {
	return NSLocalizedString(key, comment: "")
}

//extension UITextField {
//	open override func awakeFromNib() {
//		super.awakeFromNib()
//		if FPLanguageHandler.shared.getCurrentLanguage() != .English {
//			self.semanticContentAttribute = .forceRightToLeft
//			if self.textAlignment != .center{
//				self.textAlignment = .right
//			}
//		}else{
//			self.semanticContentAttribute = .forceLeftToRight
//			if self.textAlignment != .center{
//				self.textAlignment = .left
//			}
//		}
//	}
//}

protocol OTPTextFieldDelegate{
	func textFieldDidDelete(_ textField: OTPTextField)
}


class OTPTextField: UITextField{
	
	var otpDelegate: OTPTextFieldDelegate?
	
	override func deleteBackward() {
		super.deleteBackward()
		otpDelegate?.textFieldDidDelete(self)
	}
}


protocol FormattedAmountTextFieldDelegate{
	func textFieldDidDelete(_ textField: FormattedAmountTextField)
}

class FormattedAmountTextField: UITextField{
	
	var amountTFDelegate: FormattedAmountTextFieldDelegate?
	
	override func deleteBackward() {
		super.deleteBackward()
		amountTFDelegate?.textFieldDidDelete(self)
	}
}

extension CGRect {
	/// Returns a `Bool` indicating whether the rectangle has any value that is `NaN`.
	func isNaN()  -> Bool {
		return origin.x.isNaN || origin.y.isNaN || width.isNaN || height.isNaN
	}
}

/*extension UINavigationController{
	
	//	open override var preferredStatusBarStyle: UIStatusBarStyle{
	//		if let topVC = viewControllers.last {
	//			//return the status property of each VC, look at step 2
	//			return topVC.preferredStatusBarStyle
	//		}
	//
	//		return .default
	//	}
	
	func showDialog(title: String?, message: String, alertType: CustomAlertType, defaultActionButtonTitle: String = "app_common_try_again"~, alertImage: UIImage? = nil, onDefaultActionButtonTap defaultButtonAction: (()->())?){
		
		//        let alert = UIAlertController(title: title , message: message, preferredStyle: UIAlertController.Style.alert)
		//        alert.addAction(UIAlertAction(title: defaultActionButtonTitle, style: .default, handler: { action in
		//            if let defaultButtonAction = defaultButtonAction{
		//                defaultButtonAction()
		//            }
		//        }))
		//
		//        alert.view.tintColor = view.tintColor
		//        self.present(alert, animated: true, completion: nil)
		
		view.endEditing(true)
		
		var alertTitle: String?
		
		switch alertType {
		
		case .success:
			alertTitle = title
		case .failure:
			alertTitle = title ?? ((message == K.Messages.DefaultErrorMessage) ? "" : "alert_dialog_common_error_title"~)
		case .invoice:
			alertTitle = title
		case .warning:
			alertTitle = title
		case .withdraw:
			alertTitle = title
			
		}
		
		let cvc = CustomAlertViewController()
		cvc.configure(alertType: alertType, title: alertTitle, message: message, image: alertImage, defaultButtonTitle: defaultActionButtonTitle, defaultButtonAction: defaultButtonAction)
		
		
		cvc.modalPresentationStyle = .overCurrentContext
		cvc.modalTransitionStyle = .coverVertical
		
		self.present(cvc, animated: true, completion: nil)
	}
}*/

extension String {
	var isNumeric: Bool {
		guard self.count > 0 else { return false }
		let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
		return Set(self).isSubset(of: nums)
	}
}

extension Array where Element: NSCopying {
	func copy() -> [Element] {
		return self.map { $0.copy() as! Element }
	}
}


/*public class BadgeBarButtonItem: UIBarButtonItem{
	
	@IBInspectable
	public var numberOfBages: Int = 0 {
		didSet {
			self.updateBadge()
		}
	}
	
	private let label: UILabel = UILabel()
	
	public override init() {
		super.init()
		commonInit()
		
		self.addObserver(self, forKeyPath: "view", options: [], context: nil)
	}
	
	required public init?(coder aDecoder: NSCoder){
		super.init(coder: aDecoder)
		commonInit()
		
		self.addObserver(self, forKeyPath: "view", options: [], context: nil)
	}
	
	func commonInit(){
		//label = UILabel()
		label.backgroundColor = K.UI.PrimaryTintColor
		label.alpha = 0.9
		label.layer.cornerRadius = 9
		label.clipsToBounds = true
		label.isUserInteractionEnabled = false
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textAlignment = .center
		label.textColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)
		label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
		label.layer.zPosition = 1
		label.lineBreakMode = .byTruncatingTail
		label.adjustsFontSizeToFitWidth = true
		label.minimumScaleFactor = 0.6
		//self.label = label
	}
	
	override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
		
		self.updateBadge()
	}
	
	private func updateBadge(){
		
		guard let view = self.value(forKey: "view") as? UIView else { return }
		
		self.label.text = "\(numberOfBages)"
		self.label.sizeToFit()
		
		if self.numberOfBages > 0 && self.label.superview == nil{
			
			view.addSubview(self.label)
			let size = ((self.label.bounds.size.width + 10) > 20) ? 20 : self.label.bounds.size.width + 10//(label.text?.count ?? 0 >= 10) ? 13 : 20
			
			self.label.widthAnchor.constraint(equalToConstant: CGFloat(size)).isActive = true
			self.label.heightAnchor.constraint(equalToConstant: CGFloat(size)).isActive = true
			self.label.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: (FPLanguageHandler.shared.getCurrentLanguage() == .English) ? 8 : -5).isActive = true
			self.label.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -9).isActive = true
			
			self.label.layer.cornerRadius = CGFloat(size / 2)
		}
		else if self.numberOfBages == 0 && self.label.superview != nil{
			self.label.removeFromSuperview()
		}
	}
	
	deinit {
		self.removeObserver(self, forKeyPath: "view")
	}
}*/

extension UIImage {
	
	func paintOver(with color: UIColor) -> UIImage {
		let renderer = UIGraphicsImageRenderer(size: size)
		let renderedImage = renderer.image { _ in
			color.set()
			self.withRenderingMode(.alwaysTemplate).draw(in: CGRect(origin: .zero, size: size))
		}
		
		return renderedImage
	}
}

extension Date {
	func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
		return calendar.dateComponents(Set(components), from: self)
	}
	
	func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
		return calendar.component(component, from: self)
	}
}

extension UIView {

	//https://stackoverflow.com/questions/30696307/how-to-convert-a-uiview-to-an-image
	//https://www.hackingwithswift.com/example-code/media/how-to-render-a-uiview-to-a-uiimage
	
	func asImage() -> UIImage {
		if #available(iOS 10.0, *) {
			let renderer = UIGraphicsImageRenderer(bounds: bounds)
			return renderer.image { rendererContext in
				//layer.render(in: rendererContext.cgContext)
				self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
			}
		} else {
			UIGraphicsBeginImageContext(self.frame.size)
			self.layer.render(in:UIGraphicsGetCurrentContext()!)
			let image = UIGraphicsGetImageFromCurrentImageContext()
			UIGraphicsEndImageContext()
			return UIImage(cgImage: image!.cgImage!)
		}
	}
}

/*@IBDesignable class FPImageView: UIImageView {
	
	// MARK: - Initialization
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	// MARK: - UI Setup
	override func prepareForInterfaceBuilder() {
		setupView()
	}
	
	func setupView() {
		
		if FPLanguageHandler.shared.getCurrentLanguage() == .English{
			
		}else if FPLanguageHandler.shared.getCurrentLanguage() == .Arabic{
			self.image = arabicImage
		}else if FPLanguageHandler.shared.getCurrentLanguage() == .Kurdish{
			self.image = kurdishImage
		}
	}
	
	@IBInspectable var arabicImage: UIImage? = nil{
		didSet{
			if FPLanguageHandler.shared.getCurrentLanguage() == .Arabic{
				self.image = arabicImage
			}
		}
	}
	
	@IBInspectable var kurdishImage: UIImage? = nil{
		didSet{
			if FPLanguageHandler.shared.getCurrentLanguage() == .Kurdish{
				self.image = kurdishImage
			}
		}
	}
}*/
