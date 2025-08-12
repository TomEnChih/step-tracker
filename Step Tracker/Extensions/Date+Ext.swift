//
//  Date+Ext.swift
//  Step Tracker
//
//  Created by Tom Tung on 2025/8/12.
//

import Foundation

extension Date {
    var weekdayInt: Int {
        Calendar.current.component(.weekday, from: self)
    }
    
    var weekdayTitle: String {
        self.formatted(.dateTime.weekday(.wide))
    }
}
