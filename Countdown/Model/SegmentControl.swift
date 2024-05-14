//
//  SegmentControl.swift
//  Countdown
//
//  Created by Oğuzcan Beşerikli on 10.05.2024.
//

import UIKit

class SegmentControl: UISegmentedControl {
    
    
    private var segmentInset: CGFloat = 0.1 {
        didSet {
            if segmentInset == 0 {
                segmentInset = 0.1
            }
        }
    }
    
    override init(items: [Any]?) {
        super.init(items: items)
        selectedSegmentIndex = 0
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .systemGray
        self.layer.masksToBounds = true
        
        let selectedImageViewIndex = numberOfSegments
        
        if let selectedImageView = subviews[selectedImageViewIndex] as? UIImageView {
            selectedImageView.backgroundColor = .systemBlue
            selectedImageView.image = nil
            
            selectedImageView.bounds = selectedImageView.bounds.insetBy(dx: segmentInset, dy: segmentInset)
            
            selectedImageView.layer.masksToBounds = true
            
            selectedImageView.layer.removeAnimation(forKey: "SelectionBounds")
        }
    }
    
}
