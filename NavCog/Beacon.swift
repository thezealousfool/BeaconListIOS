//
//  Beacon.swift
//  NavCog
//
//  Created by Harsh Agarwal on 11/7/19.
//  Copyright © 2019 Vivek Roy. All rights reserved.
//

import Foundation


class Beacon {
    var major : Int
    var minor : Int
    var rssi : Int
    
    init(major : Int, minor : Int, rssi : Int) {
        self.major = major
        self.minor = minor
        self.rssi = rssi
    }
}
