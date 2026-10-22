//
//  ContentView.swift
//  ToDoIpad
//
//  Created by Rafael Cabrera on 10/6/26.
//

import SwiftUI

struct ContentView: View {
    @State private var taskGroups: [TaskGroup] = []
    @State private var selectedGroup: TaskGroup? // selected group
    @State private var columnVisibility: NavigationSplitViewVisibility = .all // navigation side panel
    @State private var isShowingAddGroup = false
    @Environment(\.scenePhase) private var scenePhase
    @AppStorage("isDarkMode") private var isDarkMode = false
    let saveKey = "savedTaskGroups"
    @Binding var profile: Profile
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            // SIDEBAR
            List(selection: $selectedGroup) {
                ForEach(profile.groups) {group in
                    NavigationLink(value: group) {
                        Label(group.title, systemImage: group.symbolName)
                    }
                    .accessibilityIdentifier("group\(group.title)Btn")
                }
            }
            .accessibilityIdentifier("groupsList")
            .navigationTitle(profile.name)
            .listStyle(.sidebar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        isDarkMode.toggle()
                    } label: {
                        Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill")
                    }
                    .accessibilityIdentifier("darkModeBtn")
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isShowingAddGroup = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityIdentifier("addGroupBtn")
                }
            }
        } detail: {
            if let group = selectedGroup {
                if let index = profile.groups.firstIndex(where: { $0.id == group.id }) {
                    TaskGroupDetailView(groups: $profile.groups[index])
                }
            } else {
                ContentUnavailableView("Select a Group", systemImage: "sidebar.leading")
                    .accessibilityIdentifier("selectGroupLbl")
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $isShowingAddGroup) {
            NewGroupView { newGroup in
                profile.groups.append(newGroup)
            }
        }
        .onAppear {
            loadData()
        }
        .onChange(of: scenePhase) { oldValue, newValue in
            if newValue == .active {
                print("🟢 App is Active")
            } else if newValue == .inactive {
                print("🟡 App is Inactive")
            } else if newValue == .background {
                print("🔴 App is Background - Saving Data!")
                saveData()
            }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)

    }
    
    func saveData() {
        if let encodedData = try? JSONEncoder().encode(profile.groups){
            UserDefaults.standard.set(encodedData, forKey: saveKey)
        }
    }
    
    func loadData() {
        if let savedData = UserDefaults.standard.data(forKey: saveKey){
            if let decodedGrpups = try? JSONDecoder().decode([TaskGroup].self, from: savedData) {
                profile.groups = decodedGrpups
                return
            }
        }
        
        // show mock data for dev purposes
        profile.groups = TaskGroup.sampleData
    }
}
