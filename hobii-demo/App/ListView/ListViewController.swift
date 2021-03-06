//
//  ListViewController.swift
//  hobii-demo
//
//  Created by Sebastian Kumor on 17/10/2020.
//

import UIKit

class ListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    var activeProjects: [Project] = []
    var inactiveProjects: [Project] = []
    
    @IBAction func addButtonAction(_ sender: Any) {
        let alertController = UIAlertController(title: "Create new Project", message: "", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0]
            
            guard let text = firstTextField.text else{
                return
            }
            
            self.createProject(name: text)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
                                            (action : UIAlertAction!) -> Void in })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Project name"
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UINib(nibName: "TaskCellTableViewCell", bundle: nil), forCellReuseIdentifier: "taskCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupStyles()
        
        if mainUser?.projects?.count ?? 0 > 0 {
            sortProjects()
        }
    }
    
    func setupStyles(){
        self.addButton.layer.cornerRadius = self.addButton.frame.size.width/2
        self.addButton.layer.shadowColor = UIColor.CustomColor.buttonShadow.cgColor
        self.addButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.addButton.layer.shadowRadius = 6.0
        self.addButton.layer.shadowOpacity = 1.0
    }
    
    func createProject(name: String){
        
        if validateProjectName(name: name){
            let project = Project(name: name, creationDate: Date())
            
            if mainUser?.projects == nil {
                mainUser?.projects = []
            }
            
            mainUser?.projects?.append(project)
            sortProjects()
        }else{
            
            if name.isEmpty {
                Helpers.createSimpleAlert(in: self, title: "Empty name", message: "Project name cannot be empty")
            }else{
                Helpers.createSimpleAlert(in: self, title: "Duplicate", message: "Project with same name already exists")
            }
        }
       
    }
    
    func sortProjects(){
        guard let projects = mainUser?.projects else {
            return
        }
                
        self.activeProjects = projects.filter {$0.isRunning && !$0.isArchived}
        
        self.inactiveProjects = projects.filter {!$0.isRunning && !$0.isArchived}
        
        self.tableView.reloadData()
    }
    
    func updateMainUser(updatedProject: Project){
        guard var projects = mainUser?.projects else {
            return
        }
        for (index,project) in projects.enumerated() {
            if project.name == updatedProject.name {
                projects[index] = updatedProject
                mainUser?.projects = projects
                
                sortProjects()
                return
            }
        }
    }
    
    func deleteProject(name: String){
        guard var projects = mainUser?.projects else {
            return
        }
        for (index,project) in projects.enumerated() {
            if project.name == name {
                projects.remove(at: index)
                mainUser?.projects = projects
                
                sortProjects()
                return
            }
        }
    }
    
    func archiveProject(name: String){
        guard var projects = mainUser?.projects else {
            return
        }
        for (index,project) in projects.enumerated() {
            if project.name == name {
                projects[index].isArchived = true
                projects[index].isRunning = false
                projects[index].playDate = nil
                mainUser?.projects = projects
                
                sortProjects()
                return
            }
        }
    }
    
    func validateProjectName(name: String) -> Bool{
        
        if name.isEmpty{
            return false
        }
        
        guard let projects = mainUser?.projects else {
            return true
        }
        
        let duplicate = projects.first(where: {$0.name == name})
        
        if duplicate == nil {
            return true
        }else{
            return false
        }
    }
}

extension ListViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            var project = self.activeProjects[indexPath.row]
            project.pauseDate = Date()
            project.calculateHours()
            project.isRunning = false
            project.playDate = nil
            
            updateMainUser(updatedProject: project)
           
            
        }else{
            var project = self.inactiveProjects[indexPath.row]
            project.playDate = Date()
            project.pauseDate = nil
            project.isRunning = true
            
            updateMainUser(updatedProject: project)
            
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            self.deleteData(at: indexPath)
        }
        
        let archiveAction = UIContextualAction(style: .destructive, title: "Archive") {  (contextualAction, view, boolValue) in
            self.archiveAction(at: indexPath)
        }
        archiveAction.backgroundColor = .orange
        
        let swipeActions = UISwipeActionsConfiguration(actions: [archiveAction,deleteAction])
        
        return swipeActions
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func archiveAction(at indexPath: IndexPath){
        if indexPath.section == 0 {
            archiveProject(name: self.activeProjects[indexPath.row].name)
        }else{
            archiveProject(name: self.inactiveProjects[indexPath.row].name)
        }
    }
    
    func deleteData(at indexPath: IndexPath) {
        if indexPath.section == 0 {
            deleteProject(name: self.activeProjects[indexPath.row].name)
        }else{
            deleteProject(name: self.inactiveProjects[indexPath.row].name)
        }
    }
}

extension ListViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return activeProjects.count
        case 1:
            return inactiveProjects.count
        default:
            return activeProjects.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as? TaskCellTableViewCell
        
        cell?.delegate = self
        if indexPath.section == 0 {
            cell?.populate(project: self.activeProjects[indexPath.row])
        }else{
            cell?.populate(project: self.inactiveProjects[indexPath.row])
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return self.activeProjects.count == 0 ? nil : "Active"
        }else{
            return self.inactiveProjects.count == 0 ? nil : "Inactive"
        }
    }
}

extension ListViewController : TaskCellTableViewCellDelegate {
    // create pdf invoice
    func createInvoiceClicked(project: Project) {
        Helpers.createPDF(in: self, with: project) {
            sortProjects()
        }
    }
}
