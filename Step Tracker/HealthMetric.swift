//
//  HealthMetric.swift
//  Step Tracker
//
//  Created by Tom Tung on 2025/8/10.
//

import Foundation

struct HealthMetric: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
}
