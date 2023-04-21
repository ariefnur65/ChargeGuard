//
//  BatteryLevelModel.swift
//  ChargeGuard
//
//  Created by ARIEF NUR PRAKOSO on 21/04/23.
//

import Foundation

class BatteryLevelModel {
    var isPlugin = false
    var batteryPercentage = 0.0
    
    init(isPlugin: Bool = false, batteryPercentage: Double = 0.0) {
        self.isPlugin = isPlugin
        self.batteryPercentage = batteryPercentage
    }
}
