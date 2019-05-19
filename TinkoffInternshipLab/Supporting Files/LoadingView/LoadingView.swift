//
//  LoadingView.swift
//  TinkoffInternshipLab
//
//  Created by Alex Milogradsky on 16/05/2019.
//  Copyright © 2019 Alex Milogradsky. All rights reserved.
//

import Foundation
import UIKit

private struct Position {
    let seconds: CFTimeInterval
    let start: CGFloat
}

private extension CGFloat {
    static let loadingLineMargin: CGFloat = 3
    static let smallRadiusMargin: CGFloat = 2
    static let initialLayerLineWidth: CGFloat = 4
    static let innerAndOuterLayerLineWidth: CGFloat = 1
    static let baseStrokeEnd: CGFloat = 0.5
}

private extension UIColor {
    static let initialLineColor: UIColor = UIColor(R: 255, G: 228, B: 139)
    static let borderLineColor: UIColor = UIColor(R: 180, G: 180, B: 180, A: 0.3)
}

final class LoadingView: UIView {
    
    private(set) var isAnimating = false
    
    // Layers
    private let shapeLayerInner = CAShapeLayer()
    private let shapeLayerOuter = CAShapeLayer()
    
    // Postitions At Certain Time of Animation
    private let positions: [Position] = [
        Position(seconds: 0.0, start: 0.000),
        Position(seconds: 0.6, start: 0.500),
        Position(seconds: 0.6, start: 1.000),
        Position(seconds: 0.6, start: 1.500),
        Position(seconds: 0.2, start: 1.875),
        Position(seconds: 0.2, start: 2.250),
        Position(seconds: 0.2, start: 2.625),
        Position(seconds: 0.3, start: 3.000),
        Position(seconds: 0.3, start: 3.250),
        Position(seconds: 0.3, start: 3.625)
    ]
    
    override var layer: CAShapeLayer {
        get {
            return super.layer as! CAShapeLayer
        }
    }
    
    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // Setup
    private func setup() {
        setupShapes()
        layer.addSublayer(shapeLayerInner)
        layer.addSublayer(shapeLayerOuter)
    }
    
    private func setupShapes() {
        setupInitialShape()
        setupInnerShape()
        setupOuterShape()
    }
    
    private func setupInitialShape() {
        layer.path = UIBezierPath(arcCenter: CGPoint(x: bounds.height / 2, y: bounds.height / 2),
                                  radius: bounds.width / 2 - .smallRadiusMargin,
                                  startAngle: CGFloat(-90).degreesToRadians,
                                  endAngle: CGFloat(270).degreesToRadians, clockwise: true).cgPath
        layer.fillColor = nil
        layer.strokeColor = UIColor.initialLineColor.cgColor
        layer.lineWidth = .initialLayerLineWidth
        layer.lineCap = .round
        layer.strokeEnd = .baseStrokeEnd
    }
    
    private func setupInnerShape() {
        shapeLayerInner.path = UIBezierPath(arcCenter: CGPoint(x: bounds.height / 2, y: bounds.height / 2),
                                            radius: bounds.width / 2 - .smallRadiusMargin - .loadingLineMargin,
                                            startAngle: CGFloat(90).degreesToRadians,
                                            endAngle: CGFloat(450).degreesToRadians, clockwise: true).cgPath
        shapeLayerInner.fillColor = nil
        shapeLayerInner.strokeColor = UIColor.borderLineColor.cgColor
        shapeLayerInner.lineWidth = .innerAndOuterLayerLineWidth
    }
    
    private func setupOuterShape() {
        shapeLayerOuter.path = UIBezierPath(arcCenter: CGPoint(x: bounds.height / 2, y: bounds.height / 2),
                                            radius: bounds.width / 2 - .smallRadiusMargin + .loadingLineMargin,
                                            startAngle: CGFloat(90).degreesToRadians,
                                            endAngle: CGFloat(450).degreesToRadians, clockwise: true).cgPath
        shapeLayerOuter.fillColor = nil
        shapeLayerOuter.strokeColor = UIColor.borderLineColor.cgColor
        shapeLayerOuter.lineWidth = .innerAndOuterLayerLineWidth
    }
    
    /// Start Animation
    func startAnimation() {
        isAnimating = true
        isHidden = false
        var time: CFTimeInterval = 0
        var times = [CFTimeInterval]()
        var start: CGFloat = 0
        var rotations = [CGFloat]()
        let totalSeconds = positions.reduce(0) { $0 + $1.seconds }
        for position in positions {
            time += position.seconds
            times.append(time / totalSeconds)
            start = position.start
            rotations.append(start * 2 * .pi)
        }
        animateKeyPath(keyPath: "transform.rotation",
                       duration: totalSeconds,
                       times: times,
                       values: rotations)
    }
    
    /// Stop Animation
    func stopAnimation() {
        isAnimating = false
        layer.removeAllAnimations()
        isHidden = true
    }
    
    private func animateKeyPath(keyPath: String, duration: CFTimeInterval, times: [CFTimeInterval], values: [CGFloat]) {
        let animation = CAKeyframeAnimation(keyPath: keyPath)
        animation.keyTimes = times as [NSNumber]?
        animation.values = values
        animation.calculationMode = .linear
        animation.duration = duration
        animation.repeatCount = Float.infinity
        layer.add(animation, forKey: animation.keyPath)
    }
}
