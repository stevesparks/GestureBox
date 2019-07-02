//
//  GRCollectionView.swift
//  GestureBox
//
//  Created by Steve Sparks on 6/28/19.
//  Copyright © 2019 SOG. All rights reserved.
//

import UIKit

class GRCollectionView: UICollectionView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let nib = UINib(nibName: "GRCollectionViewCell", bundle: nil)
        register(nib, forCellWithReuseIdentifier: "cell")
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if let c = collectionViewLayout as? UICollectionViewFlowLayout {
            c.scrollDirection = scrollDirection
        }
//        collectionViewLayout.
    }

    var scrollDirection: UICollectionView.ScrollDirection {
        let orientation = UIDevice.current.orientation
        switch orientation {
        case .landscapeLeft, .landscapeRight:
            return .horizontal
        case .unknown, .portrait, .portraitUpsideDown, .faceUp, .faceDown:
            return .vertical
        @unknown default:
            return .vertical
        }
    }
}
