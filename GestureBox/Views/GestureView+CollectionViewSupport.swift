//
//  GestureView+CollectionViewSupport.swift
//  GestureBox
//
//  Created by Steve Sparks on 6/30/19.
//  Copyright © 2019 SOG. All rights reserved.
//

import UIKit

extension GestureView: UICollectionViewDataSource {

    var items1: [UIGestureRecognizer] {
        return [
            self.tap1t1, self.tap1t2, self.tap1t3,
            self.tap2t1, self.tap2t2, self.tap2t3,
            self.tap3t1, self.tap3t2, self.tap3t3 ]
    }
    var items2: [UIGestureRecognizer] {
        return [
            self.pan, self.pinch, self.force,
            self.spin, self.longPress,
        ]
    }
    var items3: [UIGestureRecognizer] {
        return [
            self.swipeUpLeft,   self.swipeUp,   self.swipeUpRight,
            self.swipeLeft,     self.force,     self.swipeRight,
            self.swipeDownLeft, self.swipeDown, self.swipeDownRight
        ]
    }

    var itemGroups: [[UIGestureRecognizer]] {
        return [items1, items2, items3]
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return itemGroups.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let group = itemGroups[section]
        return group.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! GRCollectionViewCell
        let items = itemGroups[indexPath.section]
        let gr: UIGestureRecognizer = items[indexPath.row]
        cell.gestureRecognizer = gr
        return cell
    }

}

extension GestureView: UICollectionViewDelegate {

}
