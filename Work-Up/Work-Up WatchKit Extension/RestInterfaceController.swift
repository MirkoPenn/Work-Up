//
//  RestInterfaceController.swift
//  Work-Up WatchKit Extension
//
//  Created by Simone Penna on 18/01/2018.
//  Copyright © 2018 needpurple. All rights reserved.
//

import WatchKit
import Foundation
import HealthKit


class RestInterfaceController: WKInterfaceController {
    
    @IBOutlet var ringActivity: RestWKInterfaceActivityRing!
    let summary = HKActivitySummary()
    let value: Double = 2
    let goal: Double = 10
    
//    var activeEnergyBurned: HKQuantity
//    var activeEnergyBurnedGoal: HKQuantity
//    var appleExerciseTime: HKQuantity
//    var appleExerciseTimeGoal: HKQuantity
//    var appleStandHours: HKQuantity
//    var appleStandHoursGoal: HKQuantity
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        summary.activeEnergyBurned = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: value)
        summary.activeEnergyBurnedGoal = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: goal)
        
        summary.appleExerciseTime = HKQuantity(unit: HKUnit.minute(), doubleValue: value)
        summary.appleExerciseTimeGoal = HKQuantity(unit: HKUnit.minute(), doubleValue: goal)
        
        summary.appleStandHours = HKQuantity(unit: HKUnit.count(), doubleValue: value)
        summary.appleStandHoursGoal = HKQuantity(unit: HKUnit.count(), doubleValue: goal)
        
        ringActivity.setActivitySummary(summary, animated: true)
        // Configure interface objects here.
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
