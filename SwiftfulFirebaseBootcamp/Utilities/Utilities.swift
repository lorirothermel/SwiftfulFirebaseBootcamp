//
//  Utilities.swift
//  SwiftfulFirebaseBootcamp
//
//  Created by Lori Rothermel on 5/18/23.
//

import Foundation
import UIKit


final class Utilities {
    static let shared = Utilities()
    private init() { }
    
    @MainActor
    func topViewController(controller: UIViewController? = nil) -> UIViewController? {

        let controller = controller ?? UIApplication.shared.keyWindow?.rootViewController
        
            if let navigationController = controller as? UINavigationController {
                return topViewController(controller: navigationController.visibleViewController)

            } else if let tab = controller as? UITabBarController, let selected = tab.selectedViewController {
                return topViewController(controller: selected)

            } else if let presented = controller?.presentedViewController {
                return topViewController(controller: presented)
            }
            return controller
        }


    
    
}




