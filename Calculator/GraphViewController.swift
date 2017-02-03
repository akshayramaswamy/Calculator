//
//  GraphViewController.swift
//  Calculator
//
//  Created by Akshay Ramaswamy on 1/30/17.
//  Copyright © 2017 Akshay Ramaswamy. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {

    var convertToY:((Dictionary<String,Double>? ) -> (result: Double?, description: String))?
    
    
    @IBOutlet weak var graphView: GraphView!{

    didSet {
        //pinch handler
        let pinchHandler = #selector(GraphView.changeScale(byReactingTo:))
        let pinchRecognizer = UIPinchGestureRecognizer(target: graphView, action: pinchHandler)
        graphView.addGestureRecognizer(pinchRecognizer)
        
        //tap recognizer
        let tapHandler = #selector(GraphView.twoTaps(byReactingTo:))
        let tapRecognizer = UITapGestureRecognizer(target: graphView, action: tapHandler)
        tapRecognizer.numberOfTapsRequired = 2
        graphView.addGestureRecognizer(tapRecognizer)
        
        // pan recognizer
        let panHandler = #selector(GraphView.changePan(byReactingTo:))
        let panRecognizer = UIPanGestureRecognizer(target:graphView, action: panHandler)
        graphView.addGestureRecognizer(panRecognizer)
        }
    }

    override func viewDidLoad() {
            graphView?.convertToY = convertToY
        
    }


}
