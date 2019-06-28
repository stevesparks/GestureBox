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

    var label = UILabel()

    func setup() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        addConstraints([
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.centerXAnchor.constraint(equalTo: centerXAnchor)
            ])
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = .white

        addGestureRecognizers()
    }


    func addGestureRecognizers() {
        addGestureRecognizer(tap)
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

    lazy var tap = MyTapGestureRecognizer(target: self, action: #selector(didTap(_:)))
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

    func setLabelText(_ text: String, _ color: UIColor = .white) {
        label.text = text
        label.backgroundColor = color
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            guard text == self.label.text else { return }
            self.label.backgroundColor = .clear
            self.label.text = ""
        }
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

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! GRCollectionViewCell
        let gr: UIGestureRecognizer = {
            switch indexPath.row {
            case 0: return tap
            case 1: return pan
            case 2: return pinch
            case 3: return spin
            case 4: return swipeLeft
            case 5: return swipeRight
            case 6: return swipeUp
            case 7: return swipeDown
            case 8: return force
            default: return tap
            }
        }()
        cell.gestureRecognizer = gr
        return cell
    }


}

extension GestureView: UICollectionViewDelegate {

}
