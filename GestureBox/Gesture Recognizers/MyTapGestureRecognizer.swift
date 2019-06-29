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

    override func require(toFail otherGestureRecognizer: UIGestureRecognizer) {
        print("Failing -> \(otherGestureRecognizer)")
        super.require(toFail: otherGestureRecognizer)
    }
    
    var recognizerName: String? {
        let fingerCount: String = {
            switch numberOfTouchesRequired {
            case 1: return ""
            case 2: return "2-finger "
            case 3: return "3-finger "
            default: return "4+-finger"
            }
        }()
        let tapCount: String = {
            switch numberOfTapsRequired {
            case 1: return ""
            case 2: return "Double-"
            case 3: return "Triple-"
            default: return ""
            }
        }()
        return "\(fingerCount)\(tapCount)Tap"
    }
    var recognizerDetails: String {
        return ""
    }
}
