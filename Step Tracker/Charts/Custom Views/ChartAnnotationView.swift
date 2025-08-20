//
//  ChartAnnotationView.swift
//  Step Tracker
//
//  Created by Tom Tung on 2025/8/16.
//

import SwiftUI
import Charts

struct ChartAnnotationView: ChartContent {
    let data: DateValueChartData
    let context: HealthMetricContext
    let isDiffChart: Bool
    
    var fractionLength: Int {
        switch  isDiffChart {
        case true:  return 2
        case false:
            switch context {
            case .steps:    return 0
            case .weight:   return 1
            }
        }
    }
    
    var body: some ChartContent {
        RuleMark(x: .value("Selected Metric", data.date, unit: .day))
            .foregroundStyle(Color.secondary.opacity(0.3))
            .offset(y: -10)
            .annotation(position: .top,
                        spacing: 0,
                        overflowResolution: .init(x: .fit(to: .chart),
                                                  y: .disabled)) { annotationView }
    }
    
    var annotationView: some View {
        VStack(alignment: .leading) {
            Text(data.date, format: .dateTime.weekday(.abbreviated).month(.abbreviated).day())
                .font(.footnote.bold())
                .foregroundStyle(.secondary)
            
            if isDiffChart {
                let isPositive = data.value >= 0
                let color = isPositive ? context.tint : Color.mint
                
                Text("\(isPositive ? "+" : "")\(data.value, format: .number.precision(.fractionLength(fractionLength)))")
                    .fontWeight(.heavy)
                    .foregroundStyle(color)
            } else {
                Text(data.value, format: .number.precision(.fractionLength(fractionLength)))
                    .fontWeight(.heavy)
                    .foregroundStyle(context.tint)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(Color(.secondarySystemBackground))
                .shadow(color: .secondary.opacity(0.3), radius: 2, x: 2, y: 2)
        )
    }
}
