//
//  GridOverlayView.swift
//  FocalGridUIKit
//
//  Created by DIMAS DAFFA ERNANDA on 17/08/26.
//

import UIKit

final class GridOverlayView: UIView {

    var compositionType: CompositionType = .ruleOfThirds {
        didSet {
            updateInteractionState()
            setNeedsDisplay()
        }
    }

    var gridColor: UIColor = .white.withAlphaComponent(0.7) {
        didSet { setNeedsDisplay() }
    }

    var lineWidth: CGFloat = 1.0 {
        didSet { setNeedsDisplay() }
    }

    /// Derajat rotasi grid (0, 90, 180, 270)
    var rotationDegrees: CGFloat = 0 {
        didSet { setNeedsDisplay() }
    }

    /// Posisi normalisasi titik hilang Leading Lines (0.0 ... 1.0)
    private(set) var vanishingPointNormalized: CGPoint = CGPoint(x: 0.5, y: 0.4) {
        didSet { setNeedsDisplay() }
    }

    private var isDraggingFocalPoint = false
    private let feedbackGenerator = UISelectionFeedbackGenerator()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        isUserInteractionEnabled = true
        setupGesture()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupGesture() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        pan.maximumNumberOfTouches = 1
        addGestureRecognizer(pan)
    }

    private func updateInteractionState() {
        // Interaksi drag aktif penuh pada komposisi Leading Lines
        isUserInteractionEnabled = true
    }

    // MARK: - Gesture Handling (Drag Vanishing Point)

    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard compositionType == .leadingLines else { return }

        let location = gesture.location(in: self)
        let normalizedX = max(0.08, min(location.x / bounds.width, 0.92))
        let normalizedY = max(0.08, min(location.y / bounds.height, 0.92))

        switch gesture.state {
        case .began:
            let currentPt = CGPoint(x: vanishingPointNormalized.x * bounds.width,
                                    y: vanishingPointNormalized.y * bounds.height)
            let distance = hypot(location.x - currentPt.x, location.y - currentPt.y)
            
            // Pengguna bisa mulai drag jika menyentuh area dekat titik atau menyentuh layar
            if distance < 60 || true {
                isDraggingFocalPoint = true
                feedbackGenerator.prepare()
                feedbackGenerator.selectionChanged()
                vanishingPointNormalized = CGPoint(x: normalizedX, y: normalizedY)
            }
        case .changed:
            if isDraggingFocalPoint {
                vanishingPointNormalized = CGPoint(x: normalizedX, y: normalizedY)
            }
        case .ended, .cancelled:
            isDraggingFocalPoint = false
        default:
            break
        }
    }

    // MARK: - Drawing Pipeline

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.clear(rect)
        context.setStrokeColor(gridColor.cgColor)
        context.setLineWidth(lineWidth)

        context.saveGState()

        // Terapkan rotasi di titik tengah frame
        if rotationDegrees != 0 && compositionType != .leadingLines {
            context.translateBy(x: rect.midX, y: rect.midY)
            context.rotate(by: rotationDegrees * .pi / 180.0)
            context.translateBy(x: -rect.midX, y: -rect.midY)
        }

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

        context.restoreGState()
    }

    // MARK: - Grid Renderers

    private func drawRuleOfThirds(in rect: CGRect, context: CGContext) {
        let w = rect.width, h = rect.height
        let x1 = w / 3.0, x2 = (w / 3.0) * 2.0
        let y1 = h / 3.0, y2 = (h / 3.0) * 2.0

        context.move(to: CGPoint(x: x1, y: 0)); context.addLine(to: CGPoint(x: x1, y: h))
        context.move(to: CGPoint(x: x2, y: 0)); context.addLine(to: CGPoint(x: x2, y: h))
        context.move(to: CGPoint(x: 0, y: y1)); context.addLine(to: CGPoint(x: w, y: y1))
        context.move(to: CGPoint(x: 0, y: y2)); context.addLine(to: CGPoint(x: w, y: y2))
        context.strokePath()

        drawIntersectionCircles(points: [
            CGPoint(x: x1, y: y1), CGPoint(x: x2, y: y1),
            CGPoint(x: x1, y: y2), CGPoint(x: x2, y: y2)
        ], context: context)
    }

    private func drawGoldenRatio(in rect: CGRect, context: CGContext) {
        let w = rect.width, h = rect.height
        let phi: CGFloat = 0.618033

        let x1 = w * (1.0 - phi), x2 = w * phi
        let y1 = h * (1.0 - phi), y2 = h * phi

        context.move(to: CGPoint(x: x1, y: 0)); context.addLine(to: CGPoint(x: x1, y: h))
        context.move(to: CGPoint(x: x2, y: 0)); context.addLine(to: CGPoint(x: x2, y: h))
        context.move(to: CGPoint(x: 0, y: y1)); context.addLine(to: CGPoint(x: w, y: y1))
        context.move(to: CGPoint(x: 0, y: y2)); context.addLine(to: CGPoint(x: w, y: y2))
        context.strokePath()

        drawIntersectionCircles(points: [
            CGPoint(x: x1, y: y1), CGPoint(x: x2, y: y1),
            CGPoint(x: x1, y: y2), CGPoint(x: x2, y: y2)
        ], context: context)
    }

    private func drawSymmetry(in rect: CGRect, context: CGContext) {
        let midX = rect.midX, midY = rect.midY

        context.move(to: CGPoint(x: midX, y: 0)); context.addLine(to: CGPoint(x: midX, y: rect.height))
        context.move(to: CGPoint(x: 0, y: midY)); context.addLine(to: CGPoint(x: rect.width, y: midY))
        context.strokePath()

        context.addEllipse(in: CGRect(x: midX - 24, y: midY - 24, width: 48, height: 48))
        context.strokePath()
    }

    private func drawDiagonalLines(in rect: CGRect, context: CGContext) {
        let w = rect.width, h = rect.height

        context.move(to: CGPoint(x: 0, y: 0)); context.addLine(to: CGPoint(x: w, y: h))
        context.move(to: CGPoint(x: w, y: 0)); context.addLine(to: CGPoint(x: 0, y: h))
        context.move(to: CGPoint(x: 0, y: h / 2)); context.addLine(to: CGPoint(x: w, y: 0))
        context.move(to: CGPoint(x: 0, y: h / 2)); context.addLine(to: CGPoint(x: w, y: h))
        context.strokePath()
    }

    private func drawLeadingLines(in rect: CGRect, context: CGContext) {
        let w = rect.width, h = rect.height
        let vanishPoint = CGPoint(
            x: vanishingPointNormalized.x * w,
            y: vanishingPointNormalized.y * h
        )

        // Garis perspektif dinamis
        context.move(to: CGPoint(x: 0, y: h)); context.addLine(to: vanishPoint)
        context.move(to: CGPoint(x: w, y: h)); context.addLine(to: vanishPoint)
        context.move(to: CGPoint(x: w * 0.33, y: h)); context.addLine(to: vanishPoint)
        context.move(to: CGPoint(x: w * 0.66, y: h)); context.addLine(to: vanishPoint)
        context.move(to: CGPoint(x: 0, y: h * 0.5)); context.addLine(to: vanishPoint)
        context.move(to: CGPoint(x: w, y: h * 0.5)); context.addLine(to: vanishPoint)
        context.strokePath()

        // Lingkaran target interaktif (Focal Ring)
        let ringRadius: CGFloat = isDraggingFocalPoint ? 26 : 20
        let targetRect = CGRect(
            x: vanishPoint.x - ringRadius,
            y: vanishPoint.y - ringRadius,
            width: ringRadius * 2,
            height: ringRadius * 2
        )

        // Background pendaran target saat di-drag
        context.setFillColor(UIColor.systemYellow.withAlphaComponent(isDraggingFocalPoint ? 0.25 : 0.08).cgColor)
        context.fillEllipse(in: targetRect)

        // Border target
        context.setStrokeColor(isDraggingFocalPoint ? UIColor.systemYellow.cgColor : gridColor.cgColor)
        context.setLineWidth(isDraggingFocalPoint ? 2.0 : 1.5)
        context.strokeEllipse(in: targetRect)

        // Titik pusat
        context.setFillColor(isDraggingFocalPoint ? UIColor.systemYellow.cgColor : gridColor.cgColor)
        context.fillEllipse(in: CGRect(x: vanishPoint.x - 3.5, y: vanishPoint.y - 3.5, width: 7, height: 7))
    }

    private func drawIntersectionCircles(points: [CGPoint], context: CGContext) {
        for pt in points {
            context.addEllipse(in: CGRect(x: pt.x - 5, y: pt.y - 5, width: 10, height: 10))
        }
        context.strokePath()
    }
}
