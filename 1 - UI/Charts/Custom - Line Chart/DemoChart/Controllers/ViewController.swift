//
//  ViewController.swift
//  DemoChart
//
//  Created by Hoang Lam on 27/05/2022.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var lineChart: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let f: (CGFloat) -> CGPoint = {
            let noiseY = (CGFloat(arc4random_uniform(2)) * 2 - 1) * CGFloat(arc4random_uniform(4))
            let noiseX = (CGFloat(arc4random_uniform(2)) * 2 - 1) * CGFloat(arc4random_uniform(4))
            let b: CGFloat = 5
            let y = 2 * $0 + b + noiseY
            return CGPoint(x: $0 + noiseX, y: y)
        }
        
        let xs = [Int](1..<20)
        
        let points = xs.map({f(CGFloat($0 * 10))})
        
        lineChart.deltaX = 20
        lineChart.deltaY = 30
        lineChart.circleSizeMultiplier = 6
        lineChart.lineColor = .yellow
        lineChart.lineWidth = 2
        
        lineChart.plot(points)
    }
}
