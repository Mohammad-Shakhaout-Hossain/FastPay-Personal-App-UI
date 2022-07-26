//
//  BaseViewController.swift
//
//  Created by Anamul Habib on 7/1/19.
//  Copyright © 2019 SSL Wireless. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
	
	private(set) var scrollViewToOverride: UIScrollView?
	private(set) var containerViewToOverride: UIView?
	private(set) var containerViewTopSpaceConstraintToOverride: NSLayoutConstraint?
	private var activeFieldFrame: CGRect?
	private var containerViewOriginalFrame: CGRect!
	private var containerViewTopSpaceConstraintOriginalConstant: CGFloat!
	private(set) var shouldConfigureReturnKeyBasedOnTag: Bool = true
	private(set) var shouldAddToolbarToTextFieldWithSpecialKeyboardType: Bool = true
	private(set) var textFieldToolBarDoneButtonTitle: String = "Done"
	private(set) var textFieldToolBarNextButtonTitle: String = "Next"
	//private(set) var navigationBarTitleViewImage: UIImage? = (FPLanguageHandler.shared.getCurrentLanguage() == .English) ? #imageLiteral(resourceName: "logoFastPayNav") : #imageLiteral(resourceName: "logoFastPayNav-Ar")
	private(set) var shouldRewindByTappingTitleView = true
	private(set) var shouldShowNotificationButtonOnNavigationBar = true
	private(set) var shouldHaveBackButtonTitle = true
	
	//private let notificationButton = BadgeBarButtonItem.init()
	
	var firstTimeAppearing = true
	
	//let currentLanguage = FPLanguageHandler.shared.getCurrentLanguage()
	let usersettings = UserSettings.shared
	let webserviceHandler = WebServiceHandler.shared
	
	override func viewDidLoad() {
		
		super.viewDidLoad()
		
		registerForKeyboardNotifications()
		
//		NotificationCenter.default.addObserver(
//			self,
//			selector: #selector(updateUserInterface),
//			name: NSNotification.Name.LokaliseDidUpdateLocalization,
//			object: nil
//		)
		
		self.navigationItem.backBarButtonItem = UIBarButtonItem(title: (shouldHaveBackButtonTitle) ? "" : nil, style: .plain, target: nil, action: nil)
		
//		if let navBarTitleImage = navigationBarTitleViewImage{
//
//			self.navigationItem.leftItemsSupplementBackButton = true
//
//			let titleButton = UIBarButtonItem()
//			titleButton.image = navBarTitleImage.withRenderingMode(.alwaysOriginal)
////			self.navigationItem.setLeftBarButton(titleButton, animated: true)
//			if self.navigationItem.leftBarButtonItems != nil{
//				self.navigationItem.leftBarButtonItems?.append(titleButton)
//			}else{
//				self.navigationItem.leftBarButtonItems = [titleButton]
////				self.navigationItem.setLeftBarButton(titleButton, animated: true)
//			}
//
//			if shouldRewindByTappingTitleView {
//				titleButton.target = self
//				titleButton.action = #selector(titleViewTapped(_:))
//			}
//		}
		
//		if shouldShowNotificationButtonOnNavigationBar{
//
//			notificationButton.image =  #imageLiteral(resourceName: "navBellIcon")
//			notificationButton.target = self
//			notificationButton.action = #selector(notificaitonTapped(_:))
//			notificationButton.tintColor = .white
//
//			if let count = usersettings.notificationCount, count.intValue != -1{
//				notificationButton.numberOfBages = count.intValue
//			}else{
//				webserviceHandler.notificationList(onCompletion: { (response) in
//
//					if response.code == 200, let count = response.notificationData?.unreadCount{
//						self.usersettings.notificationCount = NSNumber(integerLiteral: count)
//						self.notificationButton.numberOfBages = count
//					}
//
//				}, onFailure: { ( _) in
//
//				}, shouldShowLoader: false)
//			}
//
//			self.navigationItem.rightBarButtonItem = notificationButton
//		}
	}
	
//	@objc private func titleViewTapped(_ sender: UIButton) {
//
//		if (self.navigationController?.tabBarController as? FPTabBarController) != nil{
//			(UIApplication.shared.delegate as? AppDelegate)?.loadHomeScene()
//		}
//	}
	
//	@objc private func notificaitonTapped(_ sender: UIBarButtonItem){
//		self.navigationController?.show(UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "notificationSceneSBID"), sender: self)
//	}
//
//	func updateNotificationBadge(count: Int?, by: Int? = 0){
//		if let count = count{
//			usersettings.notificationCount = NSNumber(integerLiteral: count)
//			notificationButton.numberOfBages = count
//		}else{
//			if let by = by{
//				if let count = usersettings.notificationCount{
//					let updatedCount = count.intValue + by
//					usersettings.notificationCount = (updatedCount < 0) ? NSNumber(integerLiteral: 0) : NSNumber(integerLiteral: updatedCount)
//					notificationButton.numberOfBages = (updatedCount < 0) ? 0 : updatedCount
//				}
//			}
//		}
//	}
	
	override func viewWillAppear(_ animated: Bool) {
		
		super.viewWillAppear(animated)
		
		setTranslatableStaticTexts()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		//self.presentedViewController?.dismiss(animated: true, completion: nil)
		view.endEditing(true)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		
		super.viewDidAppear(animated)
		containerViewOriginalFrame = containerViewToOverride?.frame
		containerViewTopSpaceConstraintOriginalConstant = containerViewTopSpaceConstraintToOverride?.constant
		
		//updateNotificationBadge(count: usersettings.notificationCount?.intValue ?? 0, by: nil)
	}
	
	
	@objc private func updateUserInterface() {
		setTranslatableStaticTexts()
	}
	
	func setTranslatableStaticTexts(){
		
	}
	
	private func registerForKeyboardNotifications() {
		
		NotificationCenter.default.addObserver(self, selector: #selector(self.onKeyboardAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(self.onKeyboardDisappear(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	
	@objc private func onKeyboardAppear(_ notification: NSNotification) {
		
		if let info = notification.userInfo, let activeFieldFrame = activeFieldFrame {
			
			let rect: CGRect = info[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
			let keyboardSize = rect.size
			
			// WITH SCROLLVIEW
			if let scrollView = scrollViewToOverride {
				
				pushUpFor(scrollView: scrollView, activeFieldFrame: activeFieldFrame, keyboardSize: keyboardSize)
				
				//WITH OUT SCROLLVIEW
			}else{
				
				//WITH AUTOLAYOUT CONSTRAINT
				if let containerViewTopSpaceConstraint = containerViewTopSpaceConstraintToOverride{
					
					pushUpFor(containerViewTopSpaceConstraint: containerViewTopSpaceConstraint, activeFieldFrame: activeFieldFrame, keyboardSize: keyboardSize)
					
					//WITHOUT AUTOLAYOUT CONSTRAINT, FRAME BASED
				}else{
					
					if let containerView = containerViewToOverride {
						
						pushUpFor(containerView: containerView, activeFieldFrame: activeFieldFrame, keyboardSize: keyboardSize)
					}
				}
			}
		}
	}
	
	@objc private func onKeyboardDisappear(_ notification: NSNotification) {
		
		// WITH SCROLLVIEW
		if let scrollView = scrollViewToOverride{
			
			scrollView.contentInset = .zero
			scrollView.scrollIndicatorInsets = .zero
			
			//WITHOUT SCROLLVIEW
		}else{
			
			//WITH AUTOLAYOUT CONSTRAINT
			if let containerViewTopSpaceConstraint = containerViewTopSpaceConstraintToOverride{
				
				if containerViewTopSpaceConstraint.constant != containerViewTopSpaceConstraintOriginalConstant{
					
					UIView.animate(withDuration: TimeInterval(0.5)) {
						containerViewTopSpaceConstraint.constant = self.containerViewTopSpaceConstraintOriginalConstant
					}
					view.setNeedsUpdateConstraints()
				}
				
				//WITHOUT AUTOLAYOUT CONSTRAINT, FRAME BASED
			}else{
				
				if let containerView = containerViewToOverride{
					
					if containerView.frame.origin.y != containerViewOriginalFrame.origin.y{
						
						UIView.animate(withDuration: TimeInterval(0.5)) {
							containerView.frame.origin.y = self.containerViewOriginalFrame.origin.y
						}
						view.layoutIfNeeded()
					}
				}
			}
		}
	}
	
	private func pushUpFor(scrollView: UIScrollView, activeFieldFrame: CGRect, keyboardSize: CGSize){
		
		var aRect = self.view.bounds;
		aRect.size.height -= keyboardSize.height;
		
		let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
		scrollView.contentInset = insets
		scrollView.scrollIndicatorInsets = insets
		
		if !aRect.contains(activeFieldFrame.origin) {
			scrollView.scrollRectToVisible(activeFieldFrame, animated: true)
		}
	}
	
	private func pushUpFor(containerViewTopSpaceConstraint: NSLayoutConstraint, activeFieldFrame: CGRect, keyboardSize: CGSize){
		
		var aRect = self.view.bounds;
		aRect.size.height -= keyboardSize.height;
		
		if !aRect.contains(activeFieldFrame.origin){
			
			if containerViewTopSpaceConstraint.constant == containerViewTopSpaceConstraintOriginalConstant{
				
				UIView.animate(withDuration: TimeInterval(0.5)) {
					containerViewTopSpaceConstraint.constant -= keyboardSize.height
				}
				view.setNeedsUpdateConstraints()
			}
		}
	}
	
	private func pushUpFor(containerView: UIView, activeFieldFrame: CGRect, keyboardSize: CGSize){
		
		var aRect = containerView.bounds;
		aRect.size.height -= keyboardSize.height
		
		//if rect.intersects(activeFieldFrame){
		if !aRect.contains(activeFieldFrame.origin){
			
			if containerView.frame.origin.y == containerViewOriginalFrame.origin.y {
				
				UIView.animate(withDuration: TimeInterval(0.5)) {
					containerView.frame.origin.y -= keyboardSize.height
				}
				view.layoutIfNeeded()
			}
		}
	}
	
	
	private func determineReturnKeyTypeForResponder(withTag tag: Int) -> UIReturnKeyType {
		
		let nextTag = tag + 1
		let nextResponder = view.viewWithTag(nextTag)
		
		if nextResponder != nil {
			return .next
		} else {
			return .done
		}
	}
	
	private func addBasicActionToReturnKeyOfTextField(withTag tag: Int) -> Bool{
		
		let nextTag = tag + 1
		let nextResponder = view.viewWithTag(nextTag)
		
		if nextResponder != nil {
			
			nextResponder?.becomeFirstResponder()
			return true
		} else {
			
			view.endEditing(true)
			return false
		}
	}
	
	private func addToolBar(toTextField textField: UITextField){
		
		let toolBar = UIToolbar()
		toolBar.barStyle = UIBarStyle.default
		toolBar.isTranslucent = true
		toolBar.tintColor = #colorLiteral(red: 0.168627451, green: 0.2, blue: 0.368627451, alpha: 1)
		
		let doneButton = UIBarButtonItem(title: (determineReturnKeyTypeForResponder(withTag: textField.tag) == .next) ? textFieldToolBarNextButtonTitle : textFieldToolBarDoneButtonTitle, style: UIBarButtonItem.Style.plain, target: self, action: #selector(doneOrNextPressed(_:)))
		doneButton.tag = textField.tag
		
		let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
		
		toolBar.setItems([spaceButton, doneButton], animated: false)
		toolBar.isUserInteractionEnabled = true
		toolBar.sizeToFit()
		
		textField.inputAccessoryView = toolBar
	}
	
	@objc private func doneOrNextPressed(_ button: UIBarButtonItem){
		
		_ = addBasicActionToReturnKeyOfTextField(withTag: button.tag)
	}
	
	
	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		
		activeFieldFrame = textField.frame
		
		return true
	}
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		
		view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapDetected(_:))))
		
		if shouldConfigureReturnKeyBasedOnTag && textField.returnKeyType == .default {
			textField.returnKeyType = determineReturnKeyTypeForResponder(withTag: textField.tag)
		}
		
		var shouldHaveToolBar: Bool
		if #available(iOS 10.0, *) {
			shouldHaveToolBar = shouldAddToolbarToTextFieldWithSpecialKeyboardType && (textField.keyboardType == .numberPad || textField.keyboardType == .phonePad || textField.keyboardType == .decimalPad || textField.keyboardType == .asciiCapableNumberPad) || (textField.inputView is UIPickerView)
		} else {
			shouldHaveToolBar = shouldAddToolbarToTextFieldWithSpecialKeyboardType && (textField.keyboardType == .numberPad || textField.keyboardType == .phonePad || textField.keyboardType == .decimalPad) || (textField.inputView is UIPickerView)
		}
		
		if shouldHaveToolBar {
			addToolBar(toTextField: textField)
		}else{
			textField.inputAccessoryView = nil
		}
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		//checkInputs()
	}
	
	func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
		
		activeFieldFrame = textView.frame
		
		return true
	}
	
	func textViewDidBeginEditing(_ textView: UITextView) {
		
		view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapDetected(_:))))
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		
		if shouldConfigureReturnKeyBasedOnTag{
			
			return addBasicActionToReturnKeyOfTextField(withTag: textField.tag)
		}
		
		return true
	}
	
	
	
	@objc private func tapDetected(_ tapRecognizer: UITapGestureRecognizer?) {
		
		view.endEditing(true)
		if let tapRecognizer = tapRecognizer {
			view.removeGestureRecognizer(tapRecognizer)
		}
	}
	
    func showDialog(title: String?, message: String, defaultActionButtonTitle: String = "OK", onDefaultActionButtonTap defaultButtonAction: (()->())?){
        let alert = UIAlertController(title: title , message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: defaultActionButtonTitle, style: .default, handler: { action in
            if let defaultButtonAction = defaultButtonAction{
                defaultButtonAction()
            }
        }))
        
        alert.view.tintColor = view.tintColor
        self.present(alert, animated: true, completion: nil)
    }
	
	/*func showDialog(title: String?, message: String, alertType: CustomAlertType, defaultActionButtonTitle: String = "app_common_try_again"~, alertImage: UIImage? = nil, onDefaultActionButtonTap defaultButtonAction: (()->())?){
		
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
	
	func showDialogWithCancel(title: String?, message: String, alertType: CustomAlertType, defaultActionButtonTitle: String = "OK", alertImage: UIImage? = nil, defaultButtonAction: (()->())?, onCancelActionButtonTap cancelButtonAction: (()->())?){
		
		view.endEditing(true)
		
		let cvc = CustomAlertViewController()
		cvc.configure(alertType: alertType, title: title, message: message, image: alertImage, defaultButtonTitle: defaultActionButtonTitle, defaultButtonAction: defaultButtonAction)
		
		cvc.modalPresentationStyle = .overCurrentContext
		cvc.modalTransitionStyle = .coverVertical
		
		self.present(cvc, animated: true, completion: nil)
	}*/
	
//	func showDialogWithCashOutData(data: ModelWithdrowMoneyPost,title: String?, message: String, alertType: CustomAlertType, defaultActionButtonTitle: String = "OK", alertImage: UIImage? = nil, defaultButtonAction: (()->())?, onCancelActionButtonTap cancelButtonAction: (()->())?){
//
//		let cvc = CustomAlertViewController()
//		cvc.withdradData = data
//		//cvc.configure(alertType: alertType, title: title, message: message, image: alertImage, defaultButtonTitle: defaultActionButtonTitle, defaultButtonAction: defaultButtonAction)
//		cvc.configureWithCancel(alertType: alertType, title: title, message: message, image: alertImage, defaultButtonTitle: defaultActionButtonTitle, defaultButtonAction: defaultButtonAction, cancelButtonAction: cancelButtonAction)
//
//		cvc.modalPresentationStyle = .overCurrentContext
//		cvc.modalTransitionStyle = .coverVertical
//
//		self.present(cvc, animated: true, completion: nil)
//	}
	
//	func showSuccessView(date: ModelWithdrowMoneyPost?, confirmButtonAction: (()->())?, onCancelActionButtonTap cancelButtonAction: (()->())?){
//
//		let cvc = WithdrawSuccessCustomViewController()
//		cvc.withdradData = date
//		cvc.configarData(data: date!, confirmButtonAction: confirmButtonAction, cancelButtonAction: cancelButtonAction)
//		cvc.modalPresentationStyle = .overCurrentContext
//		cvc.modalTransitionStyle = .coverVertical
//
//		self.present(cvc, animated: true, completion: nil)
//	}
//
	
	
	@objc func checkInputs(){
		
	}
	
	func showLoader(){
		Loader.sharedInstance.startAnimation()
	}
	
	func hideLoader(){
		Loader.sharedInstance.stopAnimation()
	}
	
	func formatMobileNumberEscapingSpecialChar(_ mobileNumber: String?) -> String {
		var mobileNumber = mobileNumber
		//mobileNumber = mobileNumber?.replacingOccurrences(of: "(", with: "")
		//mobileNumber = mobileNumber?.replacingOccurrences(of: ")", with: "")
		mobileNumber = mobileNumber?.replacingOccurrences(of: " ", with: "")
		//mobileNumber = mobileNumber?.replacingOccurrences(of: "-", with: "")
		//mobileNumber = mobileNumber?.replacingOccurrences(of: "+", with: "")
		
		return mobileNumber ?? ""
		
		print("\(mobileNumber ?? "")")
		
		let length = mobileNumber?.count ?? 0
		if length > 10 {
			mobileNumber = (mobileNumber as NSString?)?.substring(from: length - 10)
			print("\(mobileNumber ?? "")")
		}
		
		return mobileNumber ?? ""
	}
	
	func getMobileNoLengthEscapingSpecialChar(_ mobileNumber: String?) -> Int {
		var mobileNumber = mobileNumber
		mobileNumber = mobileNumber?.replacingOccurrences(of: "(", with: "")
		mobileNumber = mobileNumber?.replacingOccurrences(of: ")", with: "")
		mobileNumber = mobileNumber?.replacingOccurrences(of: " ", with: "")
		mobileNumber = mobileNumber?.replacingOccurrences(of: "-", with: "")
		mobileNumber = mobileNumber?.replacingOccurrences(of: "+", with: "")
		
		let length = mobileNumber?.count ?? 0
		
		return length
	}
	
	deinit {
		
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
	}
}

extension UITableView {

    func reloadWithAnimation() {
        self.reloadData()
        let tableViewHeight = self.bounds.size.height
        let cells = self.visibleCells
        var delayCounter = 0
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        for cell in cells {
            UIView.animate(withDuration: 1.6, delay: 0.08 * Double(delayCounter),usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
    }
    
    func indicatorView() -> UIActivityIndicatorView{
        var activityIndicatorView = UIActivityIndicatorView()
        if self.tableFooterView == nil {
            let indicatorFrame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 80)
            activityIndicatorView = UIActivityIndicatorView(frame: indicatorFrame)
            activityIndicatorView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
            
            if #available(iOS 13.0, *) {
                activityIndicatorView.style = .large
            } else {
                // Fallback on earlier versions
                activityIndicatorView.style = .whiteLarge
            }
            
            activityIndicatorView.color = .systemPink
            activityIndicatorView.hidesWhenStopped = true

            self.tableFooterView = activityIndicatorView
            return activityIndicatorView
        }
        else {
            return activityIndicatorView
        }
    }

    func addLoading(_ indexPath:IndexPath, closure: @escaping (() -> Void)){
        indicatorView().startAnimating()
        if let lastVisibleIndexPath = self.indexPathsForVisibleRows?.last {
            if indexPath == lastVisibleIndexPath && indexPath.row == self.numberOfRows(inSection: 0) - 1 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    closure()
                }
            }
        }
    }

    func stopLoading() {
        if self.tableFooterView != nil {
            self.indicatorView().stopAnimating()
            self.tableFooterView = nil
        }
        else {
            self.tableFooterView = nil
        }
    }
}

class ShadowView: UIView {
    override var bounds: CGRect {
        didSet {
            setupShadow()
        }
    }

    private func setupShadow() {
        self.layer.cornerRadius = 8
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.3
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 8, height: 8)).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}
