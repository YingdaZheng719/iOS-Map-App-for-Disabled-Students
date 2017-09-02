//
//  CustomPointAnnotation.swift
//  UWF_ADA_Map2
//
//  Created by Yingda Zheng on 4/19/16.
//  Copyright © 2016 Yingda Zheng. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

//subclass MKPointAnnotation and add property imageName to it
//so I can change the icon of pinpoint for different needs
class CustomPointAnnotation: MKPointAnnotation {
    var imageName: String!
}
