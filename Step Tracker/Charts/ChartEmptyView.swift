//
//  ChartEmptyView.swift
//  Step Tracker
//
//  Created by Tom Tung on 2025/8/15.
//

import SwiftUI

struct ChartEmptyView: View {
    var systemImageName: String
    var title: String
    var description: String
    
    var body: some View {
        ContentUnavailableView {
            Image(systemName: systemImageName)
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding(.bottom, 8)
            
            Text(title)
                .font(.callout.bold())
            
            Text(description)
                .font(.footnote)
        }
        .foregroundStyle(.secondary)
        .offset(y: -12)
    }
}

#Preview {
    ChartEmptyView(systemImageName: "chart.bar",
                   title: "No Data",
                   description: "There is no data.")
}
