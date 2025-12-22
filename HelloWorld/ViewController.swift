import UIKit

class ViewController: UINavigationController {
    private let oscTester = OSCTester()
    private let sentValueLabel = UILabel()
    private let receivedValueLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        sentValueLabel.translatesAutoresizingMaskIntoConstraints = false
        sentValueLabel.text = "Sent Value: 0.0"
        sentValueLabel.font = UIFont.monospacedSystemFont(ofSize: 16, weight: .medium)
        sentValueLabel.textColor = .label

        receivedValueLabel.translatesAutoresizingMaskIntoConstraints = false
        receivedValueLabel.text = "Received: —"
        receivedValueLabel.font = UIFont.monospacedSystemFont(ofSize: 16, weight: .medium)
        receivedValueLabel.textColor = .label

        let stack = UIStackView(arrangedSubviews: [sentValueLabel, receivedValueLabel])
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        oscTester.delegate = self
        oscTester.startReceiving()
        oscTester.startRampSending()
    }
}


import OSCKit

protocol OSCTesterDelegate: AnyObject {
    func oscTester(_ tester: OSCTester, didSend value: Float)
    func oscTester(_ tester: OSCTester, didReceive message: OSCMessage, host: String, port: UInt16)
}

class OSCTester {
    weak var delegate: OSCTesterDelegate?

    private let client = OSCUDPClient()
    private var servers: [OSCUDPServer] = []
    private var sendTimer: Timer?
    private var currentValue: Float = 0.0
    private var step: Float = 0.1
    private let sendPorts: [UInt16] = [7700, 5344]
    private let receivePorts: [UInt16] = [7500, 7701]

    func startReceiving() {
        servers = receivePorts.map { listenPort in
            OSCUDPServer(port: listenPort) { [weak self] message, _, host, port in
                guard let self else { return }
                print("OSC received:", message, "from", host, port)
                self.delegate?.oscTester(self, didReceive: message, host: host, port: port)
            }
        }

        for server in servers {
            do {
                try server.start()
                print("OSC server listening on", server.port ?? 0)
            } catch {
                print("OSC server start failed:", error)
            }
        }
    }

    func startRampSending() {
        sendTimer?.invalidate()
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
            self.sendTest(value: self.currentValue)
        }
    }

    func sendTest(value: Float) {
        let message = OSCMessage(
            "/blah/SetValue",
            values: [Float32(value)]
        )
        do {
            for port in sendPorts {
                try client.send(message, to: "127.0.0.1", port: port)
            }
            print("OSC sent:", value)
            delegate?.oscTester(self, didSend: value)
        } catch {
            print("OSC send failed:", error)
        }
    }
}

extension ViewController: OSCTesterDelegate {
    func oscTester(_ tester: OSCTester, didSend value: Float) {
        DispatchQueue.main.async { [weak self] in
            self?.sentValueLabel.text = String(format: "Sent Value: %.1f", value)
        }
    }

    func oscTester(_ tester: OSCTester, didReceive message: OSCMessage, host: String, port: UInt16) {
        DispatchQueue.main.async { [weak self] in
            self?.receivedValueLabel.text = "Received: \(message)"
        }
    }
}
