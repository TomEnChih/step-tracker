//
//  ChartContainer.swift
//  Step Tracker
//
//  Created by Tom Tung on 2025/8/16.
//

import SwiftUI

struct ChartContainer<Content: View>: View {
    let title: String
    let symbol: String
    let subtitle: String
    let context: HealthMetricContext
    var isNav: Bool = true
    
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading) {
            if isNav {
                navigationLinkView
            } else {
                titleView
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 12)
            }
            content()
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
    }
    
    var navigationLinkView: some View {
        NavigationLink(value: context) {
            HStack() {
                titleView
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
            }
        }
        .foregroundStyle(.secondary)
        .padding(.bottom, 12)
    }
    
    var titleView: some View {
        VStack(alignment: .leading) {
            Label(title, systemImage: symbol)
                .font(.title3.bold())
                .foregroundStyle(context.tint)
            
            Text(subtitle)
                .font(.caption)
        }
    }
}

#Preview {
    ChartContainer(title: "test title",
                   symbol: "figure.walk",
                   subtitle: "test subtitle",
                   context: .steps,
                   isNav: true) {
        Text("Chart Goes Here")
            .frame(minHeight: 150)
    }
}
