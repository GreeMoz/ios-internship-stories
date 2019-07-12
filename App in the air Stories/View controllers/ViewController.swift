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
                StoryWindow(image: UIImage(named: "one"), title: "Terminal and gate changes", text: "and much more", type: .textUp),
                StoryWindow(image: UIImage(named: "two"), title: "Detailed profile", type: .textUp),
                StoryWindow(image: UIImage(named: "three"), title: "Notifications", type:.textUp),
                StoryWindow(image: UIImage(named: "four"), title: "AR map of your flights", text: "Visualize your flights in 3D"),
                StoryWindow(image: UIImage(named: "five"), title: "Statistics", text: "By years and months", backgroundColor: .black)
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
