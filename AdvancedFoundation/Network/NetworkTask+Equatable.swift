/**
 * NetworkTask+Equatable provides comparison to two network objects.
 * - author: Adamas
 * - version: 1.0.0
 * - date: 07/05/2017
 */
extension NetworkTask: Equatable {
    
    /**
     * Equatable
     */
    static func ==(lhs: NetworkTask, rhs: NetworkTask) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
}

import Foundation