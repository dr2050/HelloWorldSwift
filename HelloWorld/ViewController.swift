import UIKit

class ViewController: UINavigationController {
    private let oscTester = OSCTester()
    private var sendTimer: Timer?
    private var currentValue: Float = 0.0
    private var step: Float = 0.1
    private let sentValueLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        sentValueLabel.translatesAutoresizingMaskIntoConstraints = false
        sentValueLabel.text = "Sent Value: 0.0"
        sentValueLabel.font = UIFont.monospacedSystemFont(ofSize: 16, weight: .medium)
        sentValueLabel.textColor = .label
        view.addSubview(sentValueLabel)
        NSLayoutConstraint.activate([
            sentValueLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sentValueLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        sendTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self else { return }
            self.currentValue += self.step
            if self.currentValue >= 1.0 {
                self.currentValue = 1.0
                self.step = -abs(self.step)
            } else if self.currentValue <= 0.0 {
                self.currentValue = 0.0
                self.step = abs(self.step)
            }
            self.oscTester.sendTest(value: self.currentValue)
            self.sentValueLabel.text = String(format: "Sent Value: %.1f", self.currentValue)
        }
    }
}


import OSCKit

class OSCTester {
    let ports: [UInt16] = [54344]
    
    func sendTest(value: Float) {
        let client = OSCUDPClient()
        let message = OSCMessage(
            "/blah/SetValue",
            values: [Float32(value)]
        )
        do {
            for port in ports {
                try client.send(message, to: "127.0.0.1", port: port)
            }
            print("OSC sent:", value)
        } catch {
            print("OSC send failed:", error)
        }
    }
}
