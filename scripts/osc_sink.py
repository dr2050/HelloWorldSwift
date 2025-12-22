#!/usr/bin/env python3
import argparse
import random
import signal
import subprocess
import sys
import threading
import time


def run_sender(stop_event, host, port, address, interval_s):
    while not stop_event.is_set():
        value = random.random()
        try:
            subprocess.run(
                [
                    "oscsend",
                    host,
                    str(port),
                    address,
                    "f",
                    f"{value:.6f}",
                ],
                check=True,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                text=True,
            )
            print(f"SENT {address} {value:.6f}")
        except subprocess.CalledProcessError as exc:
            stderr = exc.stderr.strip()
            print(f"SEND FAILED: {stderr or exc}", file=sys.stderr)
        stop_event.wait(interval_s)


def main():
    parser = argparse.ArgumentParser(description="OSC sink + periodic random sender.")
    parser.add_argument("--listen-port", type=int, default=7700)
    parser.add_argument("--send-host", default="127.0.0.1")
    parser.add_argument("--send-port", type=int, default=7701)
    parser.add_argument("--send-address", default="/blah/SetValue")
    parser.add_argument("--interval", type=float, default=4.0)
    args = parser.parse_args()

    stop_event = threading.Event()

    def handle_sigint(_signum, _frame):
        stop_event.set()

    signal.signal(signal.SIGINT, handle_sigint)
    signal.signal(signal.SIGTERM, handle_sigint)

    sender = threading.Thread(
        target=run_sender,
        args=(
            stop_event,
            args.send_host,
            args.send_port,
            args.send_address,
            args.interval,
        ),
        daemon=True,
    )
    sender.start()

    dump_cmd = ["stdbuf", "-oL", "oscdump", str(args.listen_port)]
    print(f"LISTENING on UDP {args.listen_port} via oscdump")
    print(f"SENDING to {args.send_host}:{args.send_port} every {args.interval}s")
    print("Press Ctrl+C to stop.")

    with subprocess.Popen(
        dump_cmd,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
    ) as proc:
        try:
            for line in proc.stdout:
                if stop_event.is_set():
                    break
                print(f"RECV {line.rstrip()}")
        finally:
            stop_event.set()
            proc.terminate()
            try:
                proc.wait(timeout=1)
            except subprocess.TimeoutExpired:
                proc.kill()


if __name__ == "__main__":
    main()
