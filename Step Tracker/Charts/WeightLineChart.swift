//
//  WeightLineChart.swift
//  Step Tracker
//
//  Created by Tom Tung on 2025/8/13.
//

import SwiftUI
import Charts

struct WeightLineChart: View {
    
    var selectedStat: HealthMetricContext
    var chartData: [HealthMetric]
    
    var minValue: Double {
        chartData.map { $0.value }.min() ?? 0
    }
    
    var body: some View {
        VStack {
            NavigationLink(value: selectedStat) {
                HStack() {
                    VStack(alignment: .leading) {
                        Label("Steps", systemImage: "figure")
                            .font(.title3.bold())
                            .foregroundStyle(selectedStat.tint)
                        
                        Text("Avg: 180 lbs")
                            .font(.caption)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.caption)
                }
            }
            .foregroundStyle(.secondary)
            .padding(.bottom, 12)
            
            Chart {
                ForEach(chartData) { weight in
                    //Add editing
                    RuleMark(y: .value("Goal", 155))
                        .foregroundStyle(.mint)
                        .lineStyle(.init(lineWidth: 1, dash: [5]))
                        .annotation(alignment: .leading) {
                            Text("Goal")
                                .foregroundStyle(Color.secondary.opacity(0.1))
                                .font(.caption)
                        }
                    
                    AreaMark(x: .value("Day", weight.date, unit: .day),
                             yStart: .value("Value", weight.value),
                             yEnd: .value("Min Value", minValue))
                    .foregroundStyle(Gradient(colors: [selectedStat.tint.opacity(0.5), .clear]))
                    .interpolationMethod(.catmullRom)
                    
                    
                    LineMark(x: .value("Day",  weight.date, unit: .day),
                             y: .value("Value", weight.value))
                    .foregroundStyle(selectedStat.tint)
                    .interpolationMethod(.catmullRom)
                    .symbol(.circle)
                    
                }
            }
            .frame(height: 150)
            .chartYScale(domain: .automatic(includesZero: false))
            .chartXAxis {
                AxisMarks {
                    AxisValueLabel(format: .dateTime.month(.defaultDigits).day())
                }
            }
            .chartYAxis {
                AxisMarks { value in
                    AxisGridLine()
                        .foregroundStyle(Color.secondary.opacity(0.3))
                    AxisValueLabel()
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
    }
}

#Preview {
    WeightLineChart(selectedStat: .weight, chartData: MockData.weights)
}
