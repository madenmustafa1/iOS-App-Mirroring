//
//  MirroringSocketClient.swift
//  iOS-App-Mirroring
//
//  Created by Mustafa Maden on 7.04.2024.
//

import Starscream
import Foundation

class MirroringSocketClient: WebSocketDelegate {
    func didReceive(event: Starscream.WebSocketEvent, client: any Starscream.WebSocketClient) {
        switch(event) {
        case .connected(_):
            self.isSocketConnected = true
            self.socketListener.uiState(uiState: .Start)
        case .disconnected(_, _):
            self.isSocketConnected = false
        case .text(let text):
            websocketDidReceiveMessage(text: text)
        case .error(_):
            self.isSocketConnected = false
        case .cancelled:
            self.isSocketConnected = false
        case .peerClosed:
            self.isSocketConnected = false
            
        case .ping(let data):
            // data adında bir değişken ile alınan veriyi kullanabilirsiniz
            if let unwrappedData = data {
                // data değeri nil değilse
                // unwrappedData adında bir değişkende veri mevcuttur
                print("Received data: \(unwrappedData)")
            } else {
                // data değeri nil ise
                print("No data received")
            }
        default:
            return
        }
    }
    
    private var socket: WebSocket?
     var isSocketConnected = false
    private let socketListener: SocketListener

    init(serverUrl: URL, socketListener: SocketListener) {
        self.socketListener = socketListener
        let request = URLRequest(url: serverUrl)
        self.socket = WebSocket(request: request)
        self.socket?.delegate = self
    }

    func connect() throws {
        self.socket?.connect()
    }

    func disconnect() throws {
        self.socket?.disconnect()
    }

    func sendByteArray(_ byteArray: Data) throws {
        self.socket?.write(data: byteArray)
    }

    func websocketDidReceiveMessage(text: String) {
        switch text.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() {
        case "close":
            self.isSocketConnected = false
            self.socketListener.uiState(uiState: .Close)
        case "stop":
            self.socketListener.uiState(uiState: .Stop)
        case "start":
            self.socketListener.uiState(uiState: .Start)
        default:
            break
        }
    }

}
