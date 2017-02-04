//
//  GraphViewController.swift
//  Calculator
//
//  Created by Akshay Ramaswamy on 1/30/17.
//  Copyright © 2017 Akshay Ramaswamy. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {

    /* This variable is set to function that will give y-value for respective x-value.*/
    var convertToY:((Dictionary<String,Double>? ) -> (result: Double?, description: String))?
    
    @IBOutlet weak var graphView: GraphView!{

    didSet {
        //pinch handler
        let pinchHandler = #selector(changeScale(byReactingTo:))
        let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: pinchHandler)
        graphView.addGestureRecognizer(pinchRecognizer)
        
        //tap recognizer
        let tapHandler = #selector(twoTaps(byReactingTo:))
        let tapRecognizer = UITapGestureRecognizer(target: self, action: tapHandler)
        tapRecognizer.numberOfTapsRequired = 2
        graphView.addGestureRecognizer(tapRecognizer)
        
        //pan recognizer
        let panHandler = #selector(changePan(byReactingTo:))
        let panRecognizer = UIPanGestureRecognizer(target:self, action: panHandler)
        graphView.addGestureRecognizer(panRecognizer)
        }
    }

    /* Override viewDidLoad so we can pass it the convertToY function before graphing the curve in the view */
    override func viewDidLoad() {
            graphView?.convertToY = convertToY
    }
    
    
    func changeScale(byReactingTo pinchRecognizer: UIPinchGestureRecognizer)
    {
        switch pinchRecognizer.state {
        case .changed,.ended:
            graphView.scale *= pinchRecognizer.scale
            pinchRecognizer.scale = 1
        default:
            break
        }
    }
    
    func twoTaps(byReactingTo tapRecognizer: UITapGestureRecognizer)
    {
        if tapRecognizer.state == .ended {
            let newOrigin = tapRecognizer.location(in: graphView)
            graphView.origin = graphView.convert(newOrigin, to: graphView)
        }
        
    }
    
    func changePan(byReactingTo panRecognizer: UIPanGestureRecognizer)
    {
        switch panRecognizer.state {
        case .changed: fallthrough
        case .ended:
            graphView.origin.x += panRecognizer.translation(in: graphView).x
            graphView.origin.y += panRecognizer.translation(in: graphView).y
            panRecognizer.setTranslation(CGPoint.zero, in: graphView)
        default:break
        }
    }


}
