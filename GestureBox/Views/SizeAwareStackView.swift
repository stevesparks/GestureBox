//
//  SizeAwareStackView.swift
//  GestureBox
//
//  Created by Steve Sparks on 6/28/19.
//  Copyright © 2019 SOG. All rights reserved.
//

import UIKit

class SizeAwareStackView: UIStackView {
    enum Bias {
        case wide
        case narrow
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        installNotifier()
    }

    func installNotifier() {
        NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: .main) { note in
            self.resetDirection()
        }
        self.resetDirection()
    }

    var bias: Bias = .wide

    var biasedVerticalWide: NSLayoutConstraint.Axis {
        return bias == .wide ? .vertical : .horizontal
    }
    var biasedHorizontalWide: NSLayoutConstraint.Axis {
        return bias == .wide ? .horizontal : .vertical
    }

    func resetDirection() {
        switch (traitCollection.verticalSizeClass, traitCollection.horizontalSizeClass) {
        case (.regular, .compact):
            axis = biasedVerticalWide
        case (.compact, .regular):
            axis = biasedHorizontalWide
        default:
            setDirectionFromDeviceOrientation()
        }
    }

    func setDirectionFromDeviceOrientation() {
        axis = UIDevice.current.orientation.isLandscape ? biasedHorizontalWide : biasedVerticalWide
    }
}
