//
//  PageControlView.swift
//  App in the air Stories
//
//  Created by Oleg Kornienko on 10.07.2019.
//  Copyright © 2019 Oleg Kornienko. All rights reserved.
//

import UIKit

class PageControlView: UIView {
    var numberOfPages: Int = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var currentIndex: Int = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var sideSpacing: CGFloat = 10 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var spacing: CGFloat = 10 {
        didSet {
            setNeedsDisplay()
        }
    }

    override func prepareForInterfaceBuilder() {
        setNeedsDisplay()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        
        ctx.setLineCap(.round)
        ctx.setLineWidth(5)
        ctx.setStrokeColor(UIColor.gray.cgColor)
        
        let length = rect.size.width - sideSpacing * 2
        let pageLength = (length - spacing * (CGFloat(numberOfPages) - 1)) / CGFloat(numberOfPages)
        
        var currentLoaction = sideSpacing
        
        for _ in 1...numberOfPages {
            ctx.move(to: CGPoint(x: currentLoaction, y: rect.midY))
            ctx.addLine(to: CGPoint(x: currentLoaction + pageLength, y: rect.midY))
            currentLoaction += pageLength + spacing
        }
        
        ctx.strokePath()
        
        ctx.setStrokeColor(UIColor.white.cgColor)
        
        currentLoaction = sideSpacing
        
        for _ in 1...currentIndex {
            ctx.move(to: CGPoint(x: currentLoaction, y: rect.midY))
            ctx.addLine(to: CGPoint(x: currentLoaction + pageLength, y: rect.midY))
            currentLoaction += pageLength + spacing
        }
        
        ctx.strokePath()
        
    }
    

}
