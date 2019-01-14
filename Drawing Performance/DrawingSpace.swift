//
//  DrawingSpace.swift
//  Drawing Performance
//
//  Created by Besher on 2019-01-13.
//  Copyright © 2019 Besher Al Maleh. All rights reserved.
//

import UIKit

protocol DrawingSpace: class {
    var spiralPoints: [CGPoint] { get set }
    var displayLink: CADisplayLink? { get set }
    func hide()
    func unHide()
    func clear()
    func startAutoDrawing()
    func drawSpiral()
}

extension DrawingSpace where Self: UIView {
    
    var lineWidth: CGFloat { return 5 }
    var lineColor: UIColor { return .white }
    
    func hide() {
        self.isHidden = true
        clear()
        stopAutoDrawing()
    }
    
    func unHide() {
        self.isHidden = false
    }
    
    func startAutoDrawing() {
        clear()
        stopAutoDrawing()
        drawSpiral()
    }
    
    func stopAutoDrawing() {
        displayLink?.invalidate()
        displayLink = nil
    }
    
    func createSpiral() {
        
        let renderer = UIGraphicsImageRenderer(bounds: self.bounds)
        renderer.image { ctx in
            ctx.cgContext.translateBy(x: self.bounds.width / 2, y: self.bounds.height / 2)
            
            var first = true
            var length: CGFloat = Display.pad ? 200 : 100
            
            for _ in 0 ... 15000 {
                ctx.cgContext.rotate(by: (CGFloat.pi / 2) / 90)
                
                if first {
                    ctx.cgContext.move(to: CGPoint(x: length, y: length))
                    first = false
                } else {
                    ctx.cgContext.addLine(to: CGPoint(x: length, y: length))
                }
                
                length *= 0.9999
            }
            
            ctx.cgContext.path?.applyWithBlock({ (element) in
                let point = element.pointee.points.pointee
                let centeredPoint = CGPoint(x: point.x + bounds.width / 2, y: point.y + bounds.height / 2)
                spiralPoints.append(centeredPoint)
            })
            
            // below code is to visualize spiral
            //            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            //            ctx.cgContext.strokePath()
        }
        //        let image = img.cgImage
        //        let sublayer = CALayer()
        //        sublayer.frame = self.bounds
        //        sublayer.contents = image
        //        layer.addSublayer(sublayer)
        
    }
}