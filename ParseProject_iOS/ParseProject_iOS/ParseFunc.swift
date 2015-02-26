//
//  ParseFunc.swift
//  ParseProject_iOS
//
//  Created by Josh Ketcham on 2/8/15.
//  Copyright (c) 2015 Full Sail. All rights reserved.
//

import Foundation
import UIKit

class ParseFuncClass {
    
    var name = "Name_String"
    
    func sendParseData(name: NSString, age: Int, theBool: Bool) {
        
        if theBool == true {
            
            var PersonData:PFObject = PFObject(className: "PersonData")
            PersonData["Name_String"] = name
            PersonData["Age_Number"] = age
            PersonData["user"] = PFUser.currentUser().username
            PersonData.saveInBackgroundWithBlock {
                (success: Bool, error: NSError!) -> Void in
                if success {
                    
                    JLToast.makeText("\(name) has been added to Address Book", delay: 0, duration: 2).show()
                    
                    println("\(PersonData.objectId)")
                    
                } else {
                    
                    println("Error: \(error), \(error.userInfo!)")
                    
                }
                
            }
            
        } else {
            
            JLToast.makeText("Please connect to Wi-Fi in order to make changes", delay: 0, duration: 2).show()
            
        }
        
    }
    
    
    func getParseData(table: UITableView, parseData:NSMutableArray, theBool: Bool) {
        
        if theBool == true {
            
            var data:NSMutableArray = parseData
            
            data.removeAllObjects()
            
            var queryParse = PFQuery(className:"PersonData")
            queryParse.whereKey("user", equalTo: PFUser.currentUser().username)
            queryParse.findObjectsInBackgroundWithBlock
                {
                    (objects: [AnyObject]!, error: NSError!) -> Void in
                    if error == nil
                    {
                        
                        for object:PFObject in objects as [PFObject]
                        {
                            
                            data.addObject(object)
                            
                            //                            println("\(object.objectForKey(self.name))"
                            
                        }
                        
                        let array:NSArray = data.reverseObjectEnumerator().allObjects
                        
                        data = NSMutableArray(array: array)
                        
                        table.reloadData()
                        
                        JLToast.makeText("\(PFUser.currentUser().username)'s Address Book has loaded", delay: 0, duration: 1).show()
                        
                    } else {
                        
                        println("Error: %@ %@", error, error.userInfo!)
                        
                    }
                    
            }
            
        }
        
    }
    
    
    func deleteParseObject(table: UITableView, parseData:NSMutableArray, theInt: Int, theBool: Bool) {
        
        if theBool == true {
            
            let object:PFObject = parseData.objectAtIndex(theInt) as PFObject
            
            object.delete()
            
            getParseData(table, parseData: parseData, theBool: theBool)
            
            table.reloadData()
            
        } else {
            
            JLToast.makeText("Cannot Delete at this time", delay: 0, duration: 2).show()
            
        }
    }
    
    
    func UpdateRow (objectID:NSString, name: NSString, age: Int, theBool: Bool) {
        
        if theBool == true {
            
            var updateQuery = PFQuery(className:"PersonData")
            updateQuery.whereKey("user", equalTo: PFUser.currentUser().username)
            updateQuery.getObjectInBackgroundWithId(objectID) {
                (personObject: PFObject!, error: NSError!) -> Void in
                if error == nil {
                    
                    personObject["Name_String"] = name
                    personObject["Age_Number"] = age
                    personObject.saveInBackgroundWithBlock
                        {
                            (success: Bool, error: NSError!) -> Void in
                            if success {
                                
                                JLToast.makeText("\(name) has been updated in the Address Book", delay: 0, duration: 2).show()
                                
                            } else {
                                
                                println("Error: \(error), \(error.userInfo!)")
                                
                            }
                            
                    }
                    
                } else {
                    
                    NSLog("%@", error)
                    
                }
                
            }
            
        } else {
            
            JLToast.makeText("Please connect to Wi-Fi in order to make changes to \(name)", delay: 0, duration: 2).show()
            
        }
        
    }
    
}





