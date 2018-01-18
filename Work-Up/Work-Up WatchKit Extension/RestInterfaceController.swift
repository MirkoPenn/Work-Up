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
    
    var timer: Timer = Timer()
    var count = 10
  
    @IBOutlet var ringActivity: WKInterfaceActivityRing!
    let summary = HKActivitySummary()
    var value: Double = 0
    //deve essere uguale al recupero
    var goal: Double = 10
//    var activeEnergyBurned: HKQuantity
//    var activeEnergyBurnedGoal: HKQuantity
//    var appleExerciseTime: HKQuantity
//    var appleExerciseTimeGoal: HKQuantity
//    var appleStandHours: HKQuantity
//    var appleStandHoursGoal: HKQuantity
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        updateRing()
//        //barra rossa per le calorie bruciate
//        summary.activeEnergyBurned = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: value)
//        summary.activeEnergyBurnedGoal = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: goal)
//
//        //barra verde per il timer e conteggio (utile per il recupero)
//        summary.appleExerciseTime = HKQuantity(unit: HKUnit.minute(), doubleValue: value)
//        summary.appleExerciseTimeGoal = HKQuantity(unit: HKUnit.minute(), doubleValue: goal)
//
//        //barra blu per il conteggio passi
////        summary.appleStandHours = HKQuantity(unit: HKUnit.count(), doubleValue: value)
////        summary.appleStandHoursGoal = HKQuantity(unit: HKUnit.count(), doubleValue: goal)
//
//
//        ringActivity.setActivitySummary(summary, animated: true)
//        // Configure interface objects here.
//        if(value == goal) {
//            WKInterfaceDevice().play(.notification)
//        }
        
        

    }
    

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        let clock = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countdown(sender:)), userInfo: nil, repeats: true)
        

    }
    
    @objc func countdown(sender: Timer) {
        
        count = count - 1
        value = value + 1
        
        //aggiorna il ring
        updateRing()
        
        if count == 0 {
            //timer si disabilita
            sender.invalidate()
            print("now the state is \(sender.isValid)")
        }
        
    }
    

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
    func updateRing() {
        //barra rossa per le calorie bruciate
        summary.activeEnergyBurned = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: value)
        summary.activeEnergyBurnedGoal = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: goal)
        
        //barra verde per il timer e conteggio (utile per il recupero)
        summary.appleExerciseTime = HKQuantity(unit: HKUnit.minute(), doubleValue: value)
        summary.appleExerciseTimeGoal = HKQuantity(unit: HKUnit.minute(), doubleValue: goal)
        
        //barra blu per il conteggio passi
        //        summary.appleStandHours = HKQuantity(unit: HKUnit.count(), doubleValue: value)
        //        summary.appleStandHoursGoal = HKQuantity(unit: HKUnit.count(), doubleValue: goal)
        
        
        ringActivity.setActivitySummary(summary, animated: true)
        // Configure interface objects here.
        if(value == goal) {
            WKInterfaceDevice().play(.notification)
        }
    }
 

}
