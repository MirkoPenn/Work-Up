//
//  AddExerciseViewController.swift
//  Work-Up
//
//  Created by Carlo Santoro on 17/01/2018.
//  Copyright © 2018 needpurple. All rights reserved.
//

import UIKit
import CoreData
import WatchKit
import WatchConnectivity

class AddExerciseViewController: UIViewController, WCSessionDelegate {
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    

    let context : NSManagedObjectContext =
    {
        
        
        // This is your xcdatamodeld file
        let modelURL = Bundle.main.url(forResource: "WorkUp", withExtension: "momd")
        let dataModel = NSManagedObjectModel(contentsOf: modelURL!)
        
        // This is where you are storing your SQLite database file
        
        
        let documentsDirectory : NSURL! = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.needpurple.work-up")! as NSURL
        
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
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var categoryTextField: UITextField!
    
    @IBOutlet weak var dayTextField: UITextField!
    
    @IBOutlet weak var weightTextField: UITextField!
    
    @IBOutlet weak var seriesTextField: UITextField!
    
    @IBOutlet weak var repsTextField: UITextField!
    
    @IBOutlet weak var restTextField: UITextField!
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
        //Swift
        do {
            
            let exercises = getAllExercises()
            
            var identifiersAll: [String] = []
            var namesAll: [String] = []
            var categoriesAll: [String] = []
            var daysAll: [String] = []
            var weightsAll: [Float] = []
            var seriesAll: [Int] = []
            var repsAll: [Int] = []
            var restSecondsAll: [Int] = []
            
            for exercise in exercises {
                
                identifiersAll.append(exercise.identifier)
                namesAll.append(exercise.name!)
                categoriesAll.append(exercise.category!)
                daysAll.append(exercise.day!)
                weightsAll.append(exercise.weight)
                seriesAll.append(exercise.series)
                repsAll.append(exercise.reps)
                restSecondsAll.append(exercise.restSeconds)
                
            }
            
            _ = // Create a dict of application data
                try session.updateApplicationContext(["identifiers" : identifiersAll, "names" : namesAll, "categories" : categoriesAll, "days" : daysAll, "weight" : weightsAll, "series" : seriesAll, "reps" : repsAll,  "restSeconds" : restSecondsAll])
        } catch {
            // Handle errors here
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func addExercise(_ sender: UIButton) {
        
        let newExercise: Exercise = NSEntityDescription.insertNewObject(forEntityName: "Exercise", into: context) as! Exercise
        
        newExercise.name = nameTextField.text
        newExercise.category = categoryTextField.text
        newExercise.day = dayTextField.text
        newExercise.weight = Float(weightTextField.text!)!
        newExercise.series = Int(seriesTextField.text!)!
        newExercise.reps = Int(repsTextField.text!)!
        newExercise.restSeconds = Int(restTextField.text!)!
        
        _ = saveContext()
        
        self.navigationController?.popViewController(animated: true)
        
        
    }
    
    func saveContext() -> Bool
    {
        if context.hasChanges
        {
            do {
                try context.save()
                
                // send updates to watch
                let session = WCSession.default
                session.delegate = self as WCSessionDelegate
                session.activate()
                
                print("hey")
                
            } catch {
                return false
            }
            
        }
        return true
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
