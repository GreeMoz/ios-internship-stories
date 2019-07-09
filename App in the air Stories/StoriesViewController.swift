//
//  StoriesViewController.swift
//  App in the air Stories
//
//  Created by Oleg Kornienko on 09.07.2019.
//  Copyright © 2019 Oleg Kornienko. All rights reserved.
//

import UIKit

class StoriesViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        setupGestures()
    }
    
    func setupGestures() {
        let closeGesture = UISwipeGestureRecognizer(target: self, action: #selector(close))
        closeGesture.direction = .down
        view.addGestureRecognizer(closeGesture)
    }

    @IBAction @objc func close(_ sender: Any) {
        dismiss(animated: true)
    }
}
