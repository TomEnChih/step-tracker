//
//  HealthDataListView.swift
//  Step Tracker
//
//  Created by Tom Tung on 2025/8/6.
//

import SwiftUI

struct HealthDataListView: View {
    
    @Environment(HealthKitManager.self) private var hkManager
    @State private var isShowingAddData = false
    @State private var addDataDate: Date = .now
    @State private var valueToAdd = ""
    
    var metric: HealthMetricContext
    
    var listData: [HealthMetric] {
        metric == .steps ? hkManager.stepData : hkManager.weightData
    }
    
    var body: some View {
        List(listData.reversed()) { data in
            HStack {
                Text(data.date, format: .dateTime.month().day().year())
                Spacer()
                Text(data.value, format: .number.precision(.fractionLength(metric.fractionLength)))
            }
        }
        .navigationTitle(metric.title)
        .sheet(isPresented: $isShowingAddData) {
            addDataView
        }
        .toolbar {
            Button("Add Data", systemImage: "plus") {
                isShowingAddData = true
            }
        }
    }
    
    var addDataView: some View {
        NavigationStack {
            Form {
                DatePicker("Date", selection: $addDataDate, displayedComponents: .date)
                HStack {
                    Text(metric.title)
                    Spacer()
                    TextField("Value", text: $valueToAdd)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 140)
                        .keyboardType(metric == .steps ? .numberPad : .decimalPad)
                }
            }
            .navigationTitle(metric.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Data") {
                        Task {
                            switch metric {
                            case .steps:
                                do {
                                    try await hkManager.addStepData(for: addDataDate, value: Double(valueToAdd)!)
                                    try await hkManager.fetchStepCount()
                                    isShowingAddData = false
                                } catch STError.sharingDenied(let quantityType){
                                    print("❌ sharing denied for \(quantityType)")
                                } catch {
                                    print("❌ Data List View Unable to complete request")
                                }
                            case .weight:
                                do {
                                    try await hkManager.addWeightData(for: addDataDate, value: Double(valueToAdd)!)
                                    try await hkManager.fetchWeights()
                                    isShowingAddData = false
                                } catch STError.sharingDenied(let quantityType){
                                    print("❌ sharing denied for \(quantityType)")
                                } catch {
                                    print("❌ Data List View Unable to complete request")
                                }
                            }
                        }
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button("Dismiss") {
                        isShowingAddData = false
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        HealthDataListView(metric: .steps)
            .environment(HealthKitManager())
    }
}
