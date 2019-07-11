//
//  DismissAnimator.swift
//  App in the air Stories
//
//  Created by Oleg Kornienko on 10.07.2019.
//  Copyright © 2019 Oleg Kornienko. All rights reserved.
//

import Foundation
import UIKit

class DismissAnimator: NSObject {}

extension DismissAnimator : UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let from = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let to = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        else {
            return
        }
        
        transitionContext.containerView.insertSubview(to.view, belowSubview: from.view)
        
        UIView.animate(withDuration: 0.6, animations: {
            from.view.frame = CGRect(origin: CGPoint(x: 0, y: UIScreen.main.bounds.height), size: UIScreen.main.bounds.size)            
        }) { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
        
    }
}
