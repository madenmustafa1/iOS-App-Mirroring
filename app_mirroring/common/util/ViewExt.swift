//
//  ViewExt.swift
//  app_mirroring
//
//  Created by Mustafa Maden on 7.04.2024.
//

import Foundation

import UIKit

extension UIApplication {
    
    func toUIImage() -> UIImage? {
        guard let windowScene = self.connectedScenes.first as? UIWindowScene else {
            return nil
        }
        
        guard let window = windowScene.windows.first else {
            return nil
        }
        
        let renderer = UIGraphicsImageRenderer(size: window.bounds.size)
        
        let screenshot = renderer.image { context in
            window.drawHierarchy(in: window.bounds, afterScreenUpdates: true)
        }
        
        return screenshot
    }
    
}
