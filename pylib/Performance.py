from abc import ABC, abstractmethod
from pythonosc import udp_client

class Performance:

    def __init__(self, addr = "127.0.0.1", port = 57120):
        self.client = udp_client.SimpleUDPClient(addr, port)

    #def _setup_OSC(self, addr, port):

    def send_msg(self, msg_path, msg_body):
        self.client.send_message(msg_path, msg_body)
