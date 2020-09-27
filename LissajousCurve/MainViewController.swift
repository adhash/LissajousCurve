//
//  ViewController.swift
//  LissajousCurve
//
//  Created by wojtek on 22/09/2020.
//  Copyright © 2020 wojtek. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var stage: UIView!
    @IBOutlet weak var amplitude1: UITextField!
    @IBOutlet weak var amplitude2: UITextField!
    @IBOutlet weak var frequency1: UITextField!
    @IBOutlet weak var frequency2: UITextField!
    @IBOutlet weak var startFaze: UITextField!
    
    private var pointer: Pointer?
    private var workItem: DispatchWorkItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter
            .default
            .addObserver(self,
                         selector: #selector(self.keyboardWillShow(notification:)),
                         name: UIResponder.keyboardWillShowNotification,
                         object: nil)

        NotificationCenter
        .default
        .addObserver(self,
                     selector: #selector(self.keyboardWillHide(notification:)),
                     name: UIResponder.keyboardWillHideNotification,
                     object: nil)
        //todo: add pointer that tracks path
        //self.pointer = Pointer(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        //self.pointer!.frame.origin.x = self.stage.center.x
        //self.pointer!.frame.origin.y = self.stage.center.y
        //self.stage.addSubview(self.pointer!)
        
        self.setTestCase(amp1: "15", amp2: "15", frq1: "3", frq2: "3.33", startFaze: "1.7")
    }
    
    @IBAction func update_onClick(_ sender: Any) {
        
        if self.stage.layer.sublayers?[0] != nil {
            self.stage.layer.sublayers?.remove(at: 0)
        }

        let shapeLayer = CAShapeLayer()
        let path = self.preparePath(startPoint: self.stage.center)
        let animation = CABasicAnimation(keyPath: "strokeEnd")

        shapeLayer.path = path.cgPath
        shapeLayer.strokeEnd = 0
        shapeLayer.lineWidth = 1
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor

        self.stage.layer.addSublayer(shapeLayer)

        animation.toValue = 1
        animation.duration = 10 // seconds
        animation.autoreverses = false
        animation.repeatCount = .infinity

        shapeLayer.add(animation, forKey: "line")
    }
    
    @objc
    func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }

      self.view.frame.origin.y = 0 - keyboardSize.height
    }

    @objc
    func keyboardWillHide(notification: NSNotification) {
      self.view.frame.origin.y = 0
    }
    
    private func getAmplitude1() -> CGFloat {
        let amplitude = CGFloat(Float(self.amplitude1.text!) ?? 0)
        
        return amplitude
    }
    
    private func getAmplitude2() -> CGFloat {
        let amplitude = CGFloat(Float(self.amplitude2.text!) ?? 0)
        
        return amplitude
    }
    
    private func getFrequency1() -> CGFloat {
        let frequency = CGFloat(Float(self.frequency1.text!) ?? 0)
        
        return frequency
    }
    
    private func getFrequency2() -> CGFloat {
        let frequency = CGFloat(Float(self.frequency2.text!) ?? 0)
        
        return frequency
    }
    
    private func getStartFaze() -> CGFloat {
        let startFaze = CGFloat(Float(self.startFaze.text!) ?? 0)
        
        return startFaze
    }
    
    private func preparePath(startPoint: CGPoint) -> UIBezierPath {
        var time: CGFloat = 0
        var endPoint = startPoint
        let bezierPath = UIBezierPath()
        
        bezierPath.move(to: endPoint)
        
        for _ in 0...1000 {
            time += 0.027
            
            let x = self.getAmplitude1() * sin((self.getFrequency1() * time) + self.getStartFaze()) + endPoint.x
            let y = self.getAmplitude2() * sin(self.getFrequency2() * time) + endPoint.y
            
            endPoint.x = x
            endPoint.y = y
            
            bezierPath.addLine(to: endPoint)
        }
        
        return bezierPath
    }
    
    private func setTestCase(amp1: String, amp2: String, frq1: String, frq2: String, startFaze: String) {
        self.amplitude1.text = amp1
        self.amplitude2.text = amp2
        self.frequency1.text = frq1
        self.frequency2.text = frq2
        self.startFaze.text = startFaze
    }
}

