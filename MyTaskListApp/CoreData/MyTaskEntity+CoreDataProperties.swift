//
//  MyTaskEntity+CoreDataProperties.swift
//  MyTaskListApp
//
//  Created by Pujitha Kadiyala on 2/14/26.
//
//

public import Foundation
public import CoreData


public typealias MyTaskEntityCoreDataPropertiesSet = NSSet

extension MyTaskEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MyTaskEntity> {
        return NSFetchRequest<MyTaskEntity>(entityName: "MyTaskEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var taskDescription: String?
    @NSManaged public var name: String?
    @NSManaged public var finishDate: Date?
    @NSManaged public var isCompleted: Bool

}

extension MyTaskEntity : Identifiable {

}
