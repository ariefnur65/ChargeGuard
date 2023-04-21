//
//  main.swift
//  ChargeGuard
//
//  Created by ARIEF NUR PRAKOSO on 19/04/23.
//

import Foundation
import IOKit.ps

func getBatteryLevel() -> BatteryLevelModel {
    // Get instance of a PoserSource Info
    let snapshot = IOPSCopyPowerSourcesInfo().takeRetainedValue()

    // Pull out a list of power sources
    let sources = IOPSCopyPowerSourcesList(snapshot).takeRetainedValue() as Array
    var maxCapacity = 0.0
    var maxCurrentCapacity = 0.0
    var isPlugin = false;
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
        //to get is charging state
        if let powerSourceName = info[kIOPSPowerSourceStateKey] as? String {
            isPlugin = powerSourceName == kIOPSACPowerValue
        }
            
    }
    let batteryPercentage: Double = (maxCurrentCapacity/maxCapacity) * 100
    let modelReturn = BatteryLevelModel(isPlugin: isPlugin, batteryPercentage: batteryPercentage)
    return modelReturn
}

var upperBoundPercentage : Double
var lowerBoundPercentage : Double

let welcomeMessage = "Welcome to axorean battery notification"
print(welcomeMessage)
let arguments = CommandLine.arguments
print("Enter upper bound percentage:")
upperBoundPercentage = Double(readLine()!) ?? 0
print("Enter lower bound percentage:")
lowerBoundPercentage = Double(readLine()!) ?? 0


while(true)
{
    
    print("Monitoring Battery Level... ")
    print("Max: \(upperBoundPercentage) Min: \(lowerBoundPercentage)")
    try await Task.sleep(nanoseconds: UInt64(10 * Double(NSEC_PER_SEC)))
    let batteryLevelModel: BatteryLevelModel = getBatteryLevel()
    let batteryPercentage = batteryLevelModel.batteryPercentage
    let isPlugin = batteryLevelModel.isPlugin
    print("Battery level: \(batteryPercentage)")
    if (batteryPercentage > upperBoundPercentage && isPlugin){
        print("RELEASE CHARGE!!!")
        continue
    }
    if (batteryPercentage < lowerBoundPercentage && !isPlugin){
        print("Need to Charge!!!")
        continue
    }
}

