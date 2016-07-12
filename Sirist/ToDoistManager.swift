//
//  ToDoistManager.swift
//  rreminderstodoist
//
//  Created by Rob Reinhardt on 7/8/16.
//  Copyright © 2016 RR. All rights reserved.
//

import UIKit
import EventKitUI

class ToDoistManager: NSObject, NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDownloadDelegate {
    
    // MARK: Initialization
    
    static let sharedInstance = ToDoistManager()
    private override init() {}

    // MARK:- URLS
    
    /// URL To add Items @ Todoist
    let addItemUrl = NSURL(string: "https://todoist.com/API/v7/add_item")

    // MARK: - Reminders <-> Defaults
    
    func queryQueuedReminders(collection: String) -> [String] {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if (defaults.objectForKey(collection) == nil){
            defaults.setObject([], forKey: collection)
        }
        
        if let reminders = defaults.objectForKey(collection) as? [String] {
            return reminders
        }
        return []
    }
    
    func taskAlreadyQueued(task: EKReminder) -> Bool {
        if queryQueuedReminders("queue").contains(task.calendarItemIdentifier) {
            return true
        }
        else {
            addReminderToQueue(task.calendarItemIdentifier, collection: "queue")
        }
        return false
    }
    
    func addReminderToQueue(taskIdentifier: String, collection: String) {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let reminders = defaults.objectForKey(collection) as? [String] {
            var newReminders = reminders
                newReminders.append(taskIdentifier)
            defaults.setObject(newReminders, forKey: collection)
            defaults.synchronize()
        }
        
    }
    
    
    func removeItemFromQueue(taskIdentifier: String, collection: String) {
        

        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let reminders = defaults.objectForKey(collection) as? [String] {
            
            let filteredReminders = reminders.filter() {$0 != taskIdentifier}
            
            defaults.setObject(filteredReminders, forKey: collection)
            defaults.synchronize()
            
        }
        
    }
    
    // MARK: - Adding Tasks
    
    func addTask(task: EKReminder){

        if taskAlreadyQueued(task) { return }
        
        guard let token = APIManager.sharedInstance.getToken() else { return }
        
        let title = "\(task.title) • _via Sirist_"
        let postdata = "token=\(token)&content=\(title)"

        
        let request = NSMutableURLRequest(URL: addItemUrl!)
        request.HTTPMethod = "POST"
        request.HTTPBody = postdata.dataUsingEncoding(NSUTF8StringEncoding)
        request.setValue(task.title, forHTTPHeaderField: "x-sirist-task-title")
                    
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()

        let transfer = NSURLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        
        let task = transfer.downloadTaskWithRequest(request)
        
        task.resume()
        
    }
    
    func addTaskInBackground(task: EKReminder){
        
        if taskAlreadyQueued(task) { return }
        
        guard let token = APIManager.sharedInstance.getToken() else { return }
        
        let title = "\(task.title) • _via Sirist_"
        let postdata = "token=\(token)&content=\(title)"
        
            
        let request = NSMutableURLRequest(URL: addItemUrl!)
        request.HTTPMethod = "POST"
        request.HTTPBody = postdata.dataUsingEncoding(NSUTF8StringEncoding)
        request.setValue(task.title, forHTTPHeaderField: "x-sirist-task-title")
        
        let configuration = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier(task.calendarItemIdentifier)
        
        let transfer = NSURLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        
        let task = transfer.downloadTaskWithRequest(request)
        
        task.resume()
        
    }
    
    // MARK: - NSURLSession Mgmt

    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        if error != nil {
            print("didCompleteWithError: \(error.debugDescription)")
        }
        session.finishTasksAndInvalidate()
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        print("didFinishDownloadingToURL")
        
        // Remove Task via title (not ideal)
        if let taskTitle = downloadTask.originalRequest?.valueForHTTPHeaderField("x-sirist-task-title") {
            RemindersManager.sharedInstance.removeReminderByTitle(taskTitle)
        }
        
        // Remove Task via identifier (original solution but unreliable due to changing identifier)
        if let calendarIdentifier = session.configuration.identifier {
            RemindersManager.sharedInstance.removeReminderByTitle(calendarIdentifier)
        }
        session.finishTasksAndInvalidate()
    }

    func URLSessionDidFinishEventsForBackgroundURLSession(session: NSURLSession) {
        print("URLSessionDidFinishEventsForBackgroundURLSession")
        if let calendarIdentifier = session.configuration.identifier {
            removeItemFromQueue(calendarIdentifier, collection: "queue")
        }
        session.finishTasksAndInvalidate()
    }
    
}
