import UIKit

class ViewController: UIViewController {
    var queue: DispatchQueue?

    override func viewDidLoad() {
        queue.asyncIfNotNil {
            print("1 yes I'm in here \(DispatchQueue.current.isMain)")
        }
        queue = DispatchQueue.global()
        queue.asyncIfNotNil {
            print("2 yes I'm in here \(DispatchQueue.current.isMain)")
        }
    }
}


/// Extension on DispatchQueue? for Testing
/// If you don't have a DispatchQueue, run it sync
extension Optional where Wrapped : DispatchQueue {
    func asyncIfNotNil(execute block: @escaping ()->()) {
        if let self = self {
            self.async(execute: block)
        } else {
            DispatchQueue.current.async(execute: block)
        }
    }
}

extension DispatchQueue {
    class var current: DispatchQueue {
        return NSObject.currentDispatchQueue()
    }
    
    var isMain: Bool {
        return DispatchQueue.main == self
    }
}

func doIt() {
    guard Thread.isMainThread else {
        return
    }
    
}
