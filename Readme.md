# 🎨 Interactive Cubic Bézier Rope

An interactive **cubic Bézier curve simulation** that behaves like a **springy rope**, reacting to real-time input on both **Web (Canvas + JavaScript)** and **iOS (Swift + CoreMotion)**.

This project demonstrates understanding of **mathematical modeling**, **graphics rendering**, and **real-time physics simulation** — all built completely from scratch.

---

## ⚖️ Overview

| Platform | Input Type | Rendering | Target FPS |
|-----------|-------------|------------|-------------|
| **Web** | Mouse / Touch | HTML5 Canvas | 60 FPS |
| **iOS** | Gyroscope (Pitch, Roll) | CoreMotion + Quartz Drawing | 60 FPS |

Both implementations share the same **mathematical and physics model**, but differ in input handling and rendering approach.

---

## 🖼️ Demo Preview

### 🌐 Web Version
<video src="assets/WEB.mp4" controls width="600">
  Your browser does not support the video tag.
</video>

### 📱 iOS Version
<video src="assets/IOS.mp4" controls width="600">
  Your browser does not support the video tag.
</video>



## 🧮 Mathematical Model

### 1️⃣ Cubic Bézier Curve

The rope is modeled using a **cubic Bézier curve** defined by four control points \( P₀, P₁, P₂, P₃ \).

- **P₀** and **P₃** → Fixed endpoints  
- **P₁** and **P₂** → Dynamic control points that move under spring physics  

The curve is evaluated for small increments of **t** (from 0 → 1) to draw smooth line segments, forming the rope.

---

### 2️⃣ Tangent Calculation

At any point on the curve, a **tangent vector** is computed to visualize direction and curvature.  
Tangents are drawn as short lines along the rope, showing how the curve bends and reacts to motion.

---

## ⚙️ Physics Model: Spring-Damper System

Each dynamic control point behaves like a **mass attached to a spring** that always tries to move toward its target position.

The system follows this rule:

- The **spring force** pulls the point toward equilibrium (stiffness).  
- **Damping** slows it down, creating smooth, natural oscillations.  
- Motion is integrated over time for smooth animation.

This gives the rope a **realistic elastic behavior** — it stretches, overshoots, and settles naturally.

---

## 🖱️ Web Implementation

### 🧱 Technologies
- **HTML5 Canvas** for rendering  
- **Vanilla JavaScript (ES6)** for math, physics, and animation  
- **CSS3** for minimal UI styling  

### 🎮 Interaction
Two interactive modes:

1. **Follow Mode:**  
   The rope smoothly reacts to mouse position using spring motion.  
2. **Drag Mode:**  
   You can grab and drag the control points directly, with natural momentum when released.

### 🖌️ Design Choices
- Linear **color gradient** along the rope  
- **Tangent visualization** for geometric insight  
- **Real-time FPS counter**  
- **Grid background** for spatial reference  
- **60 FPS** animation loop using `requestAnimationFrame()`

---

## 📱 iOS Implementation

### 🧱 Technologies
- **Swift + UIKit**  
- **CoreMotion** for gyroscope data  
- **CADisplayLink** for consistent 60 FPS rendering  
- **Quartz 2D (CGContext)** for manual curve drawing  

### 🎮 Interaction
- Device **tilt (pitch and roll)** controls the rope.  
- Control points move according to motion input.  
- The same **spring-damper physics** ensures smooth, realistic motion.

### 🖌️ Design Choices
- Gradient rope rendered with **Core Graphics**  
- Manual Bézier math (no `UIBezierPath` or SceneKit)  
- Control points and tangents drawn individually  
- Real-time physics simulation for natural rope motion  

---

## 🧠 Shared Design Principles

| Aspect | Description |
|--------|--------------|
| **Manual Math** | All Bézier and derivative calculations implemented from first principles. |
| **Spring Physics** | Smooth, elastic behavior based on real physical principles. |
| **Stable Frame Timing** | Fixed time-step integration ensures consistent performance. |
| **No Libraries** | Everything is written in plain JavaScript (Web) and Swift (iOS). |
| **Minimal UI** | Clean, educational visualization with simple controls. |

---

## 🧩 Project Structure

### Web

/BezierRopeWeb
├── index.html # HTML + inline CSS
├── script.js # Physics, math, and rendering logic
└── README.md


### iOS

/BezierRope_iOS
├── BezierRopeViewController.swift
├── SceneDelegate.swift
├── Info.plist
└── README.md


---

## 🧠 Key Concepts Demonstrated

- Parametric Curve Evaluation (Cubic Bézier)  
- Analytic Tangent Derivatives  
- Spring-Damper Physics Simulation  
- Real-time Rendering & Frame Management  
- Interactive Input Mapping (mouse, touch, gyroscope)  
- Platform-agnostic Design (same core math, different input/output)

---

## 🚀 How to Run

### 🖥️ Web
1. Open `index.html` in any browser.  
2. Move your mouse or drag control points to interact.  

### 📱 iOS
1. Open the project in Xcode.  
2. Add your development team under **Signing & Capabilities**.  
3. Run on a **physical iPhone** (gyroscope required).  

---

## ✨ Future Enhancements

- Add **color feedback** based on rope tension  
- Implement **gyroscope tilt input** in web browsers  
- Add **3D Bézier rope** (WebGL or Metal)  
- Introduce **rope collision detection** with objects  

---

## 🧰 Tools & Technologies

- **JavaScript**, **HTML5 Canvas**, **CSS3**  
- **Swift**, **UIKit**, **CoreMotion**, **CADisplayLink**  
- **Physics Simulation**, **Analytic Geometry**, **Real-time Animation**

---

## 🧑‍💻 Author

**Deepak Das Tatwa**  
Project demonstrating **graphics programming**, **mathematical modeling**, and **cross-platform real-time interactivity**.

---
