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
    
    public class func createPDF(in viewController: UIViewController,with project: Project, completion: (() -> Void)){
        guard let projects = mainUser?.projects else {
            return
        }
        
        var updatedProject = project
        
        for (index,project) in projects.enumerated() {
            if project.name == updatedProject.name && updatedProject.isRunning {
                updatedProject.pauseDate = Date()
                updatedProject.calculateHours()
                updatedProject.isRunning = false
                updatedProject.playDate = nil
                mainUser?.projects?[index] = updatedProject
                completion()
            }
        }
        
        let pdfVc = PDFPreviewViewController()
        
        
        let pdfCreator = PDFCreator(title: "\(updatedProject.name) Invoice", body: "You are due \( String(format: "%.2f", updatedProject.calculatePrice(rate: mainUser?.baseCharge ?? 100))) DKK to \(mainUser?.name ?? "User")")
        
        pdfVc.documentData = pdfCreator.createFlyer()
        
        viewController.present(pdfVc, animated: true, completion:nil)
    }
}
