//
//  StateMachine.swift
//  GestureBox
//
//  Created by Steve Sparks on 6/29/19.
//  Copyright © 2019 SOG. All rights reserved.
//

import UIKit

extension UIGestureRecognizer.State {
    func canMove(to newState: UIGestureRecognizer.State) -> Bool {
        guard self != newState else { return false }

        switch (self, newState) {
        case (.began, let new):      // ... said, don't look back.
            return new != .possible  // You can never go back.
        case (.possible, .began),    // You can begin.
             (.possible, .failed),   // You can go straight to failure.
             (.possible, .ended),    // You can go straight to ACTION!

             (.changed, .cancelled), // Nevermind.
             (.changed, .failed),    // Someone else succeeded.
             (.changed, .ended),     // Success!

             (.ended, .possible),    // Each of these is a state
             (.cancelled, .possible),// with the pow'r to reincarnate.
             (.failed, .possible):   // If they wish, that's just great.
            return true
        case (.changed, _), // Fail states.
             (_, .possible),
             (_, .changed),
             (_, .ended),
             (_, .cancelled),
             (_, .began),
             (_, .failed):
            return false
        @unknown default:
            break
        }
        return false
    }
}

protocol UIGestureRecognizerStateMachineDelegate {
    func stateMachineDidSetState()
}

extension UIGestureRecognizer {
    enum StateError: Error {
        case invalidStateTransition
    }

    class StateMachine {
        var delegate: UIGestureRecognizerStateMachineDelegate?

        let parent: UIGestureRecognizer!
        private(set) var state: UIGestureRecognizer.State {
            get {
                return parent.state
            }
            set {
                parent.state = newValue
                delegate?.stateMachineDidSetState()
            }
        }

        init(parent: UIGestureRecognizer) {
            self.parent = parent
        }

        func setState(_ newState: State) throws {
            if state.canMove(to: newState) {
                state = newState
            } else {
                throw StateError.invalidStateTransition
            }
        }

        // shortcuts

        func fail() {
            if state == .failed { return }
            if state.canMove(to: .failed) {
                state = .failed
                return
            }
            // can't fail here. :(
        }

        func complete() {
            if state.canMove(to: .ended) {
                state = .ended
                return
            }
        }
    }
}
