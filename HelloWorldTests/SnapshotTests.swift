// (c) Confusion Studios LLC and affiliates. Confidential and proprietary.

import XCTest
@testable import HelloWorld

class SnapshotTests: XCTestCase {

    func testViewControllerSnapshot() {
        let vc = ViewController()
        vc.view.frame = CGRect(x: 0, y: 0, width: 393, height: 852) // iPhone 15 Pro size

        // Trigger viewDidLoad and layout
        vc.loadViewIfNeeded()
        vc.view.layoutIfNeeded()

        // Save snapshot to project root
        let projectRoot = URL(fileURLWithPath: #file)
            .deletingLastPathComponent()
            .deletingLastPathComponent()

        let snapshotDir = projectRoot.appendingPathComponent("Snapshots")
        try? FileManager.default.createDirectory(at: snapshotDir, withIntermediateDirectories: true)

        let renderer = UIGraphicsImageRenderer(bounds: vc.view.bounds)
        let image = renderer.image { context in
            vc.view.layer.render(in: context.cgContext)
        }

        let snapshotPath = snapshotDir.appendingPathComponent("testViewControllerSnapshot.png")
        try? image.pngData()?.write(to: snapshotPath)

        print("✅ Snapshot saved to: \(snapshotPath.path)")
    }
}
