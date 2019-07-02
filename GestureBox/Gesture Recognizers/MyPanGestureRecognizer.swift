//
//  MyPanGestureRecognizer.swift
//  GestureBox
//
//  Created by Steve Sparks on 6/28/19.
//  Copyright © 2019 SOG. All rights reserved.
//

import UIKit

class MyPanGestureRecognizer: UIPanGestureRecognizer, GestureRecognizerStateChangeBroadcaster {
    var willFailSwipes = false

    weak var stateDelegate: GestureRecognizerStateChangeListener?
    override var state: UIGestureRecognizer.State {
        didSet {
            stateDelegate?.stateDidChange(for: self)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        if self.state == .changed || self.state == .began {
            stateDelegate?.stateDidChange(for: self)
        }
    }

    // This allows both pan and swipe to activate
    override func canPrevent(_ preventedGestureRecognizer: UIGestureRecognizer) -> Bool {
        if preventedGestureRecognizer is UISwipeGestureRecognizer {
            return willFailSwipes
        }
        return super.shouldRequireFailure(of: preventedGestureRecognizer)
    }

//    override func canBePrevented(by preventingGestureRecognizer: UIGestureRecognizer) -> Bool {
//        if preventingGestureRecognizer is UISwipeGestureRecognizer {
//            return !willFailSwipes
//        }
//        return super.shouldBeRequiredToFail(by: preventingGestureRecognizer)
//    }

    var recognizerDetails: String {
        guard state != .possible && !state.isTerminalState else { return "" }
        let p = translation(in: nil)
        return "\(Int(p.x)), \(Int(p.y))"
    }
}

