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

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
