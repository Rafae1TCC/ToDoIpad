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
    let icons = ["list.bullet","star.fill","heart.fill","graduationcap.fill","house.fill"]
    var onSave: (TaskGroup) -> Void
    
    var body: some View{
        NavigationStack{
            Form{
                Section("Group Name"){
                    TextField("Enter the name of your group", text: $groupName)
                }
                
                Section("Select Icon") {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
                        ForEach(icons, id: \.self) { icon in
                            Image(systemName: icon)
                                .font(.title2)
                                .frame(width: 40, height: 40)
                                .background(selectedIcon == icon ? Color.blue.opacity (0.2) : Color.clear)
                                .foregroundStyle(selectedIcon == icon ? Color.orange : Color.gray)
                                .clipShape(Circle())
                                .onTapGesture{
                                    selectedIcon = icon
                                }
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("New Group Form")
            .toolbar{
                ToolbarItem(placement: .cancellationAction){
                    Button("Cancel") { dismiss()}
                }
                ToolbarItem(placement: .confirmationAction){
                    Button("Save") {
                        let newGroup = TaskGroup(title: groupName, symbolName:
                                                    selectedIcon, tasks: [])
                        onSave(newGroup)
                        dismiss()
                    }
                    .disabled(groupName.isEmpty)
                }
            }
        }
    }
}
