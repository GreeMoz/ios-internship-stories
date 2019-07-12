//
//  ContentTextUpViewController.swift
//  App in the air Stories
//
//  Created by Oleg Kornienko on 11.07.2019.
//  Copyright © 2019 Oleg Kornienko. All rights reserved.
//

import UIKit

class ContentTextUpViewController: UIViewController, ContentViewControllerProtocol {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    
    var displayImage: UIImage?
    var displayTitle: String?
    var displayText: String?
    var textColor: UIColor?
    var backgroundColor: UIColor?
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    func setup() {
        imageView.image = displayImage
        titleLabel.text = displayTitle
        textLabel.text = displayText
        textLabel.textColor = textColor
        titleLabel.textColor = textColor
    }
    
}
