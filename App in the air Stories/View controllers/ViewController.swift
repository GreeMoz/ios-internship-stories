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
                // в новых версиях xcode можно опускать поля и тогда они будут заманены значениями по умолчанию, здесь надо прописывать всё
                StoryWindow(image: UIImage(named: "one"), title: "Terminal and gate changes", text: "and much more", textColor: .white, backgroundColor: .clear, type: .textUp),
                StoryWindow(image: UIImage(named: "two"), title: "Detailed profile", text: "", textColor: .white, backgroundColor: .clear, type: .textUp),
                StoryWindow(image: UIImage(named: "three"), title: "Notifications", text: "", textColor: .white, backgroundColor: .clear, type:.textUp),
                StoryWindow(image: UIImage(named: "four"), title: "AR map of your flights", text: "Visualize your flights in 3D", textColor: .white, backgroundColor: .clear, type:.textDown),
                StoryWindow(image: UIImage(named: "five"), title: "Statistics", text: "By years and months", textColor: .white, backgroundColor: .black, type: .textDown)
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
