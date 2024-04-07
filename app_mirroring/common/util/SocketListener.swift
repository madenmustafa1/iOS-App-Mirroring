//
//  SocketListener.swift
//  iOS-App-Mirroring
//
//  Created by Mustafa Maden on 7.04.2024.
//

import Foundation

protocol SocketListener {
    func uiState(uiState: MirroringSocketUIState)
}
