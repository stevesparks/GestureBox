//
//  ShowTouchView.swift
//  GestureBox
//
//  Created by Steve Sparks on 6/28/19.
//  Copyright © 2019 SOG. All rights reserved.
//

import UIKit

class ShowTouchView: UIView {
    class TouchView: UIView {
        init() {
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            self.backgroundColor = .red
            addConstraint(widthAnchor.constraint(equalTo: heightAnchor))
            addConstraint(widthAnchor.constraint(equalToConstant: 44))
        }

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            translatesAutoresizingMaskIntoConstraints = false
            addConstraint(widthAnchor.constraint(equalTo: heightAnchor))
            addConstraint(widthAnchor.constraint(equalToConstant: 44))
        }

        override func layoutSubviews() {
            super.layoutSubviews()
        }
    }

    var touches: Set<UITouch>? {
        didSet {
            redrawTouches()
        }
    }

    var touchViews = [UITouch: TouchView]()

    func redrawTouches() {
        let localViewCache = touchViews
        var newViews = [UITouch: TouchView]()
        for view in touchViews.values {
            view.removeFromSuperview()
        }

        if let touches = touches {
            for touch in touches {
                let v = localViewCache[touch] ?? TouchView()
                addSubview(v)
                let loc = touch.location(in: self)
                addConstraints([
                    v.centerXAnchor.constraint(equalTo: leftAnchor, constant: loc.x),
                    v.centerYAnchor.constraint(equalTo: topAnchor, constant: loc.y)
                    ])
                newViews[touch] = v
            }
        }
        touchViews = newViews
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
