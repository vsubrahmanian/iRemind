//
//  AppDelegate.swift
//  iRemind
//
//  Created by Vijay Subrahmanian on 03/06/15.
//  Copyright (c) 2015 Vijay Subrahmanian. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var reminderList: Array<ReminderInfoModel> = []

    func application(application: UIApplication, willFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Reading the saved list of reminders from User Defaults.
        if let aList: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("reminderList") {
            let unArchivedList: AnyObject? = NSKeyedUnarchiver.unarchiveObjectWithData(aList as! NSData)
            self.reminderList = unArchivedList as! Array
        }
        // Calling our local method to register for local notifications.
        self.registerForLocalNotifications()
        
        // Handle any action if the user opens the application throught the notification. i.e., by clicking on the notification when the application is killed/ removed from background.
        if let aLaunchOptions = launchOptions { // Checking if there are any launch options.
            // Check if there are any local notification objects.
            if let notification = (aLaunchOptions as NSDictionary).objectForKey("UIApplicationLaunchOptionsLocalNotificationKey") as? UILocalNotification {
                // Handle the notification action on opening. Like updating a table or showing an alert.
                UIAlertView(title: notification.alertTitle, message: notification.alertBody, delegate: nil, cancelButtonTitle: "OK").show()
            }
        }
        return true
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        // Point for handling the local notification when the app is open.
        // Showing reminder details in an alertview
        UIAlertView(title: notification.alertTitle, message: notification.alertBody, delegate: nil, cancelButtonTitle: "OK").show()
    }

    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
        // Point for handling the local notification Action. Provided alongside creating the notification.
        if identifier == "ShowDetails" {
            // Showing reminder details in an alertview
            UIAlertView(title: notification.alertTitle, message: notification.alertBody, delegate: nil, cancelButtonTitle: "OK").show()
        } else if identifier == "Snooze" {
            // Snooze the reminder for 5 minutes
            notification.fireDate = NSDate().dateByAddingTimeInterval(60*5)
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
        } else if identifier == "Confirm" {
            // Confirmed the reminder. Mark the reminder as complete maybe?
        }
        completionHandler()
    }

    func applicationWillResignActive(application: UIApplication) {
    }

    func applicationDidEnterBackground(application: UIApplication) {
        let archivedReminderList = NSKeyedArchiver.archivedDataWithRootObject(self.reminderList)
        NSUserDefaults.standardUserDefaults().setObject(archivedReminderList, forKey: "reminderList")
    }

    func applicationWillEnterForeground(application: UIApplication) {
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Reset the application badge to zero when the application as launched. The notification is viewed.
        if application.applicationIconBadgeNumber > 0 {
            application.applicationIconBadgeNumber = 0
        }
    }

    func applicationWillTerminate(application: UIApplication) {
    }
    
    func registerForLocalNotifications() {
        // Specify the notification actions.
        let reminderActionConfirm = UIMutableUserNotificationAction()
        reminderActionConfirm.identifier = "Confirm"
        reminderActionConfirm.title = "Confirm"
        reminderActionConfirm.activationMode = UIUserNotificationActivationMode.Background
        reminderActionConfirm.destructive = false
        reminderActionConfirm.authenticationRequired = false
        
        let reminderActionSnooze = UIMutableUserNotificationAction()
        reminderActionSnooze.identifier = "Snooze"
        reminderActionSnooze.title = "Snooze"
        reminderActionSnooze.activationMode = UIUserNotificationActivationMode.Background
        reminderActionSnooze.destructive = true
        reminderActionSnooze.authenticationRequired = false
        
        // Create a category with the above actions
        let shoppingListReminderCategory = UIMutableUserNotificationCategory()
        shoppingListReminderCategory.identifier = "reminderCategory"
        shoppingListReminderCategory.setActions([reminderActionConfirm, reminderActionSnooze], forContext: UIUserNotificationActionContext.Default)
        shoppingListReminderCategory.setActions([reminderActionConfirm, reminderActionSnooze], forContext: UIUserNotificationActionContext.Minimal)
        
        // Register for notification: This will prompt for the user's consent to receive notifications from this app.
        let notificationSettings = UIUserNotificationSettings(forTypes: UIUserNotificationType.Alert | UIUserNotificationType.Sound | UIUserNotificationType.Badge, categories: Set(arrayLiteral: shoppingListReminderCategory))
        //*NOTE*
        // Registering UIUserNotificationSettings more than once results in previous settings being overwritten.
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
    }

}

