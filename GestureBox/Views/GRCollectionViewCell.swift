//
//  GRCollectionViewCell.swift
//  GestureBox
//
//  Created by Steve Sparks on 6/28/19.
//  Copyright © 2019 SOG. All rights reserved.
//

import UIKit

class GRCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel! {
        didSet {
            nameLabel.textColor = .white
        }
    }
    @IBOutlet weak var stateLabel: UILabel! {
        didSet {
            stateLabel.textColor = .white
        }
    }
    @IBOutlet weak var detailsLabel: UILabel! {
        didSet {
            detailsLabel.textColor = .white
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.red.withAlphaComponent(0.5)
        let l = layer
        l.borderColor = UIColor.white.cgColor
        l.borderWidth = 2.0
        l.cornerRadius = 5.0
        // Initialization code
    }

    var gestureRecognizer: UIGestureRecognizer? {
        didSet {
            populate()
            if let rec = gestureRecognizer as? GestureRecognizerStateChangeBroadcaster {
                rec.stateDelegate = self
            } else {
                print("no")
            }
        }
    }

    func populate() {
        backgroundColor = gestureRecognizer?.stateColor ?? .clear
        if let rec = gestureRecognizer {
            nameLabel.text = rec.broadcasterName
            stateLabel.text = rec.state.description
            detailsLabel.text = ""
        } else {
            nameLabel.text = ""
            stateLabel.text = ""
            detailsLabel.text = ""
        }
    }
}

extension GRCollectionViewCell: GestureRecognizerStateChangeListener {
    func stateDidChange(for gestureRecognizer: UIGestureRecognizer) {
        populate()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.populate()
        }
    }

}
