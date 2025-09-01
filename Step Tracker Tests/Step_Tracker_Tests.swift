//
//  Step_Tracker_Tests.swift
//  Step Tracker Tests
//
//  Created by Tom Tung on 2025/9/1.
//

import XCTest
@testable import Step_Tracker

final class Step_Tracker_Tests: XCTestCase {
    
    var metrics: [HealthMetric] = [
        .init(date: Calendar.current.date(from: .init(year: 2024, month: 10, day: 14))!, value: 1000), // Monday
        .init(date: Calendar.current.date(from: .init(year: 2024, month: 10, day: 15))!, value: 500), // Tuesday
        .init(date: Calendar.current.date(from: .init(year: 2024, month: 10, day: 16))!, value: 250), // Wednesday
        .init(date: Calendar.current.date(from: .init(year: 2024, month: 10, day: 21))!, value: 750) // Monday
    ]
    
    func test_arrayAverage() {
        let array: [Double] = [2.0, 3.1, 0.45, 1.84]
        XCTAssertEqual(array.average, 1.8475)
    }
    
    func test_averageWeekdayCount() {
        let avergeWeekdayCount = ChartHelper.averageWeekdayCount(for: metrics)
        XCTAssertEqual(avergeWeekdayCount.count, 3)
        XCTAssertEqual(avergeWeekdayCount[0].value, 875)
        XCTAssertEqual(avergeWeekdayCount[1].value, 500)
        XCTAssertEqual(avergeWeekdayCount[2].date.weekdayTitle, "Wednesday")
    }
}
