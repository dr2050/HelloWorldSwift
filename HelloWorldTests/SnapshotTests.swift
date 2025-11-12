// (c) Confusion Studios LLC and affiliates. Confidential and proprietary.

import XCTest
import SnapshotTesting
@testable import HelloWorld

class SnapshotTests: XCTestCase {

    func testViewControllerSnapshot() {
        let vc = ViewController()
        vc.view.frame = CGRect(x: 0, y: 0, width: 393, height: 852) // iPhone 15 Pro size

        // Trigger viewDidLoad and layout
        vc.loadViewIfNeeded()
        vc.view.layoutIfNeeded()

        assertSnapshot(of: vc, as: .image)
    }
}
