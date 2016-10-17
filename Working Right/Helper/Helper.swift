//
//  Helper.swift
//  Working Rights
//
//  Created by Qingzhou Wang on 21/08/2016.
//  Copyright © 2016 Qingzhou Wang. All rights reserved.
//

import UIKit
import SystemConfiguration
import Firebase
import CoreData

var managedObject: NSManagedObjectContext!
var appDelegate: AppDelegate!
var user: User?

var topQuestions: [Question] = []

var tmpUser = ["", "", ""]

func fetchUser()
{
    // Retreive the data from database.
    let fetchRequest = NSFetchRequest()
    let entityDescription = NSEntityDescription.entityForName("User", inManagedObjectContext: managedObject)
    fetchRequest.entity = entityDescription
    
    // Try to retrieve data from entity.
    do
    {
        var result: [User] = []
        result = try managedObject.executeFetchRequest(fetchRequest) as! [User]
        if result.count > 0
        {
            user = result[0]
        }
    }
    catch
    {
        let fetchError = error as NSError
        print(fetchError)
    }
}

var timeOut: NSTimer?
var webTimeOutMsg = "Connection time out.\nPlease try later."
struct address {
    var address: String
    var lat: Double
    var long: Double
}

var allQuestions: [Question] = []
struct Question {
    var key: String
    var title: String
    var desc: String
    var date: NSDate
    var like: Int
    var dislike: Int
    var answers: [Answer]
}

struct Answer {
    var key: String
    var content: String
    var like: Int
    var dislike: Int
}

let firebase: FIRDatabaseReference = FIRDatabase.database().reference()

// Function copied from http://stackoverflow.com/a/30743763/6197704
// Used for chech the network connection.
func isConnectedToNetwork() -> Bool {
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
    zeroAddress.sin_family = sa_family_t(AF_INET)
    let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
        SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
    }
    var flags = SCNetworkReachabilityFlags()
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
        return false
    }
    let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
    let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0

    return (isReachable && !needsConnection)
}

func shouldWebStartLoad() -> Bool
{
    if isConnectedToNetwork()
    {
        SwiftSpinner.show("Loading page from server\nPlease wait")
    }
    else
    {
        SwiftSpinner.show("Your iPhone is not connected to the Internet", animated: false)
    }
    
    return isConnectedToNetwork()
}

//func imageResize(image:UIImage,scaledToSize newSize:CGSize)->UIImage{
//    
//    UIGraphicsBeginImageContext( newSize )
//    image.drawInRect(CGRect(x: 0,y: 0,width: newSize.width,height: newSize.height))
//    let newImage = UIGraphicsGetImageFromCurrentImageContext()
//    UIGraphicsEndImageContext()
//    return newImage.imageWithRenderingMode(.AlwaysTemplate)
//}

func imageResize(imageObj:UIImage, sizeChange:CGSize)-> UIImage {
    
    let hasAlpha = false
    let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
    
    UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
    imageObj.drawInRect(CGRect(origin: CGPointZero, size: sizeChange))
    
    let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return scaledImage
}

