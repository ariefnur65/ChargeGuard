//
//  main.swift
//  ChargeGuard
//
//  Created by ARIEF NUR PRAKOSO on 19/04/23.
//

import Foundation
import IOKit.ps

var upperBoundPercentage : Float
var lowerBoundPercentage : Float

let welcomeMessage = "Welcome to axorean battery notification"
print(welcomeMessage)
let arguments = CommandLine.arguments
upperBoundPercentage = Float(arguments[1]) ?? 0
lowerBoundPercentage = Float(arguments[2]) ?? 0

print("Enter upper bound percentage: \(upperBoundPercentage)%")
print("Enter lower bound percentage: \(lowerBoundPercentage)%")


func isNotificationRing(batteryLevel: Float,
                        upperBoundPercentage : Float,
                        lowerBoundPercentage : Float ) -> Bool {
    return batteryLevel > upperBoundPercentage || batteryLevel < lowerBoundPercentage
}

func getBatteryLevel() -> Float {
    let snapshot = IOPSCopyPowerSourcesInfo().takeRetainedValue()
    let sources = IOPSCopyPowerSourcesList(snapshot).takeRetainedValue() as Array

    let percent = sources.map { source in
        IOPSGetPowerSourceDescription(snapshot, source).takeUnretainedValue() as Dictionary
    }.compactMap { description in
        description[kIOPSCurrentCapacityKey] as? Int
    }.first

    if let percent = percent {
        return Float(percent) / 100.0
    } else {
        return -1
    }
}

while(true)
{
    let batteryLevel = getBatteryLevel()
    isNotificationRing(batteryLevel, upperBoundPercentage, lowerBoundPercentage)
}

