//
//  LegalServiceAnnotation.swift
//  Working Rights
//
//  Created by Qingzhou Wang on 29/08/2016.
//  Copyright © 2016 Qingzhou Wang. All rights reserved.
//

import UIKit
import MapKit

class LegalServiceAnnotation: MKPointAnnotation {
    
//    var title: String?
//    var subtitle: String?
    var address: String
    var tel: String
    var tollFree: String?
//    var coordinate: CLLocationCoordinate2D
    var field: String
    
    init(title: String?, subtitle: String?, address: String, tel: String, tollFree: String?, coordinate: CLLocationCoordinate2D, field: String)
    {
        self.address = address
        self.tel = tel
        self.tollFree = tollFree
        self.field = field
        super.init()
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }

}
