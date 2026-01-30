//
//  Dropzone.swift
//  wwdc26
//
//  Created by Sofia Villas Bôas on 30/01/26.
//

import SwiftUI

struct DropZone: Identifiable {
    let id: UUID = UUID()
    let name: String
    let position: CGPoint // center position on screen
    let size: CGSize // width and height of the drop zone
    let validQuestions: [[String]]
    
    var frame: CGRect {
        CGRect(
            x: position.x - size.width / 2,
            y: position.y - size.height / 2,
            width: size.width,
            height: size.height
        )
    }
    
    var baseline: CGFloat {
        position.y
    }
    
    func contains(_ point: CGPoint) -> Bool {
        frame.contains(point)
    }
}
