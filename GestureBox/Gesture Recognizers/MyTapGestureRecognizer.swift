//
//  MyTapGestureRecognizer.swift
//  GestureBox
//
//  Created by Steve Sparks on 6/28/19.
//  Copyright © 2019 SOG. All rights reserved.
//

import UIKit

class MyTapGestureRecognizer: UITapGestureRecognizer, GestureRecognizerStateChangeBroadcaster {
    weak var stateDelegate: GestureRecognizerStateChangeListener?
    override var state: UIGestureRecognizer.State {
        didSet {
            stateDelegate?.stateDidChange(for: self)
        }
    }

    // This allows both pan and swipe to activate
    override func canPrevent(_ preventedGestureRecognizer: UIGestureRecognizer) -> Bool {
        if let _ = preventedGestureRecognizer as? UILongPressGestureRecognizer {
            return false
        }
        return super.shouldRequireFailure(of: preventedGestureRecognizer)
    }

    override func canBePrevented(by preventingGestureRecognizer: UIGestureRecognizer) -> Bool {
        if let _ = preventingGestureRecognizer as? UILongPressGestureRecognizer {
            return true
        }
        return super.shouldBeRequiredToFail(by: preventingGestureRecognizer)
    }
}
