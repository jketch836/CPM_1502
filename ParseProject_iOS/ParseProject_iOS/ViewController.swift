//
//  ViewController.swift
//  ParseProject_iOS
//
//  Created by Josh Ketcham on 2/8/15.
//  Copyright (c) 2015 Full Sail. All rights reserved.
//

import UIKit
import ParseUI

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, UITextFieldDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {
    
    //    required init(coder aDecoder: NSCoder) {
    //
    //        super.init(coder: aDecoder)
    //
    //    }
    //
    //    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    //        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    //        // Here you can init your properties
    //    }
    
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var ParseTable: UITableView!
    @IBOutlet weak var enterButton: UIButton!
    
    var parseMutableData:NSMutableArray = NSMutableArray()
    var aInt = Int()
    var nameString = String()
    var ageNumber = Int()
    var rowID = String()
    let c = 5
    var updateTable = NSTimer()
    var wifiBool = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "checkingStatus" , name: "internetStatus", object: nil)
        
        checkingStatus()
        
        self.nameTextField.delegate = self
        self.ageTextField.delegate = self
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if PFUser.currentUser() != nil {
            
            nameTextField.placeholder = "Joe"
            ageTextField.placeholder = String(28)
            
            
            updateTable = NSTimer.scheduledTimerWithTimeInterval(20, target: self, selector: Selector("updateTheTable"), userInfo: nil, repeats: true)
            
            updateTheTable()
            
        } else {
            
            var theLogin: PFLogInViewController = PFLogInViewController()
            theLogin.fields = PFLogInFields.UsernameAndPassword | PFLogInFields.LogInButton | PFLogInFields.SignUpButton | PFLogInFields.Twitter
            theLogin.delegate = self
            theLogin.signUpController.delegate = self
            self.presentViewController(theLogin, animated: true, completion: nil)
            
        }
        
    }
    
    func updateTheTable() {
        
        ParseFuncClass().getParseData(self.ParseTable, parseData: parseMutableData, theBool: wifiBool)
        
    }
    
    
    func checkingStatus() {
        
        if currentInternetStatus == kReachableWIFI || currentInternetStatus == kReachableWWAN {
            
            wifiBool = true
            
        } else {
            
            wifiBool = false
            updateTable.invalidate()
            
        }
        
    }
    
    @IBAction func UploadToParse (sender: AnyObject) {
        
        if nameTextField.text.isEmpty || ageTextField.text.isEmpty {
            
            var alert = UIAlertView(title: "Error", message: "Please Add Name and/or Age to Fields", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "OK")
            alert.show()
            
        } else {
            
            var nameString:NSString = nameTextField.text
            var ageInt:Int = ageTextField.text.toInt()!
            
            ParseFuncClass().sendParseData(nameString, age: ageInt, theBool: wifiBool)
            
            self.updateTable.invalidate()
            self.updateTable = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: Selector("updateTheTable"), userInfo: nil, repeats: true)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                self.updateTheTable()
                
            })
            
            textFieldShouldReturn(nameTextField)
            textFieldShouldReturn(ageTextField)
            
            nameTextField.text = ""
            ageTextField.text = ""
            
        }
        
    }
    
    
    @IBAction func LogOut (sender: AnyObject) {
        
        var user = PFUser.currentUser().username
        
        JLToast.makeText("\(user) has logged Out", delay: 0, duration: 2).show()
        
        self.parseMutableData = [];
        
        PFUser.logOut()
        
        updateTable.invalidate()
        
        viewDidAppear(true)
        
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool
    {
        nameTextField.resignFirstResponder()
        ageTextField.resignFirstResponder()
        
        return true;
    }
    
    
    /* Parse LogIn Methods */
    func logInViewController(logInController: PFLogInViewController!, didLogInUser user: PFUser!) -> Void{
        
        logInController.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func logInViewControllerDidCancelLogIn(logInController: PFLogInViewController!) {
        
        logInController.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func signUpViewController(signUpController: PFSignUpViewController!, didSignUpUser user: PFUser!) {
        
        signUpController.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController!) {
        
        signUpController.dismissViewControllerAnimated(true, completion: nil)
        
    }
    /* Parse LogIn Methods End */
    
    
    
    
    /* TableView Methods */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return parseMutableData.count
        
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("ParseCell") as UITableViewCell
        
        let cellParseObject:PFObject = self.parseMutableData.objectAtIndex(indexPath.row) as PFObject
        
        var theNameString = cellParseObject.objectForKey("Name_String")as String!
        
        var AgeInt:Int = cellParseObject.objectForKey("Age_Number") as Int!
        
        
        cell.textLabel!.text = theNameString
        cell.detailTextLabel!.text = String(AgeInt)
        
        //        if indexPath.row % 2 == 0
        //        {
        //
        //            cell.backgroundColor = UIColor.blueColor()
        //            cell.textLabel?.textColor = UIColor.whiteColor()
        //            cell.detailTextLabel!.textColor = UIColor.whiteColor()
        //
        //        }
        
        return cell
        
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
        let currentCell = tableView.cellForRowAtIndexPath(tableView.indexPathForSelectedRow()!)
        
        let cellParseObject:PFObject = self.parseMutableData.objectAtIndex(indexPath.row) as PFObject
        
        var name = cellParseObject.objectForKey("Name_String") as String
        
        nameString = name;
        
        var age = cellParseObject.objectForKey("Age_Number") as Int
        
        ageNumber = age
        
        var theID = cellParseObject.objectId
        
        rowID = theID
        
        aInt = indexPath.row
        
        if wifiBool == true {
            
            var updateDeleteAlert = UIAlertView(title: name, message: "Do you want to Update or Delete \(name)?", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Delete", "Update")
            updateDeleteAlert.show()
            updateDeleteAlert.tag = 0
            
        } else {
            
            JLToast.makeText("Please connect to Wi-Fi in order to make changes to \(name)", delay: 0, duration: 2).show()
            
        }
        
    }
    
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return true
        
    }
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        
        
    }
    
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        
        let cellParseObject:PFObject = self.parseMutableData.objectAtIndex(indexPath.row) as PFObject
        
        var name = cellParseObject.objectForKey("Name_String") as String
        
        self.nameString = name;
        
        var age = cellParseObject.objectForKey("Age_Number") as Int
        
        self.ageNumber = age
        
        var theID = cellParseObject.objectId
        
        self.rowID = theID
        
        var updateButton:UITableViewRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Update") { (UITableViewRowAction action, NSIndexPath indexPath) -> Void in
            
            self.UpdateUserInfo(self.nameString, ageInt: self.ageNumber, theBool: self.wifiBool)
            
        }
        
        updateButton.backgroundColor = UIColor.orangeColor()
        
        
        
        var DeleteButton:UITableViewRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete") { (UITableViewRowAction action, NSIndexPath indexPath) -> Void in
            
            if self.wifiBool == true {
                
                self.updateTable.invalidate()
                
                ParseFuncClass().deleteParseObject(self.ParseTable, parseData: self.parseMutableData, theInt: (indexPath.row), theBool: self.wifiBool)
                
                JLToast.makeText("\(name) has been removed", delay: 0, duration: 2).show()
                
                self.updateTable.fire()
                
            } else {
                
                JLToast.makeText("Please connect to Wi-Fi in order to make changes to \(name)", delay: 0, duration: 2).show()
                
            }
            
        }
        
        return [updateButton, DeleteButton]
        
    }
    /* TableView Methods End */
    
    
    
    
    /* AlertView Methods */
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int)
    {
        
        switch alertView.tag
        {
            
        case 0: /* Main Alert to decide what the User wants to do Delete or Update */
            
            switch buttonIndex
            {
                
            case 0:
                
                println("Button 0: Cancel Button")
                
            case 1: /* Delete Alert */
                
                var deleteAlert = UIAlertView(title: "Delete", message: "Are you sure you want to delete \(nameString)?", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "OK")
                deleteAlert.show()
                deleteAlert.tag = 1
                
            case 2: /* Update Alert Controller */
                
                UpdateUserInfo(nameString, ageInt: ageNumber, theBool: wifiBool)
                
            default:
                println("Error")
                
            }
            
        case 1: /* Delete Contact Alert */
            
            switch buttonIndex
            {
                
            case 0:
                
                println("Button 0: Cancel Button")
                
            case 1: /* Delete Contact Button */
                
                
                ParseFuncClass().deleteParseObject(self.ParseTable, parseData: self.parseMutableData, theInt: aInt, theBool: wifiBool)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    ParseFuncClass().getParseData(self.ParseTable, parseData: self.parseMutableData, theBool: self.wifiBool)
                    
                })
                
            default:
                println("Error")
                
            }
            
        case 2: /* Update Contact Alert if No name or age is entered */
            
            switch buttonIndex
            {
                
            case 0: /* Update Button */
                
                UpdateUserInfo(nameString, ageInt: ageNumber, theBool: wifiBool)
                
            default:
                println("Error")
                
            }
            
        default:
            println("Error")
            
        }
        
    }
    /* AlertView Methods End */
    
    
    /* AlertView Controller Method */
    func UpdateUserInfo (nameString: NSString, ageInt: Int, theBool: Bool) {
        
        self.updateTable.invalidate()
        
        var updateController:UIAlertController = UIAlertController(title: "Updating " + nameString, message: "Once you do this " + nameString + " will never be the same!", preferredStyle: UIAlertControllerStyle.Alert)
        
        updateController.addTextFieldWithConfigurationHandler({
            (textfield) in
            textfield.placeholder = "Name: \(nameString)"
        })
        
        updateController.addTextFieldWithConfigurationHandler({
            (textfield) in
            textfield.placeholder = "Age: \(String(ageInt))"
        })
        
        
        let updateAction:UIAlertAction = UIAlertAction(title: "Update", style: UIAlertActionStyle.Default, handler: {
            alertAction in
            
            let updatedName:UITextField = updateController.textFields![0] as UITextField
            updatedName.keyboardType = UIKeyboardType.NamePhonePad
            let updatedAge:UITextField = updateController.textFields![1] as UITextField
            updatedAge.keyboardType = UIKeyboardType.NumberPad
            
            
            if updatedName.text.isEmpty || updatedAge.text.isEmpty {
                
                var alert = UIAlertView(title: "Error", message: "Please Add Name and/or Age to Fields!!!!", delegate: self, cancelButtonTitle: nil, otherButtonTitles: "OK")
                alert.show()
                alert.tag = 2
                
            } else {
                
                var updatedNameString = updatedName.text
                var updatedAgeInt = updatedAge.text.toInt()!
                
                println("\(updatedNameString)")
                println("\(updatedAgeInt)")
                
                ParseFuncClass().UpdateRow(self.rowID, name: updatedNameString, age: updatedAgeInt, theBool: self.wifiBool)
                
                
                self.updateTable.fire()
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    self.updateTheTable()
                    
                })
                
                
                self.textFieldShouldReturn(updatedName)
                self.textFieldShouldReturn(updatedAge)
                
            }
            
        })
        
        
        updateController.addAction(updateAction)
        
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) {
            action -> Void in
            
            /* dismissing the Update Alert Controller */
            
        }
        
        
        updateController.addAction(cancelAction)
        
        if theBool == true {
            
            self.presentViewController(updateController, animated: true, completion: nil)
            
        } else {
            
            JLToast.makeText("Please connect to Wi-Fi in order to make changes to \(nameString)", delay: 0, duration: 2).show()
            
        }
        
    }
    /* AlertView Controller End */
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

