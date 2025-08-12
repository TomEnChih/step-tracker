//
//  Date+Ext.swift
//  Step Tracker
//
//  Created by Tom Tung on 2025/8/12.
//

import Foundation

extension Date {
    var weekdayInt: Int {
        return Calendar.current.component(.weekday, from: self)
    }
}
