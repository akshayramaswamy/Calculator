//
//  GraphView.swift
//  Calculator
//
//  Created by Akshay Ramaswamy on 1/30/17.
//  Copyright © 2017 Akshay Ramaswamy. All rights reserved.
//

import UIKit

@IBDesignable class GraphView: UIView {
    
    private var drawer = AxesDrawer(color: UIColor.blue)
    var convertToY: ((Dictionary<String,Double>? ) -> (result: Double?, description: String))?{
        didSet{
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var lineColor: UIColor = UIColor.black { didSet { setNeedsDisplay() } }
    @IBInspectable
    var lineWidth: CGFloat = 1.0 { didSet { setNeedsDisplay() } }
    @IBInspectable
    var scale: CGFloat = 40.0 { didSet { setNeedsDisplay() } }
    var origin: CGPoint! { didSet { setNeedsDisplay() } }

    
    override func draw(_ rect: CGRect) {
        if (origin==nil){
            origin = CGPoint(x: bounds.midX, y: bounds.midY)
        }
        
        drawer.contentScaleFactor = contentScaleFactor
        drawLine(bounds: bounds, origin: origin, scale: scale)
        drawer.drawAxes(in: bounds, origin: origin, pointsPerUnit: scale)
        
        
    }
    
    func drawLine(bounds: CGRect, origin: CGPoint, scale: CGFloat){
        lineColor.set()
        let path = UIBezierPath()
        var emptyPath:Bool = true
        var xPoint, yPoint:CGFloat
        for i in 0...Int(bounds.size.width * contentScaleFactor ){
            xPoint = CGFloat(i)/contentScaleFactor
            var variableDictionary = Dictionary<String, Double>()
            variableDictionary["M"] = Double((xPoint - origin.x) / scale)
            if let y = convertToY?(variableDictionary).result {
            yPoint = origin.y - CGFloat(y) * scale
            if (emptyPath){
                path.move(to: CGPoint(x: xPoint, y: yPoint))
                emptyPath = false
                continue
            }
            path.addLine(to: CGPoint(x: xPoint, y: yPoint))
            }
        }
        path.lineWidth = lineWidth
        path.stroke()
    }
    
    func changeScale(byReactingTo pinchRecognizer: UIPinchGestureRecognizer)
    {
        switch pinchRecognizer.state {
        case .changed,.ended:
            scale *= pinchRecognizer.scale
            pinchRecognizer.scale = 1
        default:
            break
        }
    }
    
    func twoTaps(byReactingTo tapRecognizer: UITapGestureRecognizer)
    {
        if tapRecognizer.state == .ended {
            let newOrigin = tapRecognizer.location(in: self)
            origin = self.convert(newOrigin, to: self)
        }

    }
    
    func changePan(byReactingTo panRecognizer: UIPanGestureRecognizer)
    {
        switch panRecognizer.state {
        case .changed: fallthrough
        case .ended:
            origin.x = origin.x + panRecognizer.translation(in: self).x
            origin.y = origin.y + panRecognizer.translation(in: self).y
            
            panRecognizer.setTranslation(CGPoint.zero, in: self)
            //origin = panRecognizer.location(in: self)
            
            //scale *= pinchRecognizer.scale
            //pinchRecognizer.scale = 1
        default:break
        }
    }
}
