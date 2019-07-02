//
//  ViewController.swift
//  GestureBox
//
//  Created by Steve Sparks on 6/25/19.
//  Copyright © 2019 SOG. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var panImageView: UIImageView! {
        didSet {
            panImageView.alpha = gestureView.willPan ? 1.0 : 0.3
        }
    }
    @IBOutlet weak var swipeImageView: UIImageView!

    @IBOutlet weak var allowPanButton: UIButton! {
        didSet {
            if let b = allowPanButton {
            }

        }
    }
    @IBOutlet weak var allowDiagonalsButton: UIButton! {
        didSet {
            if let b = allowDiagonalsButton {
            }
        }
    }
    @IBOutlet weak var allowStrictButton: UIButton!

    @IBOutlet weak var gestureView: GestureView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func didTapAllowPan(_ sender: Any) {
        gestureView.willPan = !gestureView.willPan
        allowPanButton.isSelected = gestureView.willPan
        panImageView.alpha = gestureView.willPan ? 1.0 : 0.3
    }

    @IBAction func didTapAllowDiagonals(_ sender: Any) {
        gestureView.allowDiagonalSwipes = !gestureView.allowDiagonalSwipes
        if gestureView.allowDiagonalSwipes {
            swipeImageView.image = UIImage(named: "8-direction")
        } else {
            swipeImageView.image = UIImage(named: "4-direction")
        }
    }

    @IBAction func didTapAllowStrict(_ sender: Any) {

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
