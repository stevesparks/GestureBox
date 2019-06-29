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
        addGestureRecognizer(pan)
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
    lazy var tap1t1 = tapGestureRecognizer(taps: 1, touches: 1)
    lazy var tap1t2 = tapGestureRecognizer(taps: 1, touches: 2)
    lazy var tap1t3 = tapGestureRecognizer(taps: 1, touches: 3)
    lazy var tap2t1 = tapGestureRecognizer(taps: 2, touches: 1)
    lazy var tap2t2 = tapGestureRecognizer(taps: 2, touches: 2)
    lazy var tap2t3 = tapGestureRecognizer(taps: 2, touches: 3)
    lazy var tap3t1 = tapGestureRecognizer(taps: 3, touches: 1)
    lazy var tap3t2 = tapGestureRecognizer(taps: 3, touches: 2)
    lazy var tap3t3 = tapGestureRecognizer(taps: 3, touches: 3)

    lazy var pan: UIPanGestureRecognizer = {
        let pan = MyPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        
        return pan
    }()
    lazy var pinch = MyPinchGestureRecognizer(target: self, action: #selector(didPinch(_:)))
    lazy var spin = MyRotationGestureRecognizer(target: self, action: #selector(didSpin(_:)))
    lazy var swipeRight: UISwipeGestureRecognizer = {
        let ret = MySwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        ret.direction = .right
        return ret
    }()
    lazy var swipeLeft: UISwipeGestureRecognizer = {
        let ret = MySwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        ret.direction = .left
        return ret
    }()
    lazy var swipeUp: UISwipeGestureRecognizer = {
        let ret = MySwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        ret.direction = .up
        return ret
    }()
    lazy var swipeDown: UISwipeGestureRecognizer = {
        let ret = MySwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        ret.direction = .down
        return ret
    }()
    lazy var longPress: UILongPressGestureRecognizer = {
        let ret = MyLongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
        ret.minimumPressDuration = 3.0
        ret.allowableMovement = 40.0
        ret.numberOfTapsRequired = 1
        ret.numberOfTouchesRequired = 1
        return ret
    }()
    lazy var force: ForceTouchGestureRecognizer = {
        let force = ForceTouchGestureRecognizer(target: self, action: #selector(didForce(_:)))
        return force
    }()

    var tapCount = 0
    @objc func didTap(_ sender: UITapGestureRecognizer) {
        tapCount = tapCount + 1
        setLabelText("TAP \(tapCount)", sender.stateColor)
    }
    @objc func didSpin(_ sender: UIRotationGestureRecognizer) {
        let rot = sender.rotation * (180.0 / CGFloat.pi)
        setLabelText("\(sender.broadcasterName)  \(Int(rot))º", sender.stateColor)
    }
    @objc func didSwipe(_ sender: UISwipeGestureRecognizer) {
        setLabelText("\(sender.broadcasterName)", sender.stateColor)
    }
    @objc func didLongPress(_ sender: UILongPressGestureRecognizer) {
        setLabelText("\(sender.broadcasterName)", sender.stateColor)
    }
    @objc func didPinch(_ sender: UIPinchGestureRecognizer) {
        let scale = Double(Int(sender.scale * 100)) / 100.0
        setLabelText("\(sender.broadcasterName)  \(scale)x", sender.stateColor)
    }
    @objc func didPan(_ sender: UIPanGestureRecognizer) {
        let point = sender.translation(in: self)
        let pan = "\(Int(point.x)), \(Int(point.y))"
        setLabelText("\(sender.broadcasterName) \(pan)", sender.stateColor)
    }
    @objc func didForce(_ sender: ForceTouchGestureRecognizer) {
        setLabelText("\(sender.broadcasterName)", sender.stateColor)
    }


    func setup() {
        addGestureRecognizers()
    }

    func setLabelText(_ text: String, _ color: UIColor = .white) {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 24)
//        label.textColor = .white
//        label.text = text
//
//        let centerY = label.centerYAnchor.constraint(equalTo: centerYAnchor)
//        let centerX = label.centerXAnchor.constraint(equalTo: centerXAnchor)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(label)
//        addConstraints([centerY, centerX])
//        label.backgroundColor = color
    }
}

extension GestureView: UICollectionViewDataSource {
    enum Items: CaseIterable {
        case tap
        case pan
        case pinch
        case spin
        case swipeLeft, swipeRight, swipeUp, swipeDown
        case force
    }

    var items: [UIGestureRecognizer] { return
        [
            self.tap1t1, self.tap1t2, self.tap1t3,
            self.tap2t1, self.tap2t2, self.tap2t3,
            self.tap3t1, self.tap3t2, self.tap3t3,
            self.pan, self.swipeUp, self.pinch,
            self.swipeLeft, self.force, self.swipeRight,
            self.spin, self.swipeDown, self.longPress
        ]

    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! GRCollectionViewCell
        let gr: UIGestureRecognizer = items[indexPath.row]
        cell.gestureRecognizer = gr
        return cell
    }
}

extension GestureView: UICollectionViewDelegate {

}
