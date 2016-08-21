//
//  Company.swift
//  Working Right
//
//  Created by Qingzhou Wang on 15/08/2016.
//  Copyright © 2016 Qingzhou Wang. All rights reserved.
//

import UIKit

class Company: NSObject {
    
    var companyName: String?
    var caseNumber: String?
    var caseDate: String?
    var link: String?

    init(companyName: String, caseNumber: String, caseDate: String, link: String)
    {
        self.companyName = companyName
        self.caseNumber = caseNumber
        self.caseDate = caseDate
        self.link = link
    }
}
