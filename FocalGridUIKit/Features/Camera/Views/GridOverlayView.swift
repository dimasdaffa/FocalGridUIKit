//
//  GridOverlayView.swift
//  FocalGridUIKit
//
//  Created by DIMAS DAFFA ERNANDA on 17/08/26.
//

import UIKit

final class GridOverlayView: UIView {

    var compositionType: CompositionType = .ruleOfThirds {
        didSet { setNeedsDisplay() }
    }

    var gridColor: UIColor = .white.withAlphaComponent(0.65) {
        didSet { setNeedsDisplay() }
    }

    var lineWidth: CGFloat = 1.0 {
        didSet { setNeedsDisplay() }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        isUserInteractionEnabled = false
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.clear(rect)
        context.setStrokeColor(gridColor.cgColor)
        context.setLineWidth(lineWidth)

        switch compositionType {
        case .ruleOfThirds:
            drawRuleOfThirds(in: rect, context: context)
        case .goldenRatio:
            drawGoldenRatio(in: rect, context: context)
        case .symmetry:
            drawSymmetry(in: rect, context: context)
        case .diagonalLines:
            drawDiagonalLines(in: rect, context: context)
        case .leadingLines:
            drawLeadingLines(in: rect, context: context)
        }
    }

    // MARK: - Grid Renderers

    private func drawRuleOfThirds(in rect: CGRect, context: CGContext) {
        let w = rect.width
        let h = rect.height

        let x1 = w / 3.0
        let x2 = (w / 3.0) * 2.0
        let y1 = h / 3.0
        let y2 = (h / 3.0) * 2.0

        // Vertical lines
        context.move(to: CGPoint(x: x1, y: 0)); context.addLine(to: CGPoint(x: x1, y: h))
        context.move(to: CGPoint(x: x2, y: 0)); context.addLine(to: CGPoint(x: x2, y: h))

        // Horizontal lines
        context.move(to: CGPoint(x: 0, y: y1)); context.addLine(to: CGPoint(x: w, y: y1))
        context.move(to: CGPoint(x: 0, y: y2)); context.addLine(to: CGPoint(x: w, y: y2))
        context.strokePath()

        // Intersection points
        let points = [
            CGPoint(x: x1, y: y1), CGPoint(x: x2, y: y1),
            CGPoint(x: x1, y: y2), CGPoint(x: x2, y: y2)
        ]
        drawIntersectionCircles(points: points, context: context)
    }

    private func drawGoldenRatio(in rect: CGRect, context: CGContext) {
        let w = rect.width
        let h = rect.height
        let phi: CGFloat = 0.618033

        let x1 = w * (1.0 - phi)
        let x2 = w * phi
        let y1 = h * (1.0 - phi)
        let y2 = h * phi

        context.move(to: CGPoint(x: x1, y: 0)); context.addLine(to: CGPoint(x: x1, y: h))
        context.move(to: CGPoint(x: x2, y: 0)); context.addLine(to: CGPoint(x: x2, y: h))
        context.move(to: CGPoint(x: 0, y: y1)); context.addLine(to: CGPoint(x: w, y: y1))
        context.move(to: CGPoint(x: 0, y: y2)); context.addLine(to: CGPoint(x: w, y: y2))
        context.strokePath()

        let points = [
            CGPoint(x: x1, y: y1), CGPoint(x: x2, y: y1),
            CGPoint(x: x1, y: y2), CGPoint(x: x2, y: y2)
        ]
        drawIntersectionCircles(points: points, context: context)
    }

    private func drawSymmetry(in rect: CGRect, context: CGContext) {
        let midX = rect.midX
        let midY = rect.midY

        // Center cross
        context.move(to: CGPoint(x: midX, y: 0)); context.addLine(to: CGPoint(x: midX, y: rect.height))
        context.move(to: CGPoint(x: 0, y: midY)); context.addLine(to: CGPoint(x: rect.width, y: midY))
        context.strokePath()

        // Center focal ring
        context.addEllipse(in: CGRect(x: midX - 24, y: midY - 24, width: 48, height: 48))
        context.strokePath()
    }

    private func drawDiagonalLines(in rect: CGRect, context: CGContext) {
        let w = rect.width
        let h = rect.height

        // Main diagonals
        context.move(to: CGPoint(x: 0, y: 0)); context.addLine(to: CGPoint(x: w, y: h))
        context.move(to: CGPoint(x: w, y: 0)); context.addLine(to: CGPoint(x: 0, y: h))

        // Harmonic diagonals
        context.move(to: CGPoint(x: 0, y: h / 2)); context.addLine(to: CGPoint(x: w, y: 0))
        context.move(to: CGPoint(x: 0, y: h / 2)); context.addLine(to: CGPoint(x: w, y: h))
        context.strokePath()
    }

    private func drawLeadingLines(in rect: CGRect, context: CGContext) {
        let w = rect.width
        let h = rect.height
        let vanishPoint = CGPoint(x: w * 0.5, y: h * 0.4)

        context.move(to: CGPoint(x: 0, y: h)); context.addLine(to: vanishPoint)
        context.move(to: CGPoint(x: w, y: h)); context.addLine(to: vanishPoint)
        context.move(to: CGPoint(x: w * 0.25, y: h)); context.addLine(to: vanishPoint)
        context.move(to: CGPoint(x: w * 0.75, y: h)); context.addLine(to: vanishPoint)
        context.strokePath()

        drawIntersectionCircles(points: [vanishPoint], context: context)
    }

    private func drawIntersectionCircles(points: [CGPoint], context: CGContext) {
        for pt in points {
            context.addEllipse(in: CGRect(x: pt.x - 5, y: pt.y - 5, width: 10, height: 10))
        }
        context.strokePath()
    }
}
