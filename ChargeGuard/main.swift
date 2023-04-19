//
//  main.swift
//  ChargeGuard
//
//  Created by ARIEF NUR PRAKOSO on 19/04/23.
//

import Foundation
import IOKit.ps

func getBatteryLevel() -> Float? {
    let powerSources = IOPSCopyPowerSourcesInfo().takeRetainedValue()
    let powerSourcesList = IOPSCopyPowerSourcesList(powerSources).takeRetainedValue()
    
    var batteryLevel: Float?
    
    for i in 0 ..< CFArrayGetCount(powerSourcesList) {
        let powerSource = CFArrayGetValueAtIndex(powerSourcesList, i)
        let info = IOPSGetPowerSourceDescription(powerSources.takeRetainedValue(), powerSource as! CFTypeRef).takeUnretainedValue() as! [String: Any]
        
        if let currentCapacity = info[kIOPSCurrentCapacityKey] as? Int,
           let maxCapacity = info[kIOPSMaxCapacityKey] as? Int {
            batteryLevel = Float(currentCapacity) / Float(maxCapacity)
            break
        }
    }
    
    return batteryLevel
}

var upperBoundPercentage : Float
var lowerBoundPercentage : Float

let welcomeMessage = "Welcome to axorean battery notification"
print(welcomeMessage)
let arguments = CommandLine.arguments
print("Enter upper bound percentage:")
upperBoundPercentage = Float(readLine()!) ?? 0
print("Enter lower bound percentage:")
lowerBoundPercentage = Float(readLine()!) ?? 0


while(true)
{
    let batteryLevel = getBatteryLevel()
    
    if let batteryLevel = batteryLevel {
        print("Battery level: \(batteryLevel)")
    } else {
        print("Unable to get battery level.")
    }
    try await Task.sleep(nanoseconds: UInt64(10 * Double(NSEC_PER_SEC)))
}

