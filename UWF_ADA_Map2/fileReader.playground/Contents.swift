import UIKit
import XCPlayground

/**Not the best approach but demonstrates the process of parsing sample file */
let path = NSBundle.mainBundle().bundlePath as NSString // it needs be NSString, Swift String doesn't have stringByAppendingPathComponent method
let jsonPath = path.stringByAppendingPathComponent("buildings.kml")


do{
    if let jsonData = NSData(contentsOfFile: jsonPath){
        let data = try NSString(contentsOfFile: jsonPath, encoding: NSUTF8StringEncoding)
        print(data)
    }
}catch let error as NSError {
    print(error)
}