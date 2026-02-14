//
//  Untitled.swift
//  MyTaskListApp
//
//  Created by Pujitha Kadiyala on 2/14/26.
//

//factory and observer pattern

import Foundation

final class TaskViewModelFactory {
    static func createTaskViewModel() -> TaskViewModel {
        return TaskViewModel(taskRepository: TaskRepositoryImplementation())
    }
}
