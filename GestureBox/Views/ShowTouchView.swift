//
//  ShowTouchView.swift
//  GestureBox
//
//  Created by Steve Sparks on 6/28/19.
//  Copyright © 2019 SOG. All rights reserved.
//

import UIKit

class ShowTouchView: UIView {
    class TouchLayer: CALayer {
        override init(layer: Any) {
            super.init(layer: layer)
            backgroundColor = UIColor.red.cgColor
            borderColor = UIColor.white.cgColor
            borderWidth = 2.0
        }

        override func layoutSublayers() {
            cornerRadius = fmin(frame.size.width, frame.size.height)/2.0
            super.layoutSublayers()
        }

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
    }

    var touches: Set<UITouch>? {
        didSet {
            redrawTouches()
        }
    }

    var touchLayers = [UITouch: TouchLayer]()

    var baseLayer = TouchLayer(layer: CALayer())
    func redrawTouches() {
        let localViewCache = touchLayers
        var newViews = [UITouch: TouchLayer]()
        for layer in touchLayers.values {
            layer.removeFromSuperlayer()
        }

        if let touches = touches {
            for touch in touches {
                let v = localViewCache[touch] ?? TouchLayer(layer: baseLayer)
                layer.addSublayer(v)
                let loc = touch.location(in: self)
                v.frame = CGRect(x: loc.x - 22, y: loc.y - 22, width: 44, height: 44)
                newViews[touch] = v
            }
        }
        let erase = localViewCache.values.drop { newViews.values.contains($0) }
        for layer in erase {
            layer.removeFromSuperlayer()
        }
        touchLayers = newViews
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touches = touches
        super.touchesBegan(touches, with: event)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touches = touches
        super.touchesMoved(touches, with: event)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touches = nil
        super.touchesEnded(touches, with: event)
    }
}
