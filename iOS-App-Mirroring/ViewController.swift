//
//  ViewController.swift
//  iOS-App-Mirroring
//
//  Created by Mustafa Maden on 7.04.2024.
//

import UIKit


class ViewController: UIViewController {
    
    private let socketViewModel = SocketViewModel(
        model: SocketInitModel(url: "http://0.0.0.0:8080/screenMirroring", roomId: "testRoom")
    )
        
    override func viewDidLoad() {
        super.viewDidLoad()
        observeData()
    }
    
    private func observeData() {
        socketViewModel.$shareScreenLiveData
            .sink { isShareScreen in
                print("isShareScreen: \(isShareScreen)")
                if isShareScreen {
                    self.socketViewModel.shareScreen(image: UIApplication.shared.toUIImage())
                }
            }.store(in: &socketViewModel.cancellables)
        
        socketViewModel.$uiState
            .sink { uiState in
                switch uiState {
                case .Start:
                    self.socketViewModel.shareScreen(image: UIApplication.shared.toUIImage())
                case .Close, .Error:
                    self.socketViewModel.closeSocket()
                default:
                    break
                }
            }.store(in: &socketViewModel.cancellables)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        socketViewModel.viewDidAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
          super.viewWillDisappear(animated)
        socketViewModel.viewWillDisappear()
    }

}

