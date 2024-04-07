//
//  MirroringSocket.swift
//  iOS-App-Mirroring
//
//  Created by Mustafa Maden on 7.04.2024.
//

import Foundation


import Foundation
import UIKit
class MirroringSocket {
    private var socketClient: MirroringSocketClient?

    let socketListener: SocketListener

    init(socketListener: SocketListener) {
        self.socketListener = socketListener
    }

    func connect(url: URL) async {
        do {
            if socketClient == nil {
                socketClient = MirroringSocketClient(serverUrl: url, socketListener: socketListener)
            }
            guard let socketClient = socketClient else { return }

            if socketClient.isSocketConnected {
                return
            }

            try socketClient.connect()
        } catch {
        }
    }

    func isConnected() -> Bool {
        return socketClient?.isSocketConnected ?? false
    }

    func sendScreen(imageData: UIImage)  {
        do {
            guard let imageData = imageData.jpegData(compressionQuality: 0.1) else { return  }
            try socketClient?.sendByteArray(imageData)
        } catch {
            print("Error: \(error)")
        }
    }

    func close() {
        do {
            try  socketClient?.disconnect()
        } catch {
            print("Error: \(error)")
        }
    }
}
