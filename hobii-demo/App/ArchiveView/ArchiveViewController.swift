//
//  ArchiveViewController.swift
//  hobii-demo
//
//  Created by Sebastian Kumor on 18/10/2020.
//

import UIKit

class ArchiveViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var archiedProjects: [Project] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.register(UINib(nibName: "TaskCellTableViewCell", bundle: nil), forCellReuseIdentifier: "taskCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateView()
    }
    
    func updateView(){
        guard let projects = mainUser?.projects else {
            return
        }
        
        self.archiedProjects = projects.filter {$0.isArchived}
        
        self.tableView.reloadData()
    }
    
    func unarchiveProject(name: String){
        guard var projects = mainUser?.projects else {
            return
        }
        for (index,project) in projects.enumerated() {
            if project.name == name {
                projects[index].isArchived = false
                mainUser?.projects = projects
                
                updateView()
                return
            }
        }
    }

}

extension ArchiveViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70.0
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
       
        
        let unarchiveAction = UIContextualAction(style: .destructive, title: "Unarchive") {  (contextualAction, view, boolValue) in
            self.unarchiveAction(at: indexPath)
        }
        unarchiveAction.backgroundColor = .green
        
        let swipeActions = UISwipeActionsConfiguration(actions: [unarchiveAction])
        
        return swipeActions
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func unarchiveAction(at indexPath: IndexPath){
        unarchiveProject(name: self.archiedProjects[indexPath.row].name)
    }
}

extension ArchiveViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        archiedProjects.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as? TaskCellTableViewCell
        
        cell?.populate(project: self.archiedProjects[indexPath.row])
        
        return cell!
    }
    
    
}
