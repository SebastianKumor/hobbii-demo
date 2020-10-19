//
//  Helpers.swift
//  hobii-demo
//
//  Created by Sebastian Kumor on 19/10/2020.
//

import UIKit

public class Helpers {
    
    public class func createSimpleAlert(in viewController: UIViewController, title: String, message:String,  completion: (() -> Void)? = nil){
        let alertController = UIAlertController(title: title, message:message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: {
                                            (action : UIAlertAction!) -> Void in
            completion?()
        })
        
        alertController.addAction(cancelAction)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
}
