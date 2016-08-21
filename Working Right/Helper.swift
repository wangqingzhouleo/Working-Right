//
//  Helper.swift
//  Working Rights
//
//  Created by Qingzhou Wang on 21/08/2016.
//  Copyright © 2016 Qingzhou Wang. All rights reserved.
//

import UIKit
import SystemConfiguration

var timeOut: NSTimer!

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
    
    if !isReachable || needsConnection
    {
        SwiftSpinner.show("Internet connection failed. Please check network and relaunch app.", animated: false).addTapHandler({
            SwiftSpinner.hide()
        })
    }
    return (isReachable && !needsConnection)
}

func webStartLoad(message: String)
{
    if isConnectedToNetwork()
    {
        SwiftSpinner.show(message)
    }
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

