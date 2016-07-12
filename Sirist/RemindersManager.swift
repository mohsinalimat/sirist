//
//  RemindersManager.swift
//  rreminderstodoist
//
//  Created by Rob Reinhardt on 7/8/16.
//  Copyright © 2016 RR. All rights reserved.
//

import EventKit
import UIKit

class RemindersManager: NSObject {
    
    // MARK: - Init
    
    static let sharedInstance = RemindersManager()
    
    var store = EKEventStore()
    
    override init() {
        super.init()
        
    }
    
    // MARK: - Authorization
    
    func isAuthorized() -> Bool {
        let status = EKEventStore.authorizationStatusForEntityType(EKEntityType.Reminder)
        if status == EKAuthorizationStatus.Authorized {
            return true
        }
        return false
    }
    
    func requestAuth() -> Bool {
        store.requestAccessToEntityType(EKEntityType.Reminder) { (granted, error) -> Void in
            if (granted) {
                NSNotificationCenter.defaultCenter().postNotificationName("authorizationUpdate", object: nil)
            }
        }
        return true
    }
    
    // MARK: - Get Reminders
    
    func getRemindersInBackground() {
        
        if EKEventStore.authorizationStatusForEntityType(EKEntityType.Reminder) != .Authorized {
            return
        }
        
        let predicate = store.predicateForIncompleteRemindersWithDueDateStarting(nil, ending: nil, calendars: nil)
        
        store.fetchRemindersMatchingPredicate(predicate) { (reminders) -> Void in
            guard let reminders = reminders else { return }
            for reminder in reminders {
                ToDoistManager.sharedInstance.addTaskInBackground(reminder)
            }
        }
        
    }
    
    func getReminders() {
        
        if EKEventStore.authorizationStatusForEntityType(EKEntityType.Reminder) != .Authorized {
            return
        }
        
        let predicate = store.predicateForIncompleteRemindersWithDueDateStarting(nil, ending: nil, calendars: nil)
        
        store.fetchRemindersMatchingPredicate(predicate) { (reminders) -> Void in
            guard let reminders = reminders else { return }
            for reminder in reminders {
                ToDoistManager.sharedInstance.addTask(reminder)
            }
        }
        
    }
    
    // MARK: - Remove Reminders
    
    func removeReminderByTitle(title: String) {
        if EKEventStore.authorizationStatusForEntityType(EKEntityType.Reminder) != .Authorized {
            return
        }
        
        let predicate = store.predicateForIncompleteRemindersWithDueDateStarting(nil, ending: nil, calendars: nil)
        
        store.fetchRemindersMatchingPredicate(predicate) { (reminders) in

            guard let filteredReminders = reminders?.filter({ (reminder) -> Bool in
                
                if reminder.title == title {
                    return true
                }
                return false
            }) else {return }

            for reminder in filteredReminders {
                reminder.completed = true
                self.saveReminder(reminder)
            }
            
        }
        
    }
    
    func removeReminderById(taskID: String) {
        if let task = RemindersManager.sharedInstance.store.calendarItemWithIdentifier(taskID) as? EKReminder {
            task.completed = true
            saveReminder(task)
        }
    }
    
    // MARK: - Save Reminder Updates
    
    func saveReminder(task: EKReminder) {
        do {
            try store.saveReminder(task, commit: true)
            print("success with saving task update")
        } catch {
            print("error with save — \(error)")
        }
    }

}
