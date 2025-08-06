//
//  HealthDataListView.swift
//  Step Tracker
//
//  Created by Tom Tung on 2025/8/6.
//

import SwiftUI

struct HealthDataListView: View {
    
    @State private var isShowingAddData = false
    @State private var addDataDate: Date = .now
    @State private var valueToAdd = ""
    
    
    var metric: HealthMetricContext
    
    var body: some View {
        List(1..<10) { i in
            HStack {
                Text(Date(), format: .dateTime.month().day().year())
                Spacer()
                Text(10000, format: .number.precision(.fractionLength(metric.fractionLength)))
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
                        // Do code later
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
    }
}
