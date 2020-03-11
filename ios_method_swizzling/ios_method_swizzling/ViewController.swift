//
//  ViewController.swift
//  ios_method_swizzling
//
//  Created by James on 3/10/20.
//  Copyright © 2020 James. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

// MARK: - Extension: UIViewController Swizzle viewDidLoad -

extension UIViewController {
    
    class func swizzleViewDidLoad () {
    
        guard self === UIViewController.self else { return }  // use base class to swizzle all subclasses
        
        let originalMethod = class_getInstanceMethod(self, #selector(viewDidLoad))
        let swizzledMethod = class_getInstanceMethod(self, #selector(UIViewController.newViewDidLoad))
        
        method_exchangeImplementations(originalMethod!, swizzledMethod!)
    }
    
    @objc func newViewDidLoad () {
        view.applyAccessibilityIdToSubviews(viewController: self, view: view)
    }
}

// MARK: - Extension: UIView Set Accessibility Identifiers (ie: for automation) -

extension UIView {
    
    func applyAccessibilityIdToSubviews(viewController: UIViewController, view: UIView, index: Int = 0) {
        
        let viewControllerPrefix = String(describing: type(of: viewController))
        let delimeter = view.description.firstIndex(of: ":") ?? view.description.endIndex
        let accessID = view.accessibilityIdentifier ?? ""
        
        if accessID.isEmpty {
            view.accessibilityIdentifier = viewControllerPrefix + "." + view.description[view.description.index(after: view.description.startIndex)..<delimeter] + "." + String(index) + "." + "\(type(of: view))"
        }
        
        print("\n - view.accessibilityIdentifier: ", view.accessibilityIdentifier ?? "")
        
        if view.subviews.count > 0 {
            
            for (i, subview) in view.subviews.enumerated() {
                applyAccessibilityIdToSubviews(viewController: viewController, view: subview, index: index + i)
            }
        }
    }
}
