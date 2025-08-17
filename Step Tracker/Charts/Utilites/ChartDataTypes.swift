//
//  ChartDataTypes.swift
//  Step Tracker
//
//  Created by Tom Tung on 2025/8/12.
//

import Foundation

struct DateValueChartData: Identifiable, Equatable {
    let id = UUID()
    let date: Date
    let value: Double
}
