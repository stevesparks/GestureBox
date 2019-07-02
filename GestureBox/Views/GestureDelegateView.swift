//
//  GestureDelegateView.swift
//  GestureBox
//
//  Created by Steve Sparks on 6/26/19.
//  Copyright © 2019 SOG. All rights reserved.
//

import UIKit

class GestureDelegateView: UIView {
    var colorResetTimer: Timer?

    private var rec: UIGestureRecognizer? {
        didSet {
            if let rec = rec as? GestureRecognizerStateChangeBroadcaster {
                rec.stateDelegate = self
            } else {
                print("no")
            }
        }
    }
    var name: String = "" {
        didSet {
            label.text = name
        }
    }
    lazy var label: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .white
        lbl.font = UIFont.boldSystemFont(ofSize: 8.0)
        addSubview(lbl)
        addConstraints([
            lbl.centerXAnchor.constraint(equalTo: centerXAnchor),
            lbl.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        return lbl
    }()

    init(_ gestureRecognizer: UIGestureRecognizer) {
        super.init(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        self.rec = gestureRecognizer
        if let rec = rec as? GestureRecognizerStateChangeBroadcaster {
            rec.stateDelegate = self
        }
        self.name = gestureRecognizer.broadcasterName
        label.text = name

        let lyr = self.layer
        lyr.borderColor = UIColor.white.cgColor
        lyr.borderWidth = 2.0
        lyr.cornerRadius = 4.0
        addConstraint(widthAnchor.constraint(equalToConstant: 40))
        addConstraint(heightAnchor.constraint(equalToConstant: 30))
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension GestureDelegateView: GestureRecognizerStateChangeListener {
    func stateDidChange(for gestureRecognizer: UIGestureRecognizer) {
        setBackgroundColorFromState()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.setBackgroundColorFromState()
        }
    }

    func setBackgroundColorFromState() {
        if let rec = rec {
            backgroundColor = rec.stateColor
        } else {
            backgroundColor = .clear
        }
    }
}


extension UIGestureRecognizer {
    var stateColor: UIColor {
        switch state {
        case .possible: return .clear
        case .began: return .purple
        case .changed: return .blue
        case .ended: return .green
        case .failed: return UIColor(red: 0.4, green: 0, blue: 0, alpha: 1.0)
        case .cancelled: return .orange
        @unknown default:
            return .clear
        }
    }

    var stateTextColor: UIColor {
        switch state {
        case .possible, .began, .changed, .failed: return .white
        case .ended, .cancelled: return .black
        @unknown default:
            return .white
        }
    }

    var stateBorderColor: CGColor {
        switch state {
        case .began, .changed, .ended: return UIColor.white.cgColor
        @unknown default: return UIColor.darkGray.cgColor
        }
    }
}

