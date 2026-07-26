# 6DOF Quadrotor Simulation in MATLAB/Simulink

A complete nonlinear **6 Degrees-of-Freedom (6DOF)** quadrotor simulation developed in **MATLAB/Simulink**, featuring a cascaded position and attitude control architecture for autonomous trajectory tracking.

---

## Overview

This project implements the full rigid-body dynamics of a quadrotor along with a cascaded PID flight controller. The model is built in a modular manner to allow easy controller development and testing.

### Features

- Nonlinear 6DOF translational and rotational dynamics
- Cascaded position and attitude control
- Rotor thrust and torque allocation (motor mixing)
- Configurable reference trajectory generation
- Automatic simulation and plotting
- Desired vs. measured state comparison
- 3D trajectory visualization

---

# Simulink Architecture

The overall simulation is organized into modular subsystems consisting of the position controller, attitude controller, translational dynamics, and rotational dynamics.

<p align="center">
<img src="assets/simulink_model.png" width="900">
</p>

---

# Control Architecture

The controller follows a cascaded structure.

```
Position Reference
        │
        ▼
 Position Controller
        │
 Desired Roll / Pitch / Thrust
        │
        ▼
 Attitude Controller
        │
 Desired Torques
        │
        ▼
 6DOF Quadrotor Dynamics
```

The outer-loop controller regulates the vehicle position and generates desired attitude commands, while the inner-loop controller tracks these attitude references using torque commands.

---

# Simulation Results

The controller was evaluated on a continuously varying three-dimensional trajectory with simultaneous position and yaw tracking.

## Position Tracking

<p align="center">
<img src="assets/position_tracking.png" width="900">
</p>

The quadrotor accurately tracks the desired X, Y and altitude trajectories with minimal steady-state error.

---

## Attitude Tracking

<p align="center">
<img src="assets/attitude_tracking.png" width="900">
</p>

The roll, pitch and yaw controllers maintain accurate attitude tracking throughout the flight while remaining stable during dynamic maneuvers.

---

## 3D Flight Trajectory

<p align="center">
<img src="assets/trajectory.png" width="700">
</p>

The measured trajectory closely follows the commanded reference throughout the simulation.

# Getting Started

Clone the repository

```bash
git clone https://github.com/<username>/6DOF-Quadrotor-Simulation.git
```

Open MATLAB and set the repository as the working directory.

Run

```matlab
quad_model_sim
```

The script automatically:

- Initializes the quadrotor parameters
- Runs the Simulink model
- Generates position tracking plots
- Generates attitude tracking plots
- Generates the 3D trajectory comparison

---

# Physical Parameters

| Parameter | Symbol | Value |
|-----------|--------|-------|
| Mass | m | 0.65 kg |
| Roll Inertia | Ix | 7.5×10⁻³ kg·m² |
| Pitch Inertia | Iy | 7.5×10⁻³ kg·m² |
| Yaw Inertia | Iz | 1.3×10⁻² kg·m² |
| Rotor Inertia | Ir | 6.5×10⁻⁵ kg·m² |
| Arm Length | l | 0.23 m |
| Thrust Coefficient | b | 3.13×10⁻⁵ |
| Drag Coefficient | d | 7.5×10⁻⁷ |

---

# Control Design

- Cascaded position and attitude control architecture
- PID gains obtained from linearized plant models using pole placement
- Motor thrust and torque allocation
- Control saturation limits
- Integral anti-windup through clamping


## Author

**Aliasgar Malik**

MSc Aerial Robotics | Flight Controls | Guidance, Navigation & Control (GNC)
