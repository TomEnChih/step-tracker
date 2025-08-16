//
//  StepPieChart.swift
//  Step Tracker
//
//  Created by Tom Tung on 2025/8/12.
//

import SwiftUI
import Charts

struct StepPieChart: View {
    @State private var rawSelectedChartValue: Double? = 0
    @State private var hasDayChanged: Bool = false
    
    var selectedWeekday: WeekdayChartData? {
        guard let rawSelectedChartValue else { return nil }
        var total = 0.0
        
        return chartData.first {
            total += $0.value
            return rawSelectedChartValue <= total
        }
    }
    
    var selectedStat: HealthMetricContext
    var chartData: [WeekdayChartData]
    
    var body: some View {
        ChartContainer(title: "Averages", symbol: "calendar", subtitle: "Last 28 Days", context: selectedStat, isNav: false) {
            
            if chartData.isEmpty {
                ChartEmptyView(systemImageName: "chart.pie", title: "No Data", description: "There is no step count data from the Health App.")
            } else {
                Chart {
                    ForEach(chartData) { weekday in
                        SectorMark(angle: .value("Average Steps", weekday.value),
                                   innerRadius: .ratio(0.618),
                                   outerRadius: selectedWeekday?.date.weekdayInt == weekday.date.weekdayInt ? 140 : 110,
                                   angularInset: 1)
                        .foregroundStyle(selectedStat.tint.gradient)
                        .cornerRadius(6)
                        .opacity(selectedWeekday?.date.weekdayInt == weekday.date.weekdayInt ? 1.0 : 0.3)
                    }
                }
                .chartAngleSelection(value: $rawSelectedChartValue.animation(.easeInOut))
                .frame(height: 240)
                .chartBackground { proxy in
                    GeometryReader { geo in
                        if let plotFrame = proxy.plotFrame {
                            let frame = geo[plotFrame]
                            if let selectedWeekday {
                                VStack {
                                    Text(selectedWeekday.date.weekdayTitle)
                                        .font(.title3.bold())
                                        .contentTransition(.numericText())
                                    
                                    Text(selectedWeekday.value, format:
                                            .number.precision(.fractionLength(0)))
                                    .fontWeight(.medium)
                                    .foregroundStyle(.secondary)
                                    .contentTransition(.numericText())
                                }
                                .position(x: frame.midX, y: frame.midY)
                            }
                        }
                    }
                }
            }
        }
        .sensoryFeedback(.selection, trigger: hasDayChanged)
        .onChange(of: selectedWeekday) { oldValue, newValue in
            guard let oldValue, let newValue else { return }
            if oldValue.date.weekdayInt != newValue.date.weekdayInt {
                hasDayChanged.toggle()
            }
        }
    }
}

#Preview {
    StepPieChart(selectedStat: .steps,
                 chartData: ChartMath.averageWeekdayCount(for: MockData.steps))
}
