//
//  ViewController.swift
//  App in the air Stories
//
//  Created by Oleg Kornienko on 09.07.2019.
//  Copyright © 2019 Oleg Kornienko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func openStories(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: String(describing: StoriesViewController.self)) {
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
    }
    
}

