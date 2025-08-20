//
//  Array+Ext.swift
//  Step Tracker
//
//  Created by Tom Tung on 2025/8/17.
//

import Foundation

extension Array where Element == Double {
    var average: Double {
        guard !self.isEmpty else { return 0 }
        let totalSteps = self.reduce(0 , +)
        return totalSteps/Double(self.count)
    }
}
