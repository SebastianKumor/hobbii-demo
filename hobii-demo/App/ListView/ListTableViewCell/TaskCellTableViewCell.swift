//
//  TaskCellTableViewCell.swift
//  hobii-demo
//
//  Created by Sebastian Kumor on 18/10/2020.
//

import UIKit

protocol TaskCellTableViewCellDelegate : class {
    func createInvoiceClicked(project: Project)
}

class TaskCellTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var invoiceButton: UIButton!
    
    
    var project: Project?
    weak var delegate: TaskCellTableViewCellDelegate?
    
    @IBAction func invoiceButtonAction(_ sender: Any) {
        guard let project = self.project else {
            return
        }
        self.delegate?.createInvoiceClicked(project: project)
    }
    
    
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        self.contentView.backgroundColor = .white
        // Configure the view for the selected state
    }
    
    func populate(project: Project){
        self.project = project
        projectNameLabel.text = project.name
        hoursLabel.text = "hours spent: \(project.hours):\(project.minutes)"
        
        if project.isRunning {
            iconImage.image = UIImage(named: "ic_pause")
        }else{
            iconImage.image = UIImage(named: "ic_play")
        }
        
        if project.isArchived {
            iconImage.isHidden = true
        }
        
        if project.canMakeInvoice(){
            invoiceButton.isHidden = false
        }else{
            invoiceButton.isHidden = true
        }
    }
    
}
