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
    var textColor: UIColor = .white {
        didSet {
            nameLabel.textColor = textColor
            stateLabel.textColor = textColor
            detailsLabel.textColor = textColor
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.red.withAlphaComponent(0.5)
        let l = layer
        l.borderColor = UIColor.darkGray.cgColor
        l.borderWidth = 2.0
        l.cornerRadius = 5.0
        // Initialization code
    }

    var gestureRecognizer: UIGestureRecognizer? {
        didSet {
            if let rec = gestureRecognizer {
                rec.addTarget(self, action: #selector(gestureRecognizerAction(_:)))
            }
            populate()
            if let rec = gestureRecognizer as? GestureRecognizerStateChangeBroadcaster {
                rec.stateDelegate = self
            } else {
                print("no")
            }
        }
    }

    @objc func gestureRecognizerAction(_ sender: UIGestureRecognizer) {
        populate()
    }

    func populate() {
        if let rec = gestureRecognizer {
            backgroundColor = rec.stateColor
            layer.borderColor = rec.stateBorderColor
            textColor = rec.stateTextColor
            nameLabel.text = rec.broadcasterName
            stateLabel.text = rec.state.description
            detailsLabel.text = rec.details
        } else {
            backgroundColor = .clear
            layer.borderColor = UIColor.darkGray.cgColor
            textColor = .white
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
