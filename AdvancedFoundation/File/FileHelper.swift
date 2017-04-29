/**
 * FileHelper is used to perform file related action.
 * - version: 1.0.0.
 * - date: 26/10/2016
 * - author: Adamas
 */
public class FileHelper: PathHelper {
    
    /**
     * Create a file in the path.
     * - parameter data: The data used to create the file.
     * - returns: whether the file has been created or not. Nil if there is an error.
     */
    public func create(withData data: Data) -> Bool? {
        if super.isExisted {
            return false
        }
        if createParentDirectory() != true {
            return nil
        }
        return createFile(atPath: path, contents: data)
    }
    
    /**
     * Get the content of a file or directory.
     * - returns: The data of a file. Nil if the file doesn't exists or there is an error.
     */
    public func getContent() -> Data? {
        if !isExisted {
            return nil
        }
        return contents(atPath: path)
    }
    
    /**
     * PathHelper.
     */
    public override var isExisted: Bool {
        if !super.isExisted {
            return false
        }
        var isDictory: ObjCBool = false
        fileExists(atPath: path, isDirectory: &isDictory)
        return !isDictory.boolValue
    }
    
}

import Foundation
