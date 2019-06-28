//
//  MySwipeGestureRecognizer.swift
//  GestureBox
//
//  Created by Steve Sparks on 6/28/19.
//  Copyright © 2019 SOG. All rights reserved.
//

import UIKit

class MySwipeGestureRecognizer: UISwipeGestureRecognizer, GestureRecognizerStateChangeBroadcaster {
    var willFailPans: Bool = false

    weak var stateDelegate: GestureRecognizerStateChangeListener?
    override var state: UIGestureRecognizer.State {
        didSet {
            stateDelegate?.stateDidChange(for: self)
        }
    }

    override func shouldRequireFailure(of otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if otherGestureRecognizer is UIPanGestureRecognizer {
            return willFailPans
        }
        return super.shouldRequireFailure(of: otherGestureRecognizer)
    }

    override func shouldBeRequiredToFail(by otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if otherGestureRecognizer is UIPanGestureRecognizer {
            return !willFailPans
        }
        return super.shouldBeRequiredToFail(by: otherGestureRecognizer)
    }
}
