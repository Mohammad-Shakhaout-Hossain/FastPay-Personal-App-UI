//
//  MenuViewController.swift
//  FastPay Personal App UI
//
//  Created by Shakhawat Hossain Shakib on 24/12/20.
//

import UIKit

enum MenuType: Int {
case accountSettings
case transactionHistry
case limits
case referAFriend
case promotions
case appSettings
case supportHelp
case logOut
}

class MenuViewController: UITableViewController {

var didTapMenuType: ((MenuType) -> Void)?

override func viewDidLoad() {
    super.viewDidLoad()

}

override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let menuType = MenuType(rawValue: indexPath.row) else {return}
    dismiss(animated: true) { [weak self] in
        print("Dismission: \(menuType)")
        self?.didTapMenuType?(menuType)
    }
}
@IBAction func dismissBtnTapped(_ sender: Any) {
    dismiss(animated: true, completion: nil)
}


}
