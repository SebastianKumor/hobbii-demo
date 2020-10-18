//
//  LoginViewController.swift
//  hobii-demo
//
//  Created by Sebastian Kumor on 18/10/2020.
//

import UIKit

protocol LoginDelegate: class {
    func didCreateUser(name: String)
}

class LoginViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    weak var delegate: LoginDelegate?
    
    
    @IBAction func createUserAction(_ sender: Any) {
        validateUsername()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func setupViews(){
        self.textfield.placeholder = "Username"
    }
    
    func validateUsername(){
        guard let text = textfield.text else{
            return
        }
        if text.isEmpty {
            //show error
            self.textfield.shake()
            self.errorLabel.isHidden = false
        }else{
            self.delegate?.didCreateUser(name: text)
        }
    }
}

extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}
