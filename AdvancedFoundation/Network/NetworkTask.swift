/**
 * NetworkTask is a customized task.
 * - author: Adamas
 * - version: 1.0.0
 * - date: 05/05/2017
 */
class NetworkTask {
    
    /**
     * The cache of the task.
     */
    var cache: NSMutableData
    
    /**
     * The task type of the task.
     */
    var type: NetworkTaskType {
        if task is URLSessionDownloadTask {
            return .download
        } else if task is URLSessionUploadTask {
            return .upload
        } else if task is URLSessionStreamTask {
            return .stream
        } else {
            return .data
        }
    }
    
    /**
     * The id of the task.
     */
    private (set) var identifier: String
    
    /**
     * The task.
     */
    private (set) var task: URLSessionTask

    /**
     * Initialize the object.
     * - parameter task: The task object.
     */
    init(withTask task: URLSessionTask) {
        self.task = task
        identifier = IDGenerator.standard.generateID()
        cache = NSMutableData()
    }
    
}

import Foundation


