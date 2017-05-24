/**
 * ResourceHelper improves the ability to access resources.
 * - author: Adamas
 * - version: 1.0.0
 * - date: 29/04/2017
 */
public class ResourceHelper {
    
    /**
     * The url of the resource. Nil if the resource doesn't exist.
     */
    var url: URL
    
    /**
     * Initialize the helper.
     * - parameter name: The name of the resource.
     * - parameter bundle: The bundle that the resource belongs to.
     */
    public init?(name: String, bundle: Bundle = Bundle.main) {
        let fileInfoAccessor = FileInfoAccessor(path: name)
        guard let path = bundle.path(forResource: fileInfoAccessor.filename, ofType: fileInfoAccessor.fileExtension) else {
            return nil
        }
        url =  URL(fileURLWithPath: path)
    }
    
}

import Foundation

