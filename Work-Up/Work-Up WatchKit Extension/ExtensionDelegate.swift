//
//  ExtensionDelegate.swift
//  Work-Up WatchKit Extension
//
//  Created by Mirko Pennone on 17/01/18.
//  Copyright © 2018 needpurple. All rights reserved.
//

import WatchKit
import WatchConnectivity
import CoreData

class ExtensionDelegate: NSObject, WKExtensionDelegate, WCSessionDelegate {
    
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
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
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
            
            let newExercise: Exercise = NSEntityDescription.insertNewObject(forEntityName: "Exercise", into: coreDataContext) as! Exercise
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
        
        _ = saveContext()
        
    }
    
    override init() {
        
        super.init()
        
        // update db when new extension delegate is created (app start)
        
        let session = WCSession.default
        session.delegate = self as WCSessionDelegate
        session.activate()
        
    }

    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
        
    }

    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
        
    }

    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
        for task in backgroundTasks {
            // Use a switch statement to check the task type
            switch task {
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
                // Be sure to complete the background task once you’re done.
                backgroundTask.setTaskCompletedWithSnapshot(false)
            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
                // Snapshot tasks have a unique completion call, make sure to set your expiration date
                snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)
            case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
                // Be sure to complete the connectivity task once you’re done.
                connectivityTask.setTaskCompletedWithSnapshot(false)
            case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
                // Be sure to complete the URL session task once you’re done.
                urlSessionTask.setTaskCompletedWithSnapshot(false)
            default:
                // make sure to complete unhandled task types
                task.setTaskCompletedWithSnapshot(false)
            }
        }
    }

}
