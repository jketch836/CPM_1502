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
//    
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var ParseTable: UITableView!
    
    
    var parseMutableData:NSMutableArray = NSMutableArray()
    var aInt = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.nameTextField.delegate = self
        self.ageTextField.delegate = self
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if PFUser.currentUser() != nil {
            
            nameTextField.placeholder = "Joe"
            ageTextField.placeholder = "\(28)"

            ParseFuncClass().getParseData(self.ParseTable, parseData: parseMutableData)

            JLToast.makeText("\(PFUser.currentUser().username) Address Book has loaded", delay: 0, duration: 2).show()
            
        } else {
            
            var theLogin: PFLogInViewController = PFLogInViewController()
            theLogin.fields = PFLogInFields.UsernameAndPassword | PFLogInFields.LogInButton | PFLogInFields.SignUpButton | PFLogInFields.Twitter
            theLogin.delegate = self
            theLogin.signUpController.delegate = self
            self.presentViewController(theLogin, animated: true, completion: nil)
            
        }
        
    }
    
    
    @IBAction func UploadToParse (sender: AnyObject) {
        
        if nameTextField.text.isEmpty && ageTextField.text.isEmpty {
    
            var alert = UIAlertView(title: "Error", message: "Please Add Name and/or Age to Fields", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "OK")
                alert.show()
    
        } else {
            
            
            var nameString:NSString = nameTextField.text
            var ageInt:Int = ageTextField.text.toInt()!
            
            ParseFuncClass().sendParseData(nameString, age: ageInt)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
                ParseFuncClass().getParseData(self.ParseTable, parseData: self.parseMutableData)
                
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
        
        aInt = indexPath.row
        
        var deleteAlert = UIAlertView(title: "Delete", message: "Are you sure you want to delete \(name)?", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "OK")
            deleteAlert.show()
            deleteAlert.tag = 0
        
    }
    
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return true
        
    }
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        
        let cellParseObject:PFObject = self.parseMutableData.objectAtIndex(indexPath.row) as PFObject
        
        var name = cellParseObject.objectForKey("Name_String") as String
        
        if editingStyle == UITableViewCellEditingStyle.Delete
        {
            
            ParseFuncClass().deleteParseObject(self.ParseTable, parseData: self.parseMutableData, theInt: (indexPath.row))
            
            JLToast.makeText("\(name) has been removed", delay: 0, duration: 2).show()
            
        }
        
    }
     /* TableView Methods End */

    
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int)
    {
        
        switch alertView.tag
        {
            
        case 0:
            
            switch buttonIndex
            {
                
            case 0:
                println("Button 0")
                
            case 1: /* OK Button */
                
                ParseFuncClass().deleteParseObject(self.ParseTable, parseData: self.parseMutableData, theInt: aInt)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    ParseFuncClass().getParseData(self.ParseTable, parseData: self.parseMutableData)
                    
                })
                
            default:
               println("Error")
                
            }
            
        default:
            println("Error")
            
        }
       
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

