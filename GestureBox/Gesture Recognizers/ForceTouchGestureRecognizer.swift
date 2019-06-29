//
//  ForceTouchGestureRecognizer.swift
//  GestureBox
//
//  Created by Steve Sparks on 6/27/19.
//  Copyright © 2019 SOG. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

class ForceTouchGestureRecognizer: UIGestureRecognizer {
    var minimumForceToActivate: CGFloat = 3.0
    var currentForce: CGFloat = 0.0
    var cancelsIfTouchLightens = false
    weak var stateDelegate: GestureRecognizerStateChangeListener?

    private var trackingTouch: UITouch?

    func checkPressure(on touch: UITouch) {
        if let now = trackingTouch, touch == now {
            currentForce = touch.force
        } else if state == .possible || state.isTerminalState {
            currentForce = touch.force
        }
        switch state {
        case .possible:
            if touch.force > minimumForceToActivate {
                trackingTouch = touch
                state = .began
            }
        case .began, .changed:
            if trackingTouch == touch, touch.force < minimumForceToActivate {
                state = cancelsIfTouchLightens ? .cancelled : .ended
                trackingTouch = nil
            }
        case .ended, .failed, .cancelled:
            state = .possible
            reset()
        }
    }

    // -
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        for f in touches {
            checkPressure(on: f)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        if let t = trackingTouch, touches.contains(t) {
            checkPressure(on: t)
        } else {
            for f in touches {
                checkPressure(on: f)
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        if let t = trackingTouch, touches.contains(t) {
            state = (state == .changed) ? .ended : .cancelled
            trackingTouch = nil
        }
        super.touchesEnded(touches, with: event)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        if let t = trackingTouch, touches.contains(t) {
            state = (state == .changed) ? .ended : .cancelled
        }
        super.touchesCancelled(touches, with: event)
    }
}

extension ForceTouchGestureRecognizer: GestureRecognizerStateChangeBroadcaster {
    override var state: UIGestureRecognizer.State {
        didSet {
            stateDelegate?.stateDidChange(for: self)
            if state.isTerminalState {
                trackingTouch = nil
            }
        }
    }
    var recognizerName: String? { return "Force" }
    var recognizerDetails: String {
        if state == .possible || state.isTerminalState { return "" }
        return "\(Double(Int(currentForce * 100)) / 100.0)"
    }
}
