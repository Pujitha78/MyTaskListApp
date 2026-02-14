//
//  HomeView.swift
//  MyTaskListApp
//
//  Created by Pujitha Kadiyala on 2/14/26.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var taskViewModel: TaskViewModel = TaskViewModelFactory.createTaskViewModel()
    @State private var pickerFilters: [String] = ["Active", "Completed"]
    @State private var defaultPickerSelectedItem: String = "Active"
    @State private var showAddTaskView: Bool = false
    @State private var showTaskDetailView: Bool = false
    @State private var selectedTask: Task = Task.createEmptyTask()
    @State private var showErrroAlert: Bool = false
    
    var body: some View {
        
        NavigationStack {
            
            Picker("Picker filter", selection: $defaultPickerSelectedItem) {
                ForEach(pickerFilters, id:\.self) {
                    Text($0)
                }
            }.pickerStyle(.segmented)
                .onChange(of: defaultPickerSelectedItem) { _, _ in
                    taskViewModel.getTasks(isCompleted: defaultPickerSelectedItem == "Active")
                }
            
            List(taskViewModel.tasks, id: \.id) { task in
                VStack(alignment:.leading) {
                    Text(task.name).font(.title)
                    
                    HStack {
                        Text(task.description).font(.subheadline)
                            .lineLimit(2)
                        Spacer()
                        Text(task.finishDate.toString()).font(.subheadline)
                    }
                }.onTapGesture {
                    selectedTask = task
                    showTaskDetailView.toggle()
                }
            }.onAppear{
                taskViewModel.getTasks(isCompleted: true)
            }
            .alert("Task Error",
                   isPresented: $taskViewModel.error.showError,
                     actions: {
                Button(action: {}) {
                    Text("Ok")
                }
            },
                     message: {
                Text(taskViewModel.error.errorMessage)
            })
            .listStyle(.plain)
                .navigationTitle("Home")
            
                .toolbar{
                    #if os(iOS)
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showAddTaskView = true
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                    #endif
                }
                .sheet(isPresented: $showAddTaskView) {
                    AddTaskView(taskViewModel: taskViewModel,
                                showAddTaskView: $showAddTaskView)
                }
                .sheet(isPresented: $showTaskDetailView) {
                    TaskDetailView(taskViewModel: taskViewModel,
                                   showTaskDetailView: $showTaskDetailView,
                                   selectedTask: $selectedTask)
                }
        }
    }
}

#Preview {
    HomeView()
}
