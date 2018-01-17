//
//  Exercise.swift
//  Work-Up
//
//  Created by Mirko Pennone on 17/01/18.
//  Copyright © 2018 needpurple. All rights reserved.
//

import Foundation

import CoreData

class Exercise : NSManagedObject
{
    // @NSManaged is the replacement for @dynamic when using CoreData in Swift
    
    @NSManaged var identifier : String
    @NSManaged var name : String?
    @NSManaged var category : String?
    @NSManaged var day : String?
    @NSManaged var weight : Float
    @NSManaged var series : Int
    @NSManaged var reps : Int
    @NSManaged var restSeconds : Int
    
    
    // This is called when a new User object is inserted to CoreData
    
    override func awakeFromInsert()
    {
        super.awakeFromInsert()
        self.identifier = NSUUID().uuidString // generate a random unique ID
    }
    
}

