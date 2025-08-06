//
//  HealthKitManager.swift
//  Step Tracker
//
//  Created by Tom Tung on 2025/8/6.
//

import Foundation
import HealthKit
import Observation

@Observable class HealthKitManager {
    
    let store = HKHealthStore()
    
    let types: Set = [HKQuantityType(.stepCount), HKQuantityType(.bodyMass)]
}
