//
//  PDFPreviewViewController.swift
//  hobii-demo
//
//  Created by Sebastian Kumor on 19/10/2020.
//

import UIKit
import PDFKit

class PDFPreviewViewController: UIViewController {
    
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var pdfView: PDFView!
    public var documentData: Data?
    
    @IBAction func shareButtonAction(_ sender: Any) {
        
        guard let document = documentData else{
            Helpers.createSimpleAlert(in: self, title: "Error", message: "Somethinbg went wrong while creating pdf document")
            return
        }
        let vc = UIActivityViewController(activityItems: [document], applicationActivities: [])
        present(vc, animated: true, completion: nil)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let data = documentData {
          pdfView.document = PDFDocument(data: data)
          pdfView.autoScales = true
        }
    }

}
