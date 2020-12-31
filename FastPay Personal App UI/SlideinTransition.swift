//
//  SlideinTransition.swift
//  FastPay Personal App UI
//
//  Created by Shakhawat Hossain Shakib on 24/12/20.
//

import UIKit

class SlideinTransition: NSObject, UIViewControllerAnimatedTransitioning {

var isPresenting = true
var dimmingView = UIView ()

func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.5
}

func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard let toViewController = transitionContext.viewController(forKey: .to),
          let fromViewController = transitionContext.viewController(forKey: .from) else { return }
    
    let containerView = transitionContext.containerView
    let finalWidth = toViewController.view.bounds.width * 0.8
    let finalHeight = toViewController.view.bounds.height
    
    if isPresenting {
        // Add dimming View
        dimmingView.backgroundColor = #colorLiteral(red: 0.07058823529, green: 0.07450980392, blue: 0.1294117647, alpha: 1)
        dimmingView.alpha = 0.0
        containerView.addSubview(dimmingView)
        dimmingView.frame = containerView.bounds
        // Add menuViewController to container
        containerView.addSubview(toViewController.view)
        
        // Init frame off the screen
        toViewController.view.frame = CGRect(x: -finalWidth, y: 0, width: finalWidth, height: finalHeight)
    }
    // Animate onto the screen
    let transform = {
        self.dimmingView.alpha = 0.5
        toViewController.view.transform = CGAffineTransform(translationX: finalWidth, y: 0)
    }
    // animate off screen
    let identity = {
        self.dimmingView.alpha = 0.0
        fromViewController.view.transform = .identity
    }
    
    // animation of the transition
    let duration = transitionDuration(using: transitionContext)
    let isCancelled = transitionContext.transitionWasCancelled
    UIView.animate(withDuration: duration) {
        self.isPresenting ? transform() : identity()
    } completion: { (_) in
        transitionContext.completeTransition(!isCancelled)
    }
}
}
