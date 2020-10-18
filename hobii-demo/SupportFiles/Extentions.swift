//
//  Extentions.swift
//  hobii-demo
//
//  Created by Sebastian Kumor on 18/10/2020.
//

import UIKit


extension UIColor {
    
    convenience init(red: CGFloat, green: CGFloat, blue: CGFloat) {
        self.init(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0)
    }
    
//    convenience init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha:CGFloat) {
//        self.init(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0)
//    }
    
    struct CustomColor {
        static let buttonShadow = UIColor(red:208.0/255.0, green: 208.0/255.0, blue: 209.0/255.0, alpha: 1.0)
    }
}
