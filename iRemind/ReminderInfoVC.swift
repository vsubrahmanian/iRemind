//
//  ReminderInfoVC.swift
//  iRemind
//
//  Created by Vijay Subrahmanian on 03/06/15.
//  Copyright (c) 2015 Vijay Subrahmanian. All rights reserved.
//

import UIKit

protocol ReminderUpdateProtocol : NSObjectProtocol {
    func reminderUpdatedAtIndex(index: Int);
    func reminderDeletedAtIndex(index: Int);
    func remainderAdded();
}

class ReminderInfoVC: UIViewController {

    var delegate: ReminderUpdateProtocol?
    var reminderInfo: ReminderInfoModel?
    var index: Int?
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var deleteReminderButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.reminderInfo == nil {
            self.reminderInfo = ReminderInfoModel()
        }
        
        if self.index != nil {
            let rightBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: Selector("saveReminder"))
            self.navigationItem.rightBarButtonItem = rightBarButton
        } else {
            let rightBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: Selector("addReminder"))
            self.navigationItem.rightBarButtonItem = rightBarButton
            self.deleteReminderButton.hidden = true
        }
        
        // Set the selected values.
        self.nameTextField.text = self.reminderInfo?.name
        self.detailsTextView.text = self.reminderInfo?.details
        self.datePicker.minimumDate = NSDate().dateByAddingTimeInterval(60*2)
        if let setDate = self.reminderInfo?.time {
            self.datePicker.setDate(setDate, animated: false)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func deleteReminderPressed(sender: UIButton) {
        self.deleteReminder()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func dismissKeyboard(sender: UITapGestureRecognizer) {
        self.nameTextField.resignFirstResponder()
        self.detailsTextView.resignFirstResponder()
    }
    
    func updateReminderModel() {
        
        if self.datePicker.date.compare(NSDate()) == NSComparisonResult.OrderedAscending {
            // If the time is past. Throw an alert.
            UIAlertView(title: "Error", message: "Cannot set reminder for an earlier time", delegate: nil, cancelButtonTitle: "OK")
            self.datePicker.setDate(NSDate().dateByAddingTimeInterval(60*2), animated: true)
            return
        }
        
        self.reminderInfo?.name = self.nameTextField.text
        self.reminderInfo?.details = self.detailsTextView.text
        self.reminderInfo?.time = self.datePicker.date
        
        // Calling local methid from which we are scheduling the notification.
        self.scheduleNotification()
    }

    func addReminder() {
        self.updateReminderModel()
        (UIApplication.sharedApplication().delegate as! AppDelegate).reminderList.insert(self.reminderInfo!, atIndex: 0)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func saveReminder() {
        self.updateReminderModel()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func deleteReminder() {
        
        if self.index != nil {
            (UIApplication.sharedApplication().delegate as! AppDelegate).reminderList.removeAtIndex(self.index!)
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func scheduleNotification() {
        // Create reminder by setting a local notification
        let localNotification = UILocalNotification()
        localNotification.alertTitle = self.reminderInfo?.name
        localNotification.alertBody = self.reminderInfo?.details
        localNotification.alertAction = "ShowDetails"
        localNotification.fireDate = self.reminderInfo?.time
        localNotification.timeZone = NSTimeZone.defaultTimeZone()
        localNotification.soundName = UILocalNotificationDefaultSoundName
        localNotification.applicationIconBadgeNumber = 1
        localNotification.category = "reminderCategory"
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
   
}