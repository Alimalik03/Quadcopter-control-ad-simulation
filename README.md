# Quadrotor 6-DOF Simulation

A full 6 degrees-of-freedom (6-DOF) nonlinear quadrotor simulation built in Simulink, with a cascaded position + attitude control architecture.

![3D Trajectory](assets/Trajectory_Plot.png)

## Overview

This project models a quadrotor's rigid-body dynamics from first principles and drives it with a cascaded PID control loop. It includes:

- Nonlinear translational and rotational equations of motion
- Motor mixing (rotor thrust/drag to torque and thrust)
- A position controller (outer loop) feeding an attitude controller (inner loop)
- A configurable trajectory generator for testing
- Automatic data logging and desired-vs-measured plotting

## Model Architecture

![Simulink Model](assets/Simulink_model_Image.png)

The model is split into four main subsystems:

| Subsystem | Role |
|---|---|
| `POSITION CONTROLLER` | Converts desired X, Y, Z, yaw into desired roll, pitch, thrust |
| `Attitude Controller` | Converts desired roll, pitch, yaw into motor torques |
| `Translational Dynamics` | Rigid-body position dynamics (X, Y, Z) |
| `Rotational Dynamics` | Rigid-body attitude dynamics (roll, pitch, yaw) + motor mixing |

Control is cascaded: the position loop runs slower and sets attitude targets; the attitude loop runs faster and tracks those targets with torque commands.

## Repository Structure

```
├── quadrotor_Simulink_Main.slx   # Main Simulink model
├── quad_params.m                 # Physical parameters (mass, inertia, etc.)
├── quad_model_sim.m               # Script to init params, run the model, and plot results
├── assets/                        # Result plots and model screenshots
│   ├── Simulink_model_Image.png
│   ├── Position_plots.png
│   ├── Attitude_Plots.png
│   └── Trajectory_Plot.png
└── README.md
```

## Requirements

- MATLAB (R2021b or newer recommended)
- Simulink
- No additional toolboxes required

## Getting Started

1. Clone the repo:
   ```bash
   git clone https://github.com/<your-username>/quadrotor-6dof-simulation.git
   cd quadrotor-6dof-simulation
   ```
2. Open MATLAB and set this folder as your working directory.
3. Run the script:
   ```matlab
   quad_model_sim
   ```

This will initialize the physical parameters, run the Simulink model, and automatically generate:
- Position states (X, Y, Z): desired vs measured
- Attitude states (roll, pitch, yaw): desired vs measured
- A 3D plot comparing the desired and measured flight path

## Results

The model was validated on a 3D circular trajectory with continuous yaw and a steady climb in altitude.

**Position tracking:**
![Position states](assets/Position_plots.png)

**Attitude tracking:**
![Attitude states](assets/Attitude_Plots.png)

Both position and attitude states track their references closely, including through the continuously changing yaw angle, confirming the axes are correctly decoupled.

## Physical Parameters

Defined in `quad_params.m`, based on a small quadrotor:

| Parameter | Symbol | Value |
|---|---|---|
| Mass | `m` | 0.65 kg |
| Roll/Pitch inertia | `Ix`, `Iy` | 7.5×10⁻³ kg·m² |
| Yaw inertia | `Iz` | 1.3×10⁻² kg·m² |
| Rotor inertia | `Ir` | 6.5×10⁻⁵ kg·m² |
| Thrust factor | `b` | 3.13×10⁻⁵ |
| Drag factor | `d` | 7.5×10⁻⁷ |
| Arm length | `l` | 0.23 m |

## Control Design

- PID gains for both the position and attitude loops were derived analytically from each axis's linearized plant transfer function, using pole placement.
- Torque and thrust saturation limits were added based on the physical motor-mixing constraints.
- Anti-windup (clamping) was added on all loops to prevent integrator windup during saturation.

## Known Limitations / Future Work

- Gains are tuned for a single operating point; gain scheduling could improve performance across a wider flight envelope.
- No sensor noise or estimator (e.g. EKF) is currently modeled — the plant states are fed back directly.
- No wind disturbance or aerodynamic drag model yet.

## License

MIT License — feel free to use, modify, and build on this project.

## Acknowledgments

Built as a learning project to explore 6-DOF nonlinear dynamics modeling and cascaded flight control design in Simulink.
