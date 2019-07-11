//
//  StoriesViewController.swift
//  App in the air Stories
//
//  Created by Oleg Kornienko on 09.07.2019.
//  Copyright © 2019 Oleg Kornienko. All rights reserved.
//

import UIKit

enum WindowType {
    case textUp
    case textDown
}

struct StoryWindow {
    var image: UIImage?
    var title: String?
    var text: String?
    var textColor: UIColor = .white
    var backgroundColor: UIColor = .clear
    var type: WindowType = .textDown
}

class StoriesViewController: UIViewController {
    var windows: [StoryWindow] = []
    var currentIndex = 0 {
        didSet {
            pageControl.currentIndex = currentIndex + 1
        }
    }
    var interactor: Interactor?
    
    var pageViewController: UIPageViewController?
    @IBOutlet weak var pageControl: PageControlView!
    
    @IBOutlet weak var contentView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        setupPageControl()
        setupGestures()
        setupPageViewController()
    }
    
    func setupPageControl() {
        pageControl.currentIndex = currentIndex + 1
        pageControl.numberOfPages = windows.count
    }
    
    func setupPageViewController() {
        guard let pageViewController = storyboard?.instantiateViewController(withIdentifier: String(describing: PageViewController.self)) as? PageViewController else { return }
        
        self.pageViewController = pageViewController
        pageViewController.dataSource = self
        pageViewController.delegate = self
        addChild(pageViewController)
        pageViewController.didMove(toParent: self)
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(pageViewController.view)
        
        let views: [String: UIView] = ["pageView": pageViewController.view]
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[pageView]-0-|",
                                                                  options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                                                                  metrics: nil,
                                                                  views: views))
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[pageView]-0-|",
                                                                  options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                                                                  metrics: nil,
                                                                  views: views))
        
        guard let startingViewController = viewControllerFor(index: currentIndex) else { return }
        
        pageViewController.setViewControllers([startingViewController], direction: .forward, animated: true)
    }
    
    private func generateControllerFor(storyWindow: StoryWindow) -> UIViewController? {
        switch storyWindow.type {
        case .textDown:
            if let vc = storyboard?.instantiateViewController(withIdentifier: String(describing: ContentTextDownViewController.self)) as? ContentTextDownViewController {
                vc.displayImage = storyWindow.image
                vc.displayTitle = storyWindow.title
                vc.displayText = storyWindow.text
                vc.textColor = storyWindow.textColor
                vc.backgroundColor = storyWindow.backgroundColor
                return vc
            }
        case .textUp:
            if let vc = storyboard?.instantiateViewController(withIdentifier: String(describing: ContentTextUpViewController.self)) as? ContentTextUpViewController {
                vc.displayImage = storyWindow.image
                vc.displayTitle = storyWindow.title
                vc.displayText = storyWindow.text
                vc.textColor = storyWindow.textColor
                return vc
            }
        }
        
        return nil
    }
    
    func viewControllerFor(index: Int) -> UIViewController? {
        guard index >= 0 && index < windows.count else { return nil }
        
        let vc = generateControllerFor(storyWindow: windows[index])
        (vc as? ContentTextDownViewController)?.index = index
        
        return vc
    }
    
    func setupGestures() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        view.addGestureRecognizer(tapGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(panGesture)
    }
    
    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
        let percentThreshold: CGFloat = 0.3
        
        let translation = sender.translation(in: view)
        let verticalMovement = translation.y / view.bounds.height
        let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
        let downwardMovementPercent = fminf(downwardMovement, 1.0)
        let progress = CGFloat(downwardMovementPercent)
        
        guard let interactor = interactor else { return }
        
        switch sender.state {
        case .began:
            interactor.hasStarted = true
            dismiss(animated: true, completion: nil)
        case .changed:
            interactor.shouldFinish = progress > percentThreshold
            interactor.update(progress)
        case .cancelled:
            interactor.hasStarted = false
            interactor.cancel()
        case .ended:
            interactor.hasStarted = false
            interactor.shouldFinish
                ? interactor.finish()
                : interactor.cancel()
        default:
            break
        }
    }

    @IBAction @objc func close(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @objc func tapped(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: contentView).x / contentView.bounds.size.width
        
        if location < 0.40 {
            turnPrevious()
        } else {
            turnNext()
        }
    }
    
    @objc func turnNext() {
        if let vc = viewControllerFor(index: currentIndex + 1) {
            pageViewController?.setViewControllers([vc], direction: .forward, animated: false) { completed in
                if completed {
                    self.currentIndex += 1
                }
            }
        }
    }
    
    @objc func turnPrevious() {
        if let vc = viewControllerFor(index: currentIndex - 1) {
            pageViewController?.setViewControllers([vc], direction: .reverse, animated: false) { completed in
                if completed {
                    self.currentIndex -= 1
                }
            }
        }
    }
}

extension StoriesViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let viewController = viewController as? ContentTextDownViewController, let index = viewController.index {
            return viewControllerFor(index: index - 1)
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let viewController = viewController as? ContentTextDownViewController, let index = viewController.index {
            return viewControllerFor(index: index + 1)
        }
        return nil
    }

}

extension StoriesViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        if let newIndex = (pendingViewControllers.first as? ContentTextDownViewController)?.index {
            currentIndex = newIndex
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if !completed {
            if let newIndex = (previousViewControllers.first as? ContentTextDownViewController)?.index {
                currentIndex = newIndex
            }
        }
    }
}
