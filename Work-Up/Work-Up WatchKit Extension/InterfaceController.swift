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
    
    @IBOutlet var startButton: WKInterfaceButton!
    @IBOutlet var dayLabel: WKInterfaceLabel!
    @IBOutlet var startGroup: WKInterfaceGroup!
    @IBOutlet var exerciseGroup: WKInterfaceGroup!
    @IBOutlet var timerGroup: WKInterfaceGroup!
    @IBOutlet var doneGroup: WKInterfaceGroup!
    
    @IBOutlet var exerciseLabel: WKInterfaceLabel!
    @IBOutlet var categoryImage: WKInterfaceImage!
    @IBOutlet var seriesLabel: WKInterfaceLabel!
    @IBOutlet var tapLabel: WKInterfaceLabel!
    
    var exercises: [Exercise] = []
    var currentIndex: Int = 0
    var currentSeries: Int = 1
    
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
        
        startGroup.setHidden(false)
        exerciseGroup.setAlpha(0.0)
        exerciseGroup.setHidden(true)
        timerGroup.setHidden(true)
        doneGroup.setHidden(true)
        
        
        // set the start view
        
        setTitle("Work Up")
        
        dayLabel.setText(Date().dayOfWeek()!)
        
        // get the schedule
        
        exercises = getTodayExercises()
        
        print("n. of exercises for \(Date().dayOfWeek()!): \(exercises.count)")
        
        if (exercises.count==0){
            // if there are no exercises today
            startButton.setHidden(true)
        } else {
        
        }
        
    }
    
    @IBAction func onClickStart() {
        
        // set up the exercise view
        
        startGroup.setHidden(true)
        self.exerciseGroup.setHidden(false)
        
        self.animate(withDuration: 1.0, animations: {
            self.exerciseGroup.setAlpha(1)
            
        })
        
        exerciseGroup.startAnimating()
        
        setTitle("Exercise")
        
        // set up the first exercise
        
        showExercise(index: currentIndex)
        
    }
    
    @IBAction func onTapExercise(_ sender: Any) {
        
        // set up the timer view
        
        exerciseGroup.setHidden(true)
        timerGroup.setHidden(false)
        
        setTitle("Rest")
        
        // timer code
        
        
        
    }
    
    @IBAction func onTapTimer(_ sender: Any) {
        
        // set up the exercise view
        
        timerGroup.setHidden(true)
        exerciseGroup.setHidden(false)
        
        setTitle("Exercise")
        
        // next series or exercise
        
        currentSeries = currentSeries + 1
        
        if (currentSeries<=exercises[currentIndex].series) {
            // if it's not finished, update the series
            seriesLabel.setText("\(currentSeries) of \(exercises[currentIndex].series)")
            
        } else {
            // otherwise, check if there's another exercise
            
            if (currentIndex<(exercises.count-1)){
                // if there are more exercises, show the next one
                currentIndex = currentIndex + 1
                currentSeries = 1
                showExercise(index: currentIndex)
                
            } else {
                // otherwise, show the well done view!
                exerciseGroup.setHidden(true)
                doneGroup.setHidden(false)
                
                setTitle("Finished")
            }
        }
        
    }
    
    func showExercise(index: Int){
        
        exerciseLabel.setText(exercises[currentIndex].name)
        // set the category image here
        categoryImage.setImage(UIImage(named: exercises[currentIndex].category!) ?? #imageLiteral(resourceName: "biceps"))
        seriesLabel.setText("\(currentSeries) of \(exercises[currentIndex].series)")
        
    }
    
    
    func getTodayExercises() -> [Exercise]{
        
        // get all exercises for today from db and put them in "exercises"
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Exercise")
        fetchRequest.predicate = NSPredicate(format: "day == %@", Date().dayOfWeek()!)
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
