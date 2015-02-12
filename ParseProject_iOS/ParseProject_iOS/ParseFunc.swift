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
    
    var name = "Age_Number"
    
    func sendParseData(name: NSString, age: Int) {
        
        var PersonData:PFObject = PFObject(className: "PersonData")
        PersonData["Name_String"] = name
        PersonData["Age_Number"] = age
        PersonData["user"] = PFUser.currentUser().username
        PersonData.saveInBackgroundWithBlock {
            (success: Bool, error: NSError!) -> Void in
            if success {
                
                JLToast.makeText("\(name) has been added to Address Book", delay: 0, duration: 2).show()
                
            } else {
                
                println("Error: \(error), \(error.userInfo!)")
                
            }
            
        }
        
    }
    
    
    func getParseData(table: UITableView, parseData:NSMutableArray){
    
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
                            
                                println("\(object.objectForKey(self.name))")
                            
                            }
                            
                            let array:NSArray = data.reverseObjectEnumerator().allObjects
                    
                            data = NSMutableArray(array: array)
                        
                            table.reloadData()
                            
                         } else {
                        
                                println("Error: %@ %@", error, error.userInfo!)
                            
                        }
                    
                }
                
    }
    
    
    
    func deleteParseObject(table: UITableView, parseData:NSMutableArray, theInt: Int) {
        
        let object:PFObject = parseData.objectAtIndex(theInt) as PFObject
        object.deleteInBackgroundWithBlock
            {
                (Bool: Bool, error: NSError!) -> Void in
            
                parseData.removeObjectAtIndex(theInt)
                table.reloadData()
                
            }
        
        }
                        
    }
            

    
