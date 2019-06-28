//
//  ViewController.swift
//  GestureBox
//
//  Created by Steve Sparks on 6/25/19.
//  Copyright © 2019 SOG. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var gestureView: GestureView!
    @IBOutlet weak var topStack: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

//        topStack.addArrangedSubview(gestureView.pan.gestureDelegateView)
//        topStack.addArrangedSubview(gestureView.tap.gestureDelegateView)
//        topStack.addArrangedSubview(gestureView.pinch.gestureDelegateView)
//        topStack.addArrangedSubview(gestureView.spin.gestureDelegateView)
//        topStack.addArrangedSubview(gestureView.swipeUp.gestureDelegateView)
//        topStack.addArrangedSubview(gestureView.swipeLeft.gestureDelegateView)
//        topStack.addArrangedSubview(gestureView.swipeDown.gestureDelegateView)
//        topStack.addArrangedSubview(gestureView.swipeRight.gestureDelegateView)
//        topStack.addArrangedSubview(gestureView.longPress.gestureDelegateView)
//        topStack.addArrangedSubview(gestureView.force.gestureDelegateView)
    }
}

extension NSObject {
    var _appName: String { return Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String }
    var _className: String { return String(describing: type(of: self)) }

    func report(_ message: String = "", _ preambleStr: String? = nil, function: String = #function) {
        let preamble = preambleStr ?? _appName
        print("\(preamble) \(_className) \(function) \(message) ")
    }
}
