//
//  MyGestureRecognizers.swift
//  GestureBox
//
//  Created by Steve Sparks on 6/27/19.
//  Copyright © 2019 SOG. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

protocol GestureRecognizerStateChangeListener: NSObjectProtocol {
    func stateDidChange(for gestureRecognizer: UIGestureRecognizer)
}

protocol GestureRecognizerStateChangeBroadcaster: NSObjectProtocol {
    var stateDelegate: GestureRecognizerStateChangeListener? { get set }
    var recognizerName: String? { get }
    var recognizerDetails: String { get }
}

extension GestureRecognizerStateChangeBroadcaster {
    var recognizerName: String? { return nil }
//    var details: String { return "" }
}

class MyLongPressGestureRecognizer: UILongPressGestureRecognizer, GestureRecognizerStateChangeBroadcaster {
    weak var stateDelegate: GestureRecognizerStateChangeListener?
    override var state: UIGestureRecognizer.State {
        didSet {
            stateDelegate?.stateDidChange(for: self)
        }
    }
    var recognizerDetails: String {
        return ""
    }
}


class MyPinchGestureRecognizer: UIPinchGestureRecognizer, GestureRecognizerStateChangeBroadcaster {
    weak var stateDelegate: GestureRecognizerStateChangeListener?
    override var state: UIGestureRecognizer.State {
        didSet {
            stateDelegate?.stateDidChange(for: self)
        }
    }

    var recognizerDetails: String {
        if state == .possible { return "" }
        let scale = Double(Int(self.scale * 100)) / 100.0
        return "\(scale)x"
    }
}

class MyRotationGestureRecognizer: UIRotationGestureRecognizer, GestureRecognizerStateChangeBroadcaster {
    weak var stateDelegate: GestureRecognizerStateChangeListener?
    override var state: UIGestureRecognizer.State {
        didSet {
            stateDelegate?.stateDidChange(for: self)
        }
    }
    var recognizerDetails: String {
        if state == .possible { return "" }
        let rot = rotation * (180.0 / CGFloat.pi)
        return "\(Int(rot))º"
    }
}

extension UIGestureRecognizer.State: CustomStringConvertible {
    public var description: String {
        switch self {
        case .began: return "Began"
        case .possible: return "possible"
        case .changed: return "changed"
        case .ended: return "recognized"
        case .cancelled: return "cancelled"
        case .failed: return "failed"
        }
    }

    var isTerminalState: Bool {
        switch self {
        case .cancelled, .failed, .ended: return true
        default: return false
        }
    }
}

extension UISwipeGestureRecognizer.Direction: CustomStringConvertible {
    public var description: String {
        switch self {
        case .up: return "up"
        case .down: return "down"
        case .left: return "left"
        case .right: return "right"
        default: return "derp \(self.rawValue)"
        }
    }
}

extension UIGestureRecognizer {
    var broadcasterName: String {
        if let c = self as? GestureRecognizerStateChangeBroadcaster,
            let name = c.recognizerName {
            return name
        }
        if self is UIPanGestureRecognizer { return "Pan" }
        if self is UITapGestureRecognizer { return "Tap" }
        if self is UIPinchGestureRecognizer { return "Pinch" }
        if self is UISwipeGestureRecognizer {
            guard let direction = (self as? UISwipeGestureRecognizer)?.direction else { return "Swipe" }
            var directions = [String]()
            if direction.contains(.up) { directions.append("Up") }
            if direction.contains(.down) { directions.append("Down") }
            if direction.contains(.left) { directions.append("Left") }
            if direction.contains(.right) { directions.append("Right") }

            switch directions.count {
            case 1:
                return directions.first ?? "Swipe"
            default:
                return "Swipe"
            }
        }
        if self is UIRotationGestureRecognizer { return "Rotate" }
        if self is UILongPressGestureRecognizer { return "Long Touch" }
        return "Unknown"
    }

    var details: String {
        if let c = self as? GestureRecognizerStateChangeBroadcaster {
            return c.recognizerDetails
        }
        return ""
    }

    private struct AssociatedKeys {
        static var GestureDelegateView = "gestureDelegateView"
    }

    var gestureDelegateView: GestureDelegateView {
        get {
            if let o = objc_getAssociatedObject(self, AssociatedKeys.GestureDelegateView) as? GestureDelegateView {
                return o
            } else {
                let v = GestureDelegateView(self)
                objc_setAssociatedObject(self, AssociatedKeys.GestureDelegateView, v, .OBJC_ASSOCIATION_RETAIN)
                return v
            }
        }
        set {
            objc_setAssociatedObject(self, AssociatedKeys.GestureDelegateView, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}
