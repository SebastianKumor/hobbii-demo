//
//  PDFCreator.swift
//  hobii-demo
//
//  Created by Sebastian Kumor on 19/10/2020.
//

import UIKit
import PDFKit

class PDFCreator: NSObject {
  let title: String
  let body: String

 
  
  init(title: String, body: String) {
    self.title = title
    self.body = body
   
  }
  
    func createFlyer() -> Data {
        // 1
        let pdfMetaData = [
            kCGPDFContextCreator: mainUser?.name ?? "app",
            kCGPDFContextAuthor: "hobbii-demo",
            kCGPDFContextTitle: title
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        // 2
        let pageWidth = 8.5 * 72.0
        let pageHeight = 11 * 72.0
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        
        // 3
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        // 4
        let data = renderer.pdfData { (context) in
            // 5
            context.beginPage()
            // 6
            let titleBottom = addTitle(pageRect: pageRect)
            addBodyText(pageRect: pageRect, textTop: titleBottom + 50)
        }
        
        return data
    }
  
  func addTitle(pageRect: CGRect) -> CGFloat {
    // 1
    let titleFont = UIFont.systemFont(ofSize: 18.0, weight: .bold)
    // 2
    let titleAttributes: [NSAttributedString.Key: Any] =
      [NSAttributedString.Key.font: titleFont]
    let attributedTitle = NSAttributedString(string: title, attributes: titleAttributes)
    // 3
    let titleStringSize = attributedTitle.size()
    // 4
    let titleStringRect = CGRect(x: (pageRect.width - titleStringSize.width) / 2.0,
                                 y: 36, width: titleStringSize.width,
                                 height: titleStringSize.height)
    // 5
    attributedTitle.draw(in: titleStringRect)
    // 6
    return titleStringRect.origin.y + titleStringRect.size.height
  }

  func addBodyText(pageRect: CGRect, textTop: CGFloat) {
    // 1
    let textFont = UIFont.systemFont(ofSize: 12.0, weight: .regular)
    // 2
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .natural
    paragraphStyle.lineBreakMode = .byWordWrapping
    // 3
    let textAttributes = [
      NSAttributedString.Key.paragraphStyle: paragraphStyle,
      NSAttributedString.Key.font: textFont
    ]
    let attributedText = NSAttributedString(string: body, attributes: textAttributes)
    // 4
    let textRect = CGRect(x: pageRect.width/4, y: textTop, width: pageRect.width/2,
                          height: pageRect.height - textTop - pageRect.height / 5.0)
    attributedText.draw(in: textRect)
  }
}
