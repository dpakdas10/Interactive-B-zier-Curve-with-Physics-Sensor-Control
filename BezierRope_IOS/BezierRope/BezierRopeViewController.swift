//
//  BezierRopeViewController.swift
//  BezierRope
//
//  Created by Deepak on 2025-11-09.
//

import UIKit
import CoreMotion

// MARK: - SpringPoint physics model
final class SpringPoint {
    var position: CGPoint
    var velocity: CGPoint = .zero
    var target: CGPoint
    var mass: CGFloat = 1
    var stiffness: CGFloat = 80
    var damping: CGFloat = 14

    init(x: CGFloat, y: CGFloat) {
        position = CGPoint(x: x, y: y)
        target = position
    }

    func step(dt: CGFloat) {
        let dx = position.x - target.x
        let dy = position.y - target.y
        var ax = -stiffness * dx / mass
        var ay = -stiffness * dy / mass
        ax += -damping * velocity.x / mass
        ay += -damping * velocity.y / mass

        velocity.x += ax * dt
        velocity.y += ay * dt

        position.x += velocity.x * dt
        position.y += velocity.y * dt
    }
}

// MARK: - Bézier Rope View
final class BezierRopeView: UIView {

    var P0 = CGPoint.zero
    var P3 = CGPoint.zero
    var p1 = SpringPoint(x: 0, y: 0)
    var p2 = SpringPoint(x: 0, y: 0)

    override func layoutSubviews() {
        super.layoutSubviews()
        P0 = CGPoint(x: 60, y: bounds.midY)
        P3 = CGPoint(x: bounds.width - 60, y: bounds.midY)
        if p1.position == .zero && p2.position == .zero {
            let midX = (P0.x + P3.x) / 2
            p1 = SpringPoint(x: lerp(a: P0.x, b: midX, t: 0.5), y: P0.y - 120)
            p2 = SpringPoint(x: lerp(a: midX, b: P3.x, t: 0.5), y: P3.y - 120)
        }
    }

    func update(dt: CGFloat) {
        p1.step(dt: dt)
        p2.step(dt: dt)
        setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        ctx.clear(rect)

        let P0 = self.P0, P3 = self.P3
        let P1 = p1.position, P2 = p2.position

        // --- Bézier sampling ---
        func B(_ t: CGFloat) -> CGPoint {
            let u = 1 - t
            let u2 = u * u, u3 = u2 * u
            let t2 = t * t, t3 = t2 * t
            let x = u3 * P0.x + 3*u2*t*P1.x + 3*u*t2*P2.x + t3*P3.x
            let y = u3 * P0.y + 3*u2*t*P1.y + 3*u*t2*P2.y + t3*P3.y
            return CGPoint(x: x, y: y)
        }

        func dB(_ t: CGFloat) -> CGVector {
            let u = 1 - t
            let c1 = 3 * u * u
            let c2 = 6 * u * t
            let c3 = 3 * t * t
            let vx = c1 * (P1.x - P0.x) + c2 * (P2.x - P1.x) + c3 * (P3.x - P2.x)
            let vy = c1 * (P1.y - P0.y) + c2 * (P2.y - P1.y) + c3 * (P3.y - P2.y)
            return CGVector(dx: vx, dy: vy)
        }

        // --- Draw Bézier curve ---
        ctx.setLineWidth(5)
        ctx.setLineJoin(.round)
        ctx.setLineCap(.round)
        let gradientColors = [UIColor.systemTeal.cgColor,
                              UIColor.systemPurple.cgColor,
                              UIColor.systemPink.cgColor] as CFArray
        if let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                     colors: gradientColors, locations: [0, 0.6, 1]) {
            // Create path for the curve
            let path = CGMutablePath()
            let steps = Int(1.0 / 0.01)
            var started = false
            for i in 0...steps {
                let t = CGFloat(i) * 0.01
                let p = B(t)
                if !started {
                    path.move(to: p)
                    started = true
                } else {
                    path.addLine(to: p)
                }
            }
            ctx.addPath(path)
            ctx.replacePathWithStrokedPath()
            ctx.clip()
            ctx.drawLinearGradient(gradient,
                                   start: CGPoint(x: P0.x, y: 0),
                                   end: CGPoint(x: P3.x, y: 0),
                                   options: [])
        }

        // --- Tangent vectors ---
        ctx.setLineWidth(1)
        ctx.setStrokeColor(UIColor.white.withAlphaComponent(0.5).cgColor)
        for t in stride(from: 0.0, through: 1.0, by: 0.05) {
            let pt = B(t)
            let d = dB(t)
            let len = sqrt(d.dx*d.dx + d.dy*d.dy)
            if len > 0 {
                let nx = d.dx / len
                let ny = d.dy / len
                let s: CGFloat = 24
                ctx.move(to: CGPoint(x: pt.x - nx*s/2, y: pt.y - ny*s/2))
                ctx.addLine(to: CGPoint(x: pt.x + nx*s/2, y: pt.y + ny*s/2))
                ctx.strokePath()
            }
        }

        // --- Control handles ---
        ctx.setLineWidth(1)
        ctx.setStrokeColor(UIColor.white.withAlphaComponent(0.2).cgColor)
        ctx.move(to: P0)
        ctx.addLine(to: P1)
        ctx.move(to: P2)
        ctx.addLine(to: P3)
        ctx.strokePath()

        // --- Draw control points ---
        func drawPoint(_ p: CGPoint, color: UIColor) {
            ctx.setFillColor(color.cgColor)
            ctx.addEllipse(in: CGRect(x: p.x - 6, y: p.y - 6, width: 12, height: 12))
            ctx.fillPath()
        }
        drawPoint(P0, color: .systemGreen)
        drawPoint(P3, color: .systemGreen)
        drawPoint(P1, color: .systemYellow)
        drawPoint(P2, color: .systemYellow)
    }
}

// MARK: - View Controller
final class BezierRopeViewController: UIViewController {

    private let motion = CMMotionManager()
    private var displayLink: CADisplayLink!
    private var ropeView: BezierRopeView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        ropeView = BezierRopeView(frame: view.bounds)
        ropeView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(ropeView)

        if motion.isDeviceMotionAvailable {
            motion.deviceMotionUpdateInterval = 1 / 60.0
            motion.startDeviceMotionUpdates()
        }

        displayLink = CADisplayLink(target: self, selector: #selector(step))
        displayLink.add(to: .main, forMode: .default)
    }

    @objc private func step() {
        let dt: CGFloat = 1 / 60.0

        if let dm = motion.deviceMotion {
            // Map gyroscope pitch & roll to control point movement
            let pitch = dm.attitude.pitch    // tilt forward/back
            let roll = dm.attitude.roll      // tilt left/right
            let sensitivity: CGFloat = 250

            let offset = CGPoint(
                x: CGFloat(roll) * sensitivity,
                y: CGFloat(-pitch) * sensitivity
            )

            let P0 = ropeView.P0
            let P3 = ropeView.P3
            let base1 = CGPoint(
                x: lerp(a: P0.x, b: P3.x, t: 0.33),
                y: P0.y - 120
            )
            let base2 = CGPoint(
                x: lerp(a: P0.x, b: P3.x, t: 0.66),
                y: P3.y - 120
            )

            ropeView.p1.target = CGPoint(x: base1.x + offset.x * 0.6, y: base1.y + offset.y * 0.6)
            ropeView.p2.target = CGPoint(x: base2.x + offset.x * 0.6, y: base2.y + offset.y * 0.6)
        }

        ropeView.update(dt: dt)
    }

    deinit {
        displayLink.invalidate()
        motion.stopDeviceMotionUpdates()
    }
}

// MARK: - Utility
private func lerp(a: CGFloat, b: CGFloat, t: CGFloat) -> CGFloat {
    return a + (b - a) * t
}
