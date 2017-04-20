/**
 * StringHelper is used to provide additional functions for a string object.
 * - author: Adamas
 * - version: 1.0.0
 * - date: 20/04/2017
 */
public extension String {
    
    /**
     * Remove a specific suffix from the string.
     * - parameter suffix: The suffix to be removed.
     * - returns: The suffix removed string. Nil if the suffix doesn't exist in the original string.
     */
    public func removeSuffix(_ suffix: String) -> String? {
        if !hasSuffix(suffix) {
            return nil
        }
        let suffixBeginIndex = index(endIndex, offsetBy: -suffix.characters.count)
        return substring(to: suffixBeginIndex)
    }
    
    /**
     * Remove a specific prefix from the string.
     * - parameter prefix: The prefix to be removed.
     * - returns: The prefix removed string. Nil if the prefix doesn't exist in the original string.
     */
    public func removePrefix(_ prefix: String) -> String? {
        if !hasPrefix(prefix) {
            return nil
        }
        let prefixEndIndex = index(startIndex, offsetBy: prefix.characters.count)
        return substring(from: prefixEndIndex)
    }
    
}

import Foundation
