//
//  StepBarChart.swift
//  Step Tracker
//
//  Created by Tom Tung on 2025/8/12.
//

import SwiftUI
import Charts

struct StepBarChart: View {
    @State private var rawSelectedDate: Date?
    @State private var hasDayChanged: Bool = false
    
    let selectedStat: HealthMetricContext = .steps
    var chartData: [DateValueChartData]
    
    var avgValue: Double {
        ChartHelper.averageValue(for: chartData)
    }
    
    var selectedData: DateValueChartData? {
        ChartHelper.parseSelectedData(from: chartData, in: rawSelectedDate)
    }
    
    var body: some View {
        ChartContainer(title: "Steps", symbol: "figure.walk", subtitle: "Avg: \(Int(avgValue)) steps", context: selectedStat) {
            
            if chartData.isEmpty {
                ChartEmptyView(systemImageName: "chart.bar",
                               title: "No Data",
                               description: "There is no step count data from the Health App.")
            } else {
                Chart {
                    if let selectedData {
                        RuleMark(x: .value("Selected Metric", selectedData.date, unit: .day))
                            .foregroundStyle(Color.secondary.opacity(0.3))
                            .offset(y: -10)
                            .annotation(position: .top,
                                        spacing: 0,
                                        overflowResolution: .init(x: .fit(to: .chart),
                                                                  y: .disabled))
                        {
                            ChartAnnotationView(data: selectedData, context: selectedStat, isDiffChart: false)
                        }
                    }
                    
                    RuleMark(y: .value("Average", avgValue))
                        .foregroundStyle(Color.secondary)
                        .lineStyle(.init(lineWidth: 1, dash: [5]))
                    
                    ForEach(chartData) { steps in
                        BarMark(x: .value("Date", steps.date, unit: .day),
                                y: .value("Steps", steps.value)
                        )
                        .foregroundStyle(selectedStat.tint.gradient)
                        .opacity(rawSelectedDate == nil || steps.date == selectedData?.date ? 1.0 : 0.3)
                    }
                }
                .frame(height: 150)
                .chartXSelection(value: $rawSelectedDate.animation(.easeInOut))
                .chartXAxis {
                    AxisMarks {
                        AxisValueLabel(format: .dateTime.month(.defaultDigits).day())
                    }
                }
                .chartYAxis {
                    AxisMarks { value in
                        AxisGridLine()
                            .foregroundStyle(Color.secondary.opacity(0.3))
                        
                        AxisValueLabel((value.as(Double.self) ?? 0).formatted(.number.notation(.compactName)))
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
    StepBarChart(chartData: ChartHelper.convert(data: MockData.steps))
}
