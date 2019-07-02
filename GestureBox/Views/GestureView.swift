//
//  GestureView.swift
//  GestureBox
//
//  Created by Steve Sparks on 6/26/19.
//  Copyright © 2019 SOG. All rights reserved.
//

import UIKit

class GestureView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        addGestureRecognizers()
    }

    func addGestureRecognizers() {
        addGestureRecognizer(tap1t1)
        addGestureRecognizer(tap1t2)
        addGestureRecognizer(tap1t3)
        addGestureRecognizer(tap2t1)
        addGestureRecognizer(tap2t2)
        addGestureRecognizer(tap2t3)
        addGestureRecognizer(tap3t1)
        addGestureRecognizer(tap3t2)
        addGestureRecognizer(tap3t3)
//        addGestureRecognizer(pan)   // added by the bool below
        addGestureRecognizer(pinch)
        addGestureRecognizer(spin)
        addGestureRecognizer(swipeLeft)
        addGestureRecognizer(swipeRight)
        addGestureRecognizer(swipeUp)
        addGestureRecognizer(swipeDown)
        addGestureRecognizer(longPress)
        addGestureRecognizer(force)
    }

    func tapGestureRecognizer(taps: Int, touches: Int) -> MyTapGestureRecognizer {
        let tap = MyTapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        tap.numberOfTapsRequired = taps
        tap.numberOfTouchesRequired = touches
        return tap
    }

    func swipeGestureRecognizer(_ direction: UISwipeGestureRecognizer.Direction) -> MySwipeGestureRecognizer {
        let ret = MySwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        ret.direction = direction
        return ret
    }

    lazy var tap1t1 = tapGestureRecognizer(taps: 1, touches: 1)
    lazy var tap1t2 = tapGestureRecognizer(taps: 1, touches: 2)
    lazy var tap1t3 = tapGestureRecognizer(taps: 1, touches: 3)
    lazy var tap2t1 = tapGestureRecognizer(taps: 2, touches: 1)
    lazy var tap2t2 = tapGestureRecognizer(taps: 2, touches: 2)
    lazy var tap2t3 = tapGestureRecognizer(taps: 2, touches: 3)
    lazy var tap3t1 = tapGestureRecognizer(taps: 3, touches: 1)
    lazy var tap3t2 = tapGestureRecognizer(taps: 3, touches: 2)
    lazy var tap3t3 = tapGestureRecognizer(taps: 3, touches: 3)

    lazy var pan = MyPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
    lazy var pinch = MyPinchGestureRecognizer(target: self, action: #selector(didPinch(_:)))
    lazy var spin = MyRotationGestureRecognizer(target: self, action: #selector(didSpin(_:)))

    lazy var swipeRight = swipeGestureRecognizer(.right)
    lazy var swipeLeft = swipeGestureRecognizer(.left)
    lazy var swipeUp = swipeGestureRecognizer(.up)
    lazy var swipeDown = swipeGestureRecognizer(.down)

    lazy var swipeUpLeft = swipeGestureRecognizer([.up, .left])
    lazy var swipeUpRight = swipeGestureRecognizer([.up, .right])
    lazy var swipeDownLeft = swipeGestureRecognizer([.down, .left])
    lazy var swipeDownRight = swipeGestureRecognizer([.down, .right])

    lazy var longPress: UILongPressGestureRecognizer = {
        let ret = MyLongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
        ret.minimumPressDuration = 3.0
        ret.allowableMovement = 40.0
        ret.numberOfTapsRequired = 1
        ret.numberOfTouchesRequired = 1
        return ret
    }()
    lazy var force = ForceTouchGestureRecognizer(target: self, action: #selector(didForce(_:)))
    
    var tapCount = 0
    @objc func didTap(_ sender: UITapGestureRecognizer) {
        tapCount = tapCount + 1
        eventReceived("TAP \(tapCount)", sender.stateColor)
    }
    @objc func didSpin(_ sender: UIRotationGestureRecognizer) {
        let rot = sender.rotation * (180.0 / CGFloat.pi)
        eventReceived("\(sender.broadcasterName)  \(Int(rot))º", sender.stateColor)
    }
    @objc func didSwipe(_ sender: UISwipeGestureRecognizer) {
        eventReceived("\(sender.broadcasterName)", sender.stateColor)
    }
    @objc func didLongPress(_ sender: UILongPressGestureRecognizer) {
        eventReceived("\(sender.broadcasterName)", sender.stateColor)
    }
    @objc func didPinch(_ sender: UIPinchGestureRecognizer) {
        let scale = Double(Int(sender.scale * 100)) / 100.0
        eventReceived("\(sender.broadcasterName)  \(scale)x", sender.stateColor)
    }
    @objc func didPan(_ sender: UIPanGestureRecognizer) {
        let point = sender.translation(in: self)
        let pan = "\(Int(point.x)), \(Int(point.y))"
        eventReceived("\(sender.broadcasterName) \(pan)", sender.stateColor)
    }
    @objc func didForce(_ sender: ForceTouchGestureRecognizer) {
        eventReceived("\(sender.broadcasterName)", sender.stateColor)
    }

    func eventReceived(_ text: String, _ color: UIColor = .white) {

    }

    var willPan: Bool = false {
        willSet {
            if willPan != newValue {
                if newValue {
                    addGestureRecognizer(pan)
                } else {
                    removeGestureRecognizer(pan)
                }
            }
        }
    }

    var allowDiagonalSwipes = false {
        willSet {
            if allowDiagonalSwipes != newValue {
                if newValue {
                    addGestureRecognizer(swipeUpLeft)
                    addGestureRecognizer(swipeUpRight)
                    addGestureRecognizer(swipeDownLeft)
                    addGestureRecognizer(swipeDownRight)
                } else {
                    removeGestureRecognizer(swipeUpLeft)
                    removeGestureRecognizer(swipeUpRight)
                    removeGestureRecognizer(swipeDownLeft)
                    removeGestureRecognizer(swipeDownRight)
                }
            }
        }
    }
}
