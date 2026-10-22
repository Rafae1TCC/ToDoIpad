//
//  NewGroupView.swift
//
//
//  Created by Rafael Cabrera on 10/6/26.
//

import SwiftUI

struct NewGroupView: View {
    @Environment(\.dismiss) var dismiss
    @State private var groupName = ""
    @State private var selectedIcon = "list.bullet"
    let icons = ["list.bullet", "bookmark.fill", "graduationcap.fill", "cart.fill", "house.fill", "heart.fill", "star.fill", "flag.fill"]
    var onSave: (TaskGroup) -> Void
    var body: some View {
        NavigationStack {
            Form {
                Section("Group Name") {
                    TextField("Insert the name of your group", text: $groupName)
                        .accessibilityIdentifier("groupNameTextField")
                }
                
                Section("Select Icon") {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
                        ForEach(icons, id: \.self) {icon in
                            Image(systemName: icon)
                            // ADD UI DESIGN
                                .frame(width: 40, height: 40)
                                .background(selectedIcon == icon ? Color.cyan.opacity(0.2) : Color.clear)
                                .foregroundStyle(selectedIcon == icon ? Color.cyan : Color.gray)
                                .clipShape(.circle)
                                .onTapGesture {
                                    selectedIcon = icon
                                }
                                .accessibilityIdentifier("iconSelected\(icon)Btn")
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("New Group Creator")
            .toolbar{
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .accessibilityIdentifier("cancelNewGroupBtn")
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let newGroup = TaskGroup(title: groupName, symbolName: selectedIcon, tasks: [])
                        onSave(newGroup)
                        dismiss()
                    }
                    .accessibilityIdentifier("saveNewGroupBtn")
                }
            }
        }
    }
}
