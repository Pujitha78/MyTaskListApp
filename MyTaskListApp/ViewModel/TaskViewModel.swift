//
//  TaskViewModel.swift
//  MyTaskListApp
//
//  Created by Pujitha Kadiyala on 2/14/26.
//

import Foundation
import Combine

struct TaskViewModelError {
    var errorMessage: String = ""
    var showError: Bool = false
}

final class TaskViewModel : ObservableObject {
    
    @Published var tasks: [Task] = []
    @Published var error: TaskViewModelError = TaskViewModelError()
    
    private let taskRepository: TaskRepository
    private var taskState: Bool = false
    private var cancellable = Set<AnyCancellable>()
    var shouldDismissView = PassthroughSubject<Bool, Never>()
    
    init(taskRepository: TaskRepository) {
        self.taskRepository = taskRepository
    }
    
    deinit{ cancellable.forEach { $0.cancel() } }
    
    func getTasks(isCompleted: Bool) {
        taskState = isCompleted
        taskRepository.get(isCompleted: !isCompleted)
            .sink { [weak self] fetchOperationResult in
                switch fetchOperationResult {
                case .success(let fetchedTasks):
                    self?.tasks = fetchedTasks
                case .failure(let failure):
                    self?.processOperationError(failure)
                }
            }.store(in: &cancellable)
    }
    
    func addTask(task: Task) {
        self.taskRepository.add(task: task)
            .sink {[weak self] addOperationResult in
                self?.processOperationResult(operationResult: addOperationResult)
            }.store(in: &self.cancellable)
    }
    
    func updateTask(task: Task) {
        taskRepository.update(task: task).sink { [weak self] updateOperationResult in
            self?.processOperationResult(operationResult: updateOperationResult)
        }.store(in: &cancellable)
    }
    
    func deleteTask(task: Task) {
        taskRepository.delete(task: task).sink {[weak self] deleteOperationResult in
            self?.processOperationResult(operationResult: deleteOperationResult)
        }.store(in: &cancellable)
    }
    
    private func processOperationResult(operationResult: Result<Bool, TaskRepositoryError>) {
        switch operationResult {
        case .success(_):
            self.getTasks(isCompleted: taskState)
            shouldDismissView.send(true)
        case .failure(let failure):
            self.processOperationError(failure)
        }
    }
    
    private func processOperationError(_ error: TaskRepositoryError) {
        switch error {
        case .operationFailure(let errorMessage):
            self.error.errorMessage = errorMessage
            self.error.showError = true
        }
    }
}
