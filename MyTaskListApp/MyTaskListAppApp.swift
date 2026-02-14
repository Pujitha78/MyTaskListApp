//
//  MyTaskListAppApp.swift
//  MyTaskListApp
//
//  Created by Pujitha Kadiyala on 2/14/26.
//

import SwiftUI
import CoreData

@main
struct MyTaskListAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
