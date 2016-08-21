//
//  Visa.swift
//  Working Right
//
//  Created by Qingzhou Wang on 17/08/2016.
//  Copyright © 2016 Qingzhou Wang. All rights reserved.
//

import UIKit

class Visa: NSObject {
    
    var visaNumber: Int?
    var visaName: String?
    var aboutVisa: String?
    var eligibility: String?
    var application: String?
    var acceptNewApply: Bool?
    
    init(visaNumber: Int, visaName: String, aboutVisa: String, eligibility: String, application: String, acceptNewApply: Bool)
    {
        self.visaNumber = visaNumber
        self.visaName = visaName
        self.aboutVisa = aboutVisa
        self.eligibility = eligibility
        self.application = application
        self.acceptNewApply = acceptNewApply
    }

}
