//
//  DashboardView.swift
//  Step Tracker
//
//  Created by Tom Tung on 2025/8/6.
//

import SwiftUI
import Charts

enum HealthMetricContext: CaseIterable, Identifiable {
    case steps,weight
    var id: Self { self }
    
    var title: String {
        switch self {
        case .steps: "Steps"
        case .weight: "Weight"
        }
    }
    
    var tint: Color {
        switch self {
        case .steps: .pink
        case .weight: .indigo
        }
    }
    
    var fractionLength: Int {
        switch self {
        case .steps: 0
        case .weight: 1
        }
    }
}

struct DashboardView: View {
    
    @Environment(HealthKitManager.self) private var hkManager
    @AppStorage("hasSeenPermissionPriming") private var hasSeenPermissionPriming = false
    @State private var isShowingPermissionPrimingSheet = false
    @State private var selectedStat: HealthMetricContext = .steps
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    Picker("Selected Stat", selection: $selectedStat) {
                        ForEach(HealthMetricContext.allCases) { metric in
                            Text(metric.title)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    switch selectedStat {
                    case .steps:
                        StepBarChart(selectedStat: selectedStat,
                                     chartData: hkManager.stepData)
                        StepPieChart(selectedStat: selectedStat,
                                     chartData: ChartMath.averageWeekdayCount(for: hkManager.stepData))
                    case .weight:
                        WeightLineChart(selectedStat: selectedStat,
                                        chartData: hkManager.weightData)
                        WeightDiffBarChart(selectedStat: selectedStat,
                                           chartData: ChartMath.averageDailyWeightDiffs(for: hkManager.weightData))
                    }
                }
            }
            .padding()
            .task {
                await hkManager.fetchStepCount()
                await hkManager.fetchWeights()
                isShowingPermissionPrimingSheet = !hasSeenPermissionPriming
            }
            .navigationTitle("Dashboard")
            .navigationDestination(for: HealthMetricContext.self) { metric in
                HealthDataListView(metric: metric)
            }
            .sheet(isPresented: $isShowingPermissionPrimingSheet) {
                // fetch health data
            } content: {
                HealthKitPermissionPrimingView(hasSeen: $hasSeenPermissionPriming)
            }

        }
        .tint(selectedStat.tint)
    }
}

#Preview {
    DashboardView()
        .environment(HealthKitManager())
}
