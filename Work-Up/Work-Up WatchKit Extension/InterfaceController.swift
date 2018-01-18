//
//  InterfaceController.swift
//  Work-Up WatchKit Extension
//
//  Created by Mirko Pennone on 17/01/18.
//  Copyright © 2018 needpurple. All rights reserved.
//

import WatchKit
import WatchConnectivity
import Foundation
import CoreData


class InterfaceController:  WKInterfaceController, WCSessionDelegate{
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    

    @IBOutlet var label: WKInterfaceLabel!
    
    var exercises: [Exercise] = []
    
    
    let coreDataContext : NSManagedObjectContext =
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
    
    override func awake(withContext context: Any?) {
        
        
        let session = WCSession.default
        session.delegate = self as WCSessionDelegate
        session.activate()
        
        super.awake(withContext: context)
        
        // Configure interface objects here.
       
        exercises = getAllExercises()
        
        var esercizi: String = ""
        
        for exercise in exercises {
            esercizi.append(exercise.name!)
        }
        
        label.setText(esercizi)
        
        
    }
    
    
    func getAllExercises() -> [Exercise]{
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Exercise")
        var results: [Exercise]
        
        do{
            
            results = try coreDataContext.fetch(fetchRequest) as! [Exercise]
            
        } catch {
            
            results = []
            
        }
        
        return results
    }
    
    func saveContext() -> Bool
    {
        if coreDataContext.hasChanges
        {
            do {
                try coreDataContext.save()
            } catch {
                return false
            }
            
        }
        return true
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        
        // erase old database
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Exercise")
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        do {
            _ = try coreDataContext.execute(request)
        } catch {
            
        }
        
        // rewrite database based on applicationContext
        
         var identifiers = applicationContext["identifiers"] as? [String] ?? []
        var names = applicationContext["names"] as? [String] ?? []
        var categories = applicationContext["categories"] as? [String] ?? []
        var days = applicationContext["days"] as? [String] ?? []
        var weight = applicationContext["weight"] as? [Float] ?? []
        var series = applicationContext["series"] as? [Int] ?? []
        var reps = applicationContext["reps"] as? [Int] ?? []
        var restSeconds = applicationContext["restSeconds"] as? [Int] ?? []
        
        var newExercises: [Exercise] = []
        
        for i in 0...(identifiers.count-1) {
            
            var newExercise: Exercise = NSEntityDescription.insertNewObject(forEntityName: "Exercise", into: coreDataContext) as! Exercise
            newExercise.identifier = identifiers[i]
            newExercise.name = names[i]
            newExercise.category = categories[i]
            newExercise.day = days[i]
            newExercise.weight = weight[i]
            newExercise.series = Int64(series[i])
            newExercise.reps = Int64(reps[i])
            newExercise.restSeconds = Int64(restSeconds[i])
            
            newExercises.append(newExercise)
            
        }
    
        saveContext()
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
