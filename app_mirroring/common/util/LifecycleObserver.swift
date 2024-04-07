//
//  LifecycleObserver.swift
//  app_mirroring
//
//  Created by Mustafa Maden on 7.04.2024.
//

import Foundation

protocol LifecycleObserver: AnyObject {
    func viewDidAppear()
    func viewWillDisappear()
}
