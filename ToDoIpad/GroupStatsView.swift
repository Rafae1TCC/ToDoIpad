//
//  GroupStatsView.swift
//  
//
//  Created by Rafael Cabrera on 10/6/26.
//

import SwiftUI

struct GroupStatsView: View {
    var tasks: [TaskItem]
    var completedTasks: Int { tasks.filter {$0.isCompleted}.count }
    var progress: Double { tasks.isEmpty ? 0 : Double(completedTasks) / Double(tasks.count) }
    
    var body: some View {
        HStack{
            ZStack{
                Circle()
                    .stroke(lineWidth:10)
                    .opacity(0.3)
                    .foregroundColor(.cyan)
                Circle()
                    .trim(from: 0.0, to: progress)
                    .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .foregroundColor(.cyan)
                    .rotationEffect(.degrees(-90))
                Text("\(Int(progress * 100))%")
                    .font(.caption)
                    .bold()
            }
            .frame(width: 60, height: 60)
            .padding()
            
            VStack{
                Text("Progress of the Tasks")
                    .font(.headline)
                Text("\(completedTasks) / \(tasks.count) Completed")
                    .font(.title2)
            }
            Spacer()
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}
