//
//  ViewController.swift
//  hobii-demo
//
//  Created by Sebastian Kumor on 17/10/2020.
//

import UIKit

var mainUser: User?

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(saveUser), name: UIScene.willDeactivateNotification, object: nil)
        
        if UserDefaults.standard.object(forKey: "savedUser") != nil{
            self.loadUser()
        }
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkIfUserExists()
    }
    
    func checkIfUserExists(){
        // create user if none exists
        if UserDefaults.standard.object(forKey: "savedUser") == nil{
            let loginVc = LoginViewController()
            loginVc.delegate = self
            loginVc.modalPresentationStyle = .fullScreen
            self.present(loginVc, animated: true, completion: nil)
        }
    }
}

extension MainViewController {
    @objc func saveUser(){
        
        guard let user = mainUser else{
            return
        }
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(DateFormatter.dayDateFormat)
        if let encoded = try? encoder.encode(user) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "savedUser")
            defaults.synchronize()
        }
    }
    
    @objc func loadUser(){
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.dayDateFormat)
        
        if let storedObjectives =  UserDefaults.standard.object(forKey: "savedUser") as? Data {
            
            do {
                let storedUser = try decoder.decode(User.self, from: storedObjectives) 
                    //if let user = NSKeyedUnarchiver.unarchiveObject(with: savedPerson) as? UserModel{
                mainUser = storedUser
            } catch let error {
                print("JSON error: \(error)")
            }
           
        }
    }
}

extension MainViewController : LoginDelegate {
    func didCreateUser(name: String) {
        mainUser = User(name: name)
        self.saveUser()
        self.dismiss(animated: true) {}
    }
}

extension DateFormatter {

    static let dayDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()

}
