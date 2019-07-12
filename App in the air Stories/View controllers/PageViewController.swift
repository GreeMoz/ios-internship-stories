//
//  PageViewController.swift
//  App in the air Stories
//
//  Created by Oleg Kornienko on 09.07.2019.
//  Copyright © 2019 Oleg Kornienko. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        for subview in view.subviews {
//            if let scrollView = subview as? UIScrollView {
//                scrollView.delegate = self
//            }
//        }
    }
    
}


//extension UIPageViewController: UIScrollViewDelegate {
//
//    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let point = scrollView.contentOffset
//        var percentComplete: CGFloat
//        percentComplete = abs(point.x - view.frame.size.width) / view.frame.size.width
//        print("percentComplete: \(percentComplete)")
//    }
//}
