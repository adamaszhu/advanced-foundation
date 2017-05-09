/**
 * NetowrkHelper is used to perform basic level internet connection.
 * - author: Adamas
 * - version: 1.0.0
 * - date: 04/05/2017
 */
public class NetworkHelper: NSObject {
    
    /**
     * System error.
     */
    private let urlError = "The url address is invalid."
    private let taskError = "The task doesn't exist."
    private let taskTypeError = "The task type hasn't been supported yet."
    let internetError = "InternetError"
    let serverError = "ServerError"
    let appError = "AppError"
    let serverSideError = "The server cannot deal with the request."
    let responseTypeError = "The response is not a http url response."
    let fileSystemError = "The downloaded file cannot be moved to the sandbox."
    
    /**
     * System document directory. Which is used to store downloaded files.
     */
    let documentDirectory = "Documents"
    
    /**
     * The delegate of the NetworkHelper.
     */
    public var networkHelperDelegate: NetworkHelperDelegate?
    
    /**
     * The task list.
     */
    private var tasks: Array<NetworkTask>
    
    /**
     * The session connecting to the network.
     */
    private var normalSession: URLSession
    
    /**
     * The session used to download or upload in background mode.
     */
    private var backgroundSession: URLSession
    
    /**
     * The cache used in the app.
     */
    private var cache: URLCache
    
    /**
     * Whether the network is available or not. This method is referenced from http://stackoverflow.com/questions/39558868/check-internet-connection-ios-10
     */
    public static var isNetworkAvailable: Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    /**
     * Initialize the object.
     * - parameter identifier: The identifier used to identify the URL session running in the background.
     */
    public init(withIdentifier identifier: String) {
        tasks = []
        cache = URLCache.shared
        normalSession = URLSession()
        backgroundSession = URLSession()
        super.init()
        var configuration = URLSessionConfiguration.default
        normalSession = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        configuration = URLSessionConfiguration.background(withIdentifier: identifier)
        configuration.sessionSendsLaunchEvents = true
        configuration.isDiscretionary = true
        backgroundSession = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }
    
    /**
     * Send a asychoronous post request.
     * - parameter urlString: The url of the destination.
     * - parameter header: The header of the post.
     * - parameter content: The content of the request.
     * - parameter type: The type of the request.
     * - parameter isUploadTask: Whether the task should be run in the background or not.
     * - returns: The identifier of the task.
     */
    public func post(toURL urlString: String, withHeader header: NetworkRequestHeader? = nil, withContent content: Data, asType type: NetworkBodyType, asUploadTask isUploadTask: Bool = false) -> String? {
        var header = header ?? NetworkRequestHeader()
        header.contentType = type.rawValue
        header.contentLength = content.count
        guard var request = createRequest(withURL: urlString, withHeader: header, withMethod: .post) else {
            // COMMENT: The error has been logged.
            return nil
        }
        request.httpBody = content
        let type = isUploadTask ? NetworkTaskType.upload : NetworkTaskType.data
        return sendRequest(request, asType: type)
    }
    
    /**
     * Post a form to a specific url.
     * - parameter urlString: The url of the destination.
     * - parameter header: The header of the post.
     * - parameter formData: The form data to be posted.
     * - parameter isUploadTask: Whether the task should be run in the background or not.
     * - returns: The identifier of the task.
     */
    public func postFormData(toURL urlString: String, withHeader header: NetworkRequestHeader? = nil, withFormData formData: FormData, asUploadTask isUploadTask: Bool = false) -> String? {
        return post(toURL: urlString, withHeader: header, withContent: formData.convertToData(), asType: .formData, asUploadTask: isUploadTask)
    }
    
    
    /**
     * Send a get request.
     * - parameter urlString: The url of the destination.
     * - parameter header: The header of the get.
     * - parameter isDownloadTask: Whether current task is a download task or not.
     * - returns: The task identifier.
     */
    public func get(fromURL urlString: String, withHeader header: NetworkRequestHeader? = nil, asDownloadTask isDownloadTask: Bool = false) -> String? {
        let header = header ?? NetworkRequestHeader()
        guard let request = createRequest(withURL: urlString, withHeader: header, withMethod: .get) else {
            // COMMENT: The error has been logged.
            return nil
        }
        let type = isDownloadTask ? NetworkTaskType.download : NetworkTaskType.data
        return sendRequest(request, asType: type)
    }
    
    /**
     * Send a delete request.
     * - parameter urlString: The address of the destination.
     * - parameter header: The header of the delete.
     * - returns: The identifier of the new task.
     */
    public func delete(atURL urlString: String, withHeader header: NetworkRequestHeader? = nil) -> String? {
        let header = header ?? NetworkRequestHeader()
        guard let request = createRequest(withURL: urlString, withHeader: header, withMethod: .delete) else {
            // COMMENT: The error has been logged.
            return nil
        }
        return sendRequest(request, asType: .data)
    }
    
    /**
     * Reset the internet, which will cancel all the current internet connections.
     */
    public func reset() {
        for task in tasks {
            task.task.cancel()
        }
        tasks.removeAll()
    }
    
    /**
     * Clear all cache data.
     */
    public func clearCache() {
        cache.removeAllCachedResponses()
    }
    
    /**
     * Clear the cache for a specific request.
     * - parameter urlString: The address of the destination.
     */
    public func clearCache(forURL urlString: String) {
        guard let parsedURLString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            Logger.standard.logError(urlError, withDetail: urlString)
            return
        }
        guard let url = URL(string: parsedURLString) else {
            Logger.standard.logError(urlError, withDetail: urlString)
            return
        }
        let request = URLRequest(url: url)
        cache.removeCachedResponse(for: request)
    }
    
    /**
     * Get the identifier of a task.
     * - parameter sessionTask: The task.
     * - returns: The task. Nil would be returned if no task is found, which shouldn't happen.
     */
    func findTask(of sessionTask: URLSessionTask) -> NetworkTask? {
        for task in tasks {
            if task.task === sessionTask {
                return task
            }
        }
        Logger.standard.logError(taskError, withDetail: sessionTask.originalRequest?.url?.absoluteString)
        return nil
    }
    
    /**
     * Remove a task from the task stack.
     * - parameter task: The task.
     */
    func remove(_ task: NetworkTask) {
        task.task.cancel()
        guard let index = tasks.index(of: task) else {
            Logger.standard.logError(taskError, withDetail: task.task.originalRequest?.url?.absoluteString)
            return
        }
        tasks.remove(at: index)
    }
    
    /**
     * Report an error back to the main thread.
     * - parameter task: The task.
     * - parameter message: The error message.
     */
    func dispatchError(for task: NetworkTask, withMessage message: String) {
        let localizedMessage = message.localizeWithinFramework(forType: NetworkHelper.self)
        DispatchQueue.main.async{
            self.networkHelperDelegate?.networkHelper(self, withIdentifier: task.identifier, didCatchError: localizedMessage)
        }
    }
    
    /**
     * Create a new request.
     * - parameter url: The url address.
     * - parameter method: The method of the request.
     * - parameter header: The HTTP header.
     * - returns: The request.
     */
    private func createRequest(withURL urlString: String, withHeader header: NetworkRequestHeader, withMethod method: NetworkRequestType) -> URLRequest? {
        guard let parsedURLString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            Logger.standard.logError(urlError, withDetail: urlString)
            return nil
        }
        guard let url = URL(string: parsedURLString) else {
            Logger.standard.logError(urlError, withDetail: urlString)
            return nil
        }
        var header = header
        var request = URLRequest(url: url)
        if !NetworkHelper.isNetworkAvailable {
            // COMMENT: Support offline mode.
            request.cachePolicy = URLRequest.CachePolicy.returnCacheDataElseLoad
        }
        // COMMENT: Read cache related information and put it into the header
        let cachedResponse = cache.cachedResponse(for: request)
        if cachedResponse != nil {
            let networkResponse = NetworkResponseHeader.parse(cachedResponse!.response)
            header.ifModifiedSince = networkResponse?.lastModified
            header.ifNoneMatch = networkResponse?.eTag
        }
        request.allHTTPHeaderFields = header.convertToDictionary()
        request.httpMethod = method.rawValue
        return request
    }
    
    /**
     * Send a request.
     * - parameter request: The request to be sent.
     * - parameter type: The type of the request.
     * - returns: The identifier of the task.
     */
    private func sendRequest(_ request: URLRequest, asType type: NetworkTaskType) -> String? {
        var task: NetworkTask
        switch type {
        case .download:
            task = NetworkTask(with: backgroundSession.downloadTask(with: request))
        case .data:
            task = NetworkTask(with: normalSession.dataTask(with: request))
        case .upload:
            let data = request.httpBody ?? Data()
            task = NetworkTask(with: normalSession.uploadTask(with: request, from: data))
        default:
            Logger.standard.logError(taskTypeError, withDetail: type)
            return nil
        }
        tasks.append(task)
        task.task.resume()
        return task.identifier
    }
    
}


import Foundation
import SystemConfiguration



