//
//  ChartType.swift
//  Step Tracker
//
//  Created by Tom Tung on 2025/8/18.
//

import Foundation

enum ChartType {
    case stepBar(average: Int)
    case stepWeekdayPie
    case weightLine(average: Double)
    case weightDiffBar
}

extension ChartType {
    var isNav: Bool {
        switch self {
        case .stepBar, .weightLine:
            return true
        case .stepWeekdayPie, .weightDiffBar:
            return false
        }
    }
    
    var context: HealthMetricContext {
        switch self {
        case .stepBar, .stepWeekdayPie:
            return .steps
        case .weightLine, .weightDiffBar:
            return .weight
        }
    }
    
    var title: String {
        switch self {
        case .stepBar:
            return "Steps"
        case .stepWeekdayPie:
            return "Averages"
        case .weightLine:
            return "Weights"
        case .weightDiffBar:
            return "Average Weight Change"
        }
    }
    
    var symbol: String {
        switch self {
        case .stepBar:
            return "figure.walk"
        case .stepWeekdayPie:
            return "calendar"
        case .weightLine:
            return "figure"
        case .weightDiffBar:
            return "figure"
        }
    }
    
    var subtitle: String {
        switch self {
        case .stepBar(let average):
            "Avg: \(average.formatted()) steps"
        case .stepWeekdayPie:
            "Last 28 Days"
        case .weightLine(let average):
            "Avg: \(average.formatted(.number.precision(.fractionLength(1)))) lbs"
        case .weightDiffBar:
            "Per Weekday (Last 28 Days)"
        }
    }
}
