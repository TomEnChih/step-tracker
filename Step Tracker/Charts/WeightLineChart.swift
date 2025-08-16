//
//  WeightLineChart.swift
//  Step Tracker
//
//  Created by Tom Tung on 2025/8/13.
//

import SwiftUI
import Charts

struct WeightLineChart: View {
    @State private var rawSelectedDate: Date?
    @State private var hasDayChanged: Bool = false
    
    let selectedStat: HealthMetricContext = .weight
    var chartData: [DateValueChartData]
    
    var minValue: Double {
        chartData.map { $0.value }.min() ?? 0
    }
    
    var avgValue: Double {
        ChartHelper.averageValue(for: chartData)
    }
    
    var selectedData: DateValueChartData? {
        ChartHelper.parseSelectedData(from: chartData, in: rawSelectedDate)
    }
    
    var body: some View {
        let config = ChartContainerConfiguration(title: "Weights",
                                                 symbol: "figure",
                                                 subtitle: "Avg: \(Int(avgValue)) lbs",
                                                 context: selectedStat)
        ChartContainer(config: config) {
            if chartData.isEmpty {
                ChartEmptyView(systemImageName: "chart.line.downtrend.xyaxis", title: "No Data", description: "There is no weight data from the Health App.")
            } else {
                Chart {
                    if let selectedData {
                        ChartAnnotationView(data: selectedData, context: selectedStat, isDiffChart: false)
                    }
                    
                    //Add editing
                    RuleMark(y: .value("Goal", 155))
                        .foregroundStyle(.mint)
                        .lineStyle(.init(lineWidth: 1, dash: [5]))
                        .annotation(alignment: .leading) {
                            Text("Goal")
                                .foregroundStyle(Color.secondary)
                                .font(.caption)
                        }
                    ForEach(chartData) { weight in
                        
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
                .chartXSelection(value: $rawSelectedDate)
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
        }
        .sensoryFeedback(.selection, trigger: hasDayChanged)
        .onChange(of: rawSelectedDate) { oldValue, newValue in
            if oldValue?.weekdayInt != newValue?.weekdayInt {
                hasDayChanged.toggle()
            }
        }
    }
}

#Preview {
    WeightLineChart(chartData: ChartHelper.convert(data: MockData.weights))
}
