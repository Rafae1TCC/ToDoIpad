//
//  GroupStatsView.swift
//
//
//  Created by Rafael Cabrera on 10/6/26.
//

import SwiftUI

struct GroupStatsView: View {
    @Environment(\.layoutDirection) var layoutDirection
    var tasks: [TaskItem]
    var completedCount: Int { tasks.filter {$0.isCompleted}.count }
    var progress: Double { tasks.isEmpty ? 0 : Double(completedCount) / Double(tasks.count)}
    
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .stroke(lineWidth: 10)
                    .opacity(0.3)
                    .foregroundColor(.cyan)
                
                Circle()
                    .trim(from: 0.0, to: progress)
                    .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .foregroundColor(.cyan)
                    .rotationEffect(.degrees(-90))
                    .scaleEffect(x: layoutDirection == .rightToLeft ? -1 : 1)
                
                Text(progress, format: .percent.precision(.fractionLength(0)))
                    .font(.caption)
                    .bold()
                    .accessibilityIdentifier("progressPercentLbl")
            }
            .frame(width: 60, height: 60)
            .padding()
            
            VStack(alignment: .leading) {
                Text("Task Progress")
                    .font(.headline)
                    .accessibilityIdentifier("taskProgressLbl")
                Text("\(completedCount) / \(tasks.count) Completed")
                    .accessibilityIdentifier("completedCountLbl")
            }
            Spacer()
        }
        .padding()
        .background(Color(.secondarySystemBackground))
    }
}
