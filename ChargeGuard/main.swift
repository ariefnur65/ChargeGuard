//
//  main.swift
//  ChargeGuard
//
//  Created by ARIEF NUR PRAKOSO on 19/04/23.
//

import Foundation
import IOKit.ps

func getBatteryLevel() -> Float? {
    // Get instance of a
    let snapshot = IOPSCopyPowerSourcesInfo().takeRetainedValue()

    // Pull out a list of power sources
    let sources = IOPSCopyPowerSourcesList(snapshot).takeRetainedValue() as Array
    var maxCapacity = 0.0
    var maxCurrentCapacity = 0.0
    
    for ps in sources {
        // Fetch the information for a given power source out of our snapshot
            let info = IOPSGetPowerSourceDescription(snapshot, ps).takeUnretainedValue() as! [String: AnyObject]

            // Pull out the name and capacity
            if let name = info[kIOPSNameKey] as? String,
                let capacity = info[kIOPSCurrentCapacityKey] as? Double,
                let max = info[kIOPSMaxCapacityKey] as? Double {
                print("maxCapacity \(max), currentCapacity \(capacity), name \(name)")
                maxCurrentCapacity = capacity + maxCapacity
                maxCapacity = maxCapacity + max
            }
    }
    let batteryPercentage: Double = maxCurrentCapacity/maxCapacity
    return Float(batteryPercentage)
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
        if (batteryLevel > upperBoundPercentage){
            print("RELEASE CHARGE!!!")
        }
        if (batteryLevel < lowerBoundPercentage){
            print("Need to Charge!!!")
        }
    } else {
        print("Unable to get battery level.")
    }
    try await Task.sleep(nanoseconds: UInt64(10 * Double(NSEC_PER_SEC)))
}

