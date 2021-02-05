//
//  TableViewController.swift
//  CoreDataDemo
//
//  Created by Pavel Boltromyuk on 2/5/21.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {

    var toDoItems = [Task]()
    
    override func viewWillAppear(_ animated: Bool) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        do{
            toDoItems = try context.fetch(fetchRequest)
            toDoItems.reverse()
            print("load")
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let task = toDoItems[indexPath.row]
        
        cell.textLabel?.text = task.taskToDo

        return cell
    }

    @IBAction func addItem(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add task", message: "add new task", preferredStyle: .alert)
        let ok = UIAlertAction(title: "ok", style: .default){ [weak self] _ in
            let text = alert.textFields?.first?.text ?? ""
            self?.saveTask(taskToDo: text)
//            self?.toDoItems.insert(text, at: 0)
            self?.tableView.reloadData()
        }
        
        alert.addTextField{ textField in
            textField.placeholder = "Task"
        }
        
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func saveTask(taskToDo: String){
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Task", in: context)
        let entityObject = NSManagedObject(entity: entity!, insertInto: context) as! Task
        
        entityObject.taskToDo = taskToDo
        
        do{
            try context.save()
            toDoItems.insert(entityObject, at: 0)
            print("Saved!")
        }catch{
            print(error.localizedDescription)
        }
//        let entity =
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
