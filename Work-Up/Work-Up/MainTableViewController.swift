//
//  MainTableViewController.swift
//  Work-Up
//
//  Created by Mirko Pennone on 17/01/18.
//  Copyright © 2018 needpurple. All rights reserved.
//

import UIKit
import CoreData



class MainTableViewController: UITableViewController {
    
    var exercises: [Exercise] = []
    var days: [String] = []
    
    let context : NSManagedObjectContext =
    {
        
        
        // This is your xcdatamodeld file
        let modelURL = Bundle.main.url(forResource: "WorkUp", withExtension: "momd")
        let dataModel = NSManagedObjectModel(contentsOf: modelURL!)
        
        // This is where you are storing your SQLite database file
        let documentsDirectory : NSURL! = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last as NSURL?
        let storeURL = documentsDirectory.appendingPathComponent("WorkUp.sqlite")
        
        let psc = NSPersistentStoreCoordinator(managedObjectModel: dataModel!)
        
        var error : NSError?
        do {
            let store = try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
            
            if let error = error
            {
                print("Uhoh, something happened! \(error), \(error.userInfo)")
            }
            
        } catch {
            
        }
        
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        
        context.persistentStoreCoordinator = psc
        context.undoManager = nil
        
        
        return context
    }()

    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addExercise(sender:)))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        exercises = getAllExercises()
        tableView.reloadData()
        
    }
    
    func getAllExercises() -> [Exercise]{
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Exercise")
        var results: [Exercise]
        
        do{
            
            results = try context.fetch(fetchRequest) as! [Exercise]
            
        } catch {
            
            results = []
            
        }
        
        return results
    }
    
    
    func saveContext() -> Bool
    {
        if context.hasChanges
        {
            do {
            try context.save()
            } catch {
                return false
            }
            
        }
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
       
        for exercise in exercises {
            if (!days.contains(exercise.day!)){
                days.append(exercise.day!)
            }
        }
        
        return days.count
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return days[section]
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        var rows = 0
        let day = days[section]
        for exercise in exercises {
            if (exercise.day! == day) {
                rows = rows + 1
            }
        }
        return rows
        
        
    }
    
    
    @objc func addExercise(sender: UIBarButtonItem){
        performSegue(withIdentifier: "addSegue", sender: self)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseCell", for: indexPath)

        // Configure the cell...
        var exercisesForDay: [Exercise] = []
        
        let day = days[indexPath.section]
        for exercise in exercises {
            if (exercise.day! == day) {
                exercisesForDay.append(exercise)
            }
        }
        
        cell.textLabel?.text = exercisesForDay[indexPath.row].name
        
        cell.detailTextLabel?.text =  "\(exercisesForDay[indexPath.row].category!), \(exercisesForDay[indexPath.row].series)x\(exercisesForDay[indexPath.row].reps) (\(exercisesForDay[indexPath.row].weight) kg)"

        return cell
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
