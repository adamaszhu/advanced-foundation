class URLSessionDataTaskMocker: URLSessionDataTask {
    
    var delegate: (URLSessionDataDelegate & URLSessionTaskDelegate)?
    
}

import Foundation
