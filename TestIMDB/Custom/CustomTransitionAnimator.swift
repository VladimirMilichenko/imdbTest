//
//  CustomTransitionAnimator.swift
//  TestIMDB
//
//  Created by Vladimir Milichenko on 11/20/22.
//

import UIKit

class CustomTransitionAnimator: NSObject { }

extension CustomTransitionAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView

        guard let toViewController = transitionContext.viewController(forKey: .to) else {
            return
        }

        containerView.addSubview(toViewController.view)

        toViewController.view.alpha = 0
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            toViewController.view.alpha = 1
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
    }
}
