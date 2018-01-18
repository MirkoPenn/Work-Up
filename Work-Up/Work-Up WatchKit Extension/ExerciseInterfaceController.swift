//
//  ExerciseInterfaceController.swift
//  Work-Up WatchKit Extension
//
//  Created by Mirko Pennone on 18/01/18.
//  Copyright © 2018 needpurple. All rights reserved.
//

import WatchKit
import Foundation


class ExerciseInterfaceController: WKInterfaceController {

    @IBOutlet var exerciseNameLabel: WKInterfaceLabel!
    
    @IBOutlet var exerciseImage: WKInterfaceImage!
    
    @IBOutlet var exerciseSeriesLabel: WKInterfaceLabel!
    
    @IBOutlet var tapLabel: WKInterfaceLabel!
    
    var exercises: [Exercise] = []
    var index: Int = 0
    var isExercise: Bool = true
    
    func setNextExercise(){
        
        
        
    }
    
    override func awake(withContext context: Any?) {
        
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    @IBAction func handleGesture(_ sender: Any) {
        
        print("Hey")
        
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
