//
//  AppDelegate.swift
//  Working Right
//
//  Created by Qingzhou Wang on 14/08/2016.
//  Copyright © 2016 Qingzhou Wang. All rights reserved.
//

import UIKit
import CoreData
import Firebase

//let rootVC: ViewController!

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        UITabBar.appearance().tintColor = UIColor(red: 0.8471, green: 0, blue: 0.1529, alpha: 1)
        FIRApp.configure()
        
        managedObject = self.managedObjectContext
        appDelegate = self
        
        application.statusBarHidden = false
        
//        fetchUser()
        
//        if !NSUserDefaults.standardUserDefaults().boolForKey("everLaunched") && user == nil
//        {
//            let navigationVC = window!.rootViewController as! UINavigationController
//            let storyboard = navigationVC.storyboard
//            let vc = storyboard?.instantiateViewControllerWithIdentifier("MainRegisterViewController") as! MainRegisterViewController
//            window?.rootViewController = vc
//        }
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "FIT5120.Working_Right" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("Working_Right", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason

            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    func parseFile()
    {
        let path = NSBundle.mainBundle().pathForResource("Hospitality", ofType: "json")!
        let data = NSData(contentsOfFile: path)!
        let json = JSON(data: data)
        
        var newFileData = [JSON]()
        for item in json.array!
        {
            var list = [String: String]()
            list.updateValue(item["Sunday"].stringValue, forKey: "Sunday")
            list.updateValue(item["Saturday"].stringValue, forKey: "Saturday")
            list.updateValue(item["Age"].stringValue, forKey: "Age")
            list.updateValue(item["Hourly pay rate"].stringValue, forKey: "Hourly pay rate")
            list.updateValue(item["Job Type"].stringValue, forKey: "Job Type")
            list.updateValue(item["Classification"].stringValue, forKey: "Classification")
            list.updateValue(item["Public holiday"].stringValue, forKey: "Public holiday")
            list.updateValue(item["Level"].stringValue, forKey: "Level")
            list.updateValue(item["Grade"].stringValue, forKey: "Grade")
            
//            var classification = item["Classification"].stringValue
//            var level = ""
//            var grade = ""
//            if classification.containsString("grade")
//            {
//                grade = classification.substringFromIndex(classification.endIndex.advancedBy(-7))
//                classification = classification.substringToIndex(classification.endIndex.advancedBy(-8))
//            }
//            if classification.containsString("Level")
//            {
//                level = classification.substringToIndex(classification.startIndex.advancedBy(7))
//                classification = classification.substringFromIndex(classification.startIndex.advancedBy(8))
//            }
//            classification = classification.capitalizedString
//            
//            list.updateValue(classification, forKey: "Classification")
//            list.updateValue(level, forKey: "Level")
//            list.updateValue(grade, forKey: "Grade")
//
            newFileData.append(JSON(list))
        }

        print(newFileData)
        
//        do
//        {
//            try newFileData.description.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding)
//        }
//        catch let error
//        {
//            print(error)
//        }
    }
    
    func tryFirebase()
    {
        let ref: FIRDatabaseReference = FIRDatabase.database().reference()
        
        let questionTitle = "Who am i?"
        let key = ref.child("questions").child(questionTitle).key
//        let post = ["questionTitle": questionTitle]
//        let update = ["/questions/\(key)": post]
//        ref.updateChildValues(update)

        let postAnswer = ["answers": ["I am Ankit"]]
        let updateAnswer = ["/questions/\(key)": postAnswer]
        ref.updateChildValues(updateAnswer)
        
//        ref.child("questions").child(questionTitle).child("likes").setValue(5)
//        
//        ref.child("questions").child(questionTitle).child("answers").childByAutoId().setValue("Test")
//        
//        ref.child("questions").setValue("Who am i?")
//        ref.observeEventType(.Value, withBlock:  { (snapshot) in
//            let dict = snapshot.value as! [String: AnyObject]
//            let a = dict["questions"] as! NSDictionary
//            let b = a[questionTitle]!["answers"] as! NSDictionary
//            print(b.allValues)
//        })
        
        ref.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            let dict = snapshot.value as! [String: AnyObject]
            let a = dict["questions"] as! NSDictionary
            let b = a[questionTitle]!["answers"] as! NSDictionary
            print(b.allValues)
        })
    }

}

