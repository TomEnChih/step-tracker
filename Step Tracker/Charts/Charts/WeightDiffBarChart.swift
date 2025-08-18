//
//  WeightDiffBarChart.swift
//  Step Tracker
//
//  Created by Tom Tung on 2025/8/14.
//

import SwiftUI
import Charts

struct WeightDiffBarChart: View {
    @State private var rawSelectedDate: Date?
    @State private var hasDayChanged: Bool = false
    
    let selectedStat: HealthMetricContext = .weight
    var chartData: [DateValueChartData]
    
    var selectedData: DateValueChartData? {
        ChartHelper.parseSelectedData(from: chartData, in: rawSelectedDate)
    }
    
    var body: some View {
        ChartContainer(chartType: .weightDiffBar) {
            Chart {
                if let selectedData {
                    ChartAnnotationView(data: selectedData, context: selectedStat, isDiffChart: true)
                }
                
                ForEach(chartData) { weekday in
                    BarMark(x: .value("Date", weekday.date, unit: .day),
                            y: .value("Weight Diff", weekday.value))
                    .foregroundStyle(weekday.value >= 0 ? selectedStat.tint.gradient : Color.mint.gradient)
                }
            }
            .frame(height: 240)
            .chartXSelection(value: $rawSelectedDate.animation(.easeInOut))
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) {
                    AxisValueLabel(format: .dateTime.weekday(), centered: true)
                }
            }
            .chartYAxis {
                AxisMarks { value in
                    AxisGridLine()
                        .foregroundStyle(Color.secondary.opacity(0.3))
                    AxisValueLabel()
                }
            }
            .overlay {
                if chartData.isEmpty {
                    ChartEmptyView(systemImageName: "chart.bar", title: "No Data", description: "There is no weight data from the Health App.")
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
    WeightDiffBarChart(chartData: MockData.weightDiffs)
}
