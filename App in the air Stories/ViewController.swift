//
//  ViewController.swift
//  App in the air Stories
//
//  Created by Oleg Kornienko on 09.07.2019.
//  Copyright © 2019 Oleg Kornienko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let interactor = Interactor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func openStories(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: String(describing: StoriesViewController.self)) as? StoriesViewController {
            vc.modalPresentationStyle = .fullScreen
            vc.windows = [
                StoryWindow(image: UIImage(named: "four"), title: "Test title", text: "wow", textColor: .red),
                StoryWindow(image: UIImage(named: "one"), text: "wow"),
                StoryWindow(image: UIImage(named: "three"), title: "Test title", text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", textColor: .black, backgroundColor: .white),
                StoryWindow(image: UIImage(named: "two"))
            ]
            
            vc.transitioningDelegate = self
            vc.interactor = interactor
            present(vc, animated: true)
        }
    }
    
}

extension ViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissAnimator()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}
