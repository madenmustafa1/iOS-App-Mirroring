//
//  SocketViewModel.swift
//  iOS-App-Mirroring
//
//  Created by Mustafa Maden on 7.04.2024.
//

import Foundation
import UIKit
import Combine
import UIKit
import Combine

class SocketViewModel: NSObject,  ObservableObject, SocketListener, LifecycleObserver {
    
    private var model: SocketInitModel
    private var socket: MirroringSocket?
    
    private var uiStateValue: MirroringSocketUIState = .Empty
    @Published var uiState: MirroringSocketUIState = .Empty
    @Published var shareScreenLiveData: Bool = false
    
    private var shareScreenSubject = PassthroughSubject<UIImage?, Never>()
    private var shareScreenPublisher: AnyPublisher<UIImage?, Never> {
        shareScreenSubject.eraseToAnyPublisher()
    }
    
    var cancellables = Set<AnyCancellable>()
 
    init(model: SocketInitModel) {
        self.model = model
        super.init()
        self.socket = MirroringSocket(socketListener: self)
        setupBindings()
    }
    
    private func setupBindings() {
        shareScreenPublisher
            .debounce(for: .milliseconds(200), scheduler: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                guard let self = self else { return }
                guard let image = image else { return }
                
                Task {
                    if(self.socket!.isConnected() == true) {
                        self.socket!.sendScreen(imageData: image)
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    func shareScreen(image: UIImage?)  {
        if(uiStateValue != MirroringSocketUIState.Start) {
            return
        }
        
        if(((socket?.isConnected()) != nil) && image != nil) {
            shareScreenSubject.send(image)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.shareScreenLiveData = true
        }
    }
    
    private func connectsocket() async {
        let url = model.url + "?roomId=" + model.roomId + "&isReceiver=" + String(model.isReceived)
        await self.socket?.connect(url: URL(string: url)!)
    }
    
    func closeSocket()  {
        socket!.close()
    }
    
    
    func uiState(uiState: MirroringSocketUIState) {
        DispatchQueue.main.async {
            self.uiStateValue = uiState
            self.uiState = uiState
        }
    }

    
    func viewDidAppear() {
        Task {
            await connectsocket()
        }
    }
    
    func viewWillDisappear() {
        Task { closeSocket() }
    }
}
