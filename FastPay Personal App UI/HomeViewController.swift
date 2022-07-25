//
//  ViewController.swift
//  FastPay Personal App UI
//
//  Created by Shakhawat Hossain Shakib on 24/12/20.
//

import UIKit

class HomeViewController: UIViewController {

    var item = 0
let transition = SlideinTransition()
override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationItem.titleView = UIImageView(image: UIImage(named: "Group 13114"))
}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Sonar Cloud testing")
        if item == 0 {
            print(String(item))
            item += 1
        }else
            print(String(item))
        
        
    }


@IBAction func menuTapped(_ sender: UIBarButtonItem){
   guard let menuViewController = storyboard?.instantiateViewController(withIdentifier: "menuViewController") as? MenuViewController else { return }
    menuViewController.didTapMenuType = { menuType in
        self.transiitionToNew(menuType: menuType)
    }
    menuViewController.modalPresentationStyle = .overCurrentContext
    menuViewController.transitioningDelegate = self
    present(menuViewController, animated: true)
    
}

func transiitionToNew (menuType: MenuType) {
    let title = String(describing: menuType).capitalized
    self.title = title
}

}

extension HomeViewController: UIViewControllerTransitioningDelegate {
func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    transition.isPresenting = true
    return transition
}
func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    transition.isPresenting = false
    return transition
}
}
