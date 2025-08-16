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
    
    var selectedStat: HealthMetricContext
    var chartData: [WeekdayChartData]
    
    var selectedWeightMetric: WeekdayChartData? {
        guard let rawSelectedDate else { return nil }
        return chartData.first {
            Calendar.current.isDate(rawSelectedDate, inSameDayAs: $0.date)
        }
    }
    
    var body: some View {
        ChartContainer(title: "Average Weight Change", symbol: "figure", subtitle: "Per Weekday (Last 28 Days)", context: selectedStat, isNav: false) {
            
            if chartData.isEmpty {
                ChartEmptyView(systemImageName: "chart.bar", title: "No Data", description: "There is no weight data from the Health App.")
            } else {
                Chart {
                    if let selectedWeightMetric {
                        RuleMark(x: .value("Selected Metric", selectedWeightMetric.date, unit: .day))
                            .foregroundStyle(Color.secondary.opacity(0.3))
                            .offset(y: -10)
                            .annotation(position: .top,
                                        spacing: 0,
                                        overflowResolution: .init(x: .fit(to: .chart),
                                                                  y: .disabled)) { annotationView }
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
            }
        }
        .sensoryFeedback(.selection, trigger: hasDayChanged)
        .onChange(of: rawSelectedDate) { oldValue, newValue in
            if oldValue?.weekdayInt != newValue?.weekdayInt {
                hasDayChanged.toggle()
            }
        }
    }
    
    var annotationView: some View {
        VStack(alignment: .leading) {
            Text(selectedWeightMetric?.date ?? .now, format: .dateTime.weekday(.abbreviated).month(.abbreviated).day())
                .font(.footnote.bold())
                .foregroundStyle(.secondary)
            
            let value = selectedWeightMetric?.value ?? 0
            let isPositive = value >= 0
            let color = isPositive ? selectedStat.tint : Color.mint
            
            Text("\(isPositive ? "+" : "")\(value, format: .number.precision(.fractionLength(2)))")
                .fontWeight(.heavy)
                .foregroundStyle(color)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(Color(.secondarySystemBackground))
                .shadow(color: .secondary.opacity(0.3), radius: 2, x: 2, y: 2)
        )
    }
}

#Preview {
    WeightDiffBarChart(selectedStat: .weight,
                       chartData: MockData.weightDiffs)
}
