//
//  TaskCellTableViewCell.swift
//  hobii-demo
//
//  Created by Sebastian Kumor on 18/10/2020.
//

import UIKit

class TaskCellTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    
    
   
    
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
        self.projectNameLabel.text = project.name
        self.hoursLabel.text = "hours spent: \(project.hours):\(project.minutes)"
        
        if project.isRunning {
            self.iconImage.image = UIImage(named: "ic_pause")
        }else{
            self.iconImage.image = UIImage(named: "ic_play")
        }
        
        if project.isArchived {
            self.iconImage.isHidden = true
        }
    }
    
}
