//
//  StoriesViewController.swift
//  App in the air Stories
//
//  Created by Oleg Kornienko on 09.07.2019.
//  Copyright © 2019 Oleg Kornienko. All rights reserved.
//

import UIKit

struct StoryWindow {
    var image: UIImage?
    var title: String?
    var text: String?
    var textColor: UIColor = .white
}

class StoriesViewController: UIViewController {
    var windows: [StoryWindow] = []
    var currentIndex = 0
    var pageViewController: UIPageViewController?

    @IBOutlet weak var contentView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        setupGestures()
        setupPageViewController()
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
        if let vc = storyboard?.instantiateViewController(withIdentifier: String(describing: ContentViewController.self)) as? ContentViewController {
            vc.displayImage = storyWindow.image
            vc.displayTitle = storyWindow.title
            vc.displayText = storyWindow.text
            vc.textColor = storyWindow.textColor
            return vc
        } else {
            return nil
        }
    }
    
    func viewControllerFor(index: Int) -> UIViewController? {
        guard index >= 0 && index < windows.count else { return nil }
        
        let vc = generateControllerFor(storyWindow: windows[index])
        (vc as? ContentViewController)?.index = index
        
        return vc
    }
    
    func setupGestures() {
        let closeGesture = UISwipeGestureRecognizer(target: self, action: #selector(close))
        closeGesture.direction = .down
        view.addGestureRecognizer(closeGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        view.addGestureRecognizer(tapGesture)
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
        if let viewController = viewController as? ContentViewController, let index = viewController.index {
            return viewControllerFor(index: index - 1)
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let viewController = viewController as? ContentViewController, let index = viewController.index {
            return viewControllerFor(index: index + 1)
        }
        return nil
    }

}

extension StoriesViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        if let newIndex = (pendingViewControllers.first as? ContentViewController)?.index {
            currentIndex = newIndex
        }
    }
}
