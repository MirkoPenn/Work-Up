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


class InterfaceController:  WKInterfaceController{
    
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
        
        
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
//        var esercizi: String = ""
//
//        for exercise in exercises {
//            esercizi.append(exercise.name!)
//        }
//
//        label.setText(esercizi)
        
        exercises = getAllExercises()
        
        label.setText(Date().dayOfWeek()!)
        
    }
    
    func getAllExercises() -> [Exercise]{
        
        // get all exercises from db and put them in "exercises"
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Exercise")
        var results: [Exercise]
        
        do{
            
            results = try coreDataContext.fetch(fetchRequest) as! [Exercise]
            
        } catch {
            
            results = []
            
        }
        
        return results
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        
        print("Will Activate")
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}

extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
}
