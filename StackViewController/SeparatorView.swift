//
//  SeparatorView.swift
//  StackViewController
//
//  Created by Indragie Karunaratne on 2016-04-12.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import UIKit

/// A customizable separator view that can be displayed in horizontal and
/// vertical orientations.
open class SeparatorView: UIView {
    fileprivate var sizeConstraint: NSLayoutConstraint?
    
    /// The thickness of the separator. This is equivalent to the height for
    /// a horizontal separator and the width for a vertical separator.
    open var separatorThickness: CGFloat = 1.0 {
        didSet {
            sizeConstraint?.constant = separatorThickness
            setNeedsDisplay()
        }
    }
    
    /// The inset of the separator from the left (MinX) edge for a horizontal
    /// separator and from the bottom (MaxY) edge for a vertical separator.
    @available(*, deprecated)
    open var separatorInset: CGFloat = 15.0 {
        didSet { self.separatorInsets = UIEdgeInsets(top: 0, left: separatorInset, bottom: separatorInset, right: 0) }
    }

    open var separatorInsets: UIEdgeInsets = UIEdgeInsetsMake(0, 15.0, 15.0, 0) {
        didSet { setNeedsDisplay() }
    }
    
    /// The color of the separator
    open var separatorColor = UIColor(white: 0.90, alpha: 1.0) {
        didSet { setNeedsDisplay() }
    }
    
    /// The axis (horizontal or vertical) of the separator
    open var axis = UILayoutConstraintAxis.horizontal {
        didSet { updateSizeConstraint() }
    }
    
    /// Initializes the receiver for display on the specified axis.
    public init(axis: UILayoutConstraintAxis) {
        self.axis = axis
        super.init(frame: CGRect.zero)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    fileprivate func updateSizeConstraint() {
        sizeConstraint?.isActive = false
        let layoutAttribute: NSLayoutAttribute = {
            switch axis {
            case .horizontal: return .height
            case .vertical: return .width
            }
        }()
        sizeConstraint = NSLayoutConstraint(
            item: self,
            attribute: layoutAttribute,
            relatedBy: .equal,
            toItem: nil, attribute:
            .notAnAttribute,
            multiplier: 1.0,
            constant: separatorThickness
        )
        sizeConstraint?.isActive = true
    }
    
    fileprivate func commonInit() {
        backgroundColor = .clear
        updateSizeConstraint()
    }
    
    open override func draw(_ rect: CGRect) {
        guard separatorThickness > 0 else { return }
        let insets: UIEdgeInsets = {
            switch axis {
            case .horizontal: return UIEdgeInsets(top: 0, left: separatorInsets.left, bottom: 0, right: separatorInsets.right)
            case .vertical: return UIEdgeInsets(top: separatorInsets.top, left: 0, bottom: separatorInsets.bottom, right: 0)
            }
        }()
        let separatorRect = UIEdgeInsetsInsetRect(bounds, insets)
        separatorColor.setFill()
        UIRectFill(separatorRect)
    }
}
