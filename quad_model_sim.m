%% quad_run_and_plot.m
% Initializes quadrotor parameters, runs the Simulink model, and
% automatically generates:
%   1) A 3x2 grid of "desired vs measured" plots for all 6 states
%      (x, y, z, phi, theta, psi)
%   2) A 3D plot comparing the desired vs measured flight trajectory
%
% Just run this one script (assuming this .m file and
% quadrotor_Simulink_Main.slx are on your MATLAB path / in the same folder).

clear; clc; close all;

%% 1. Initialize quadrotor parameters (from quad_params.m)
Ix = 7.5*10^(-3);   % Moment of inertia around X axis
Iy = 7.5*10^(-3);   % Moment of inertia around Y axis
Iz = 1.3*10^(-2);   % Moment of inertia around Z axis
Ir = 6.5*10^(-5);   % Total rotational moment of inertia (propeller axis)
b  = 3.13*10^(-5);  % Thrust factor
d  = 7.5*10^(-7);   % Drag factor
l  = 0.23;          % Distance to the center of the quadrotor
m  = 0.65;          % Mass (kg)
g  = 9.81;          % Gravitational acceleration

%% 2. Run the Simulink model
modelName = 'quadrotor_Simulink_Main';
open_system(modelName);           % opens the model (optional, comment out if not wanted)
simOut = sim(modelName);          % runs the simulation

%% 4. Plot all 6 states: desired vs measured
tlim = padlimits(simOut);   % small time-axis padding so the curve isn't flush against the frame

fig1 = figure('Name','Position States','NumberTitle','off', ...
              'Color','w','Units','normalized','OuterPosition',[0.05 0.05 0.9 0.9]);
title('Position States')
subplot(3,1,1)
plot(simOut, x_d, 'r--', 'LineWidth', 2); hold on
plot(simOut, x_measured, 'k-', 'LineWidth', 1.5);
xlabel('Time (s)'); ylabel('X (m)'); title('X Position');
legend('Desired','Measured','Location','best'); grid on; box on
xlim(tlim); ylim(padlimits(x_d, x_measured));
set(gca,'FontSize',10)

subplot(3,1,2)
plot(simOut, y_d, 'r--', 'LineWidth', 2); hold on
plot(simOut, y_measured, 'k-', 'LineWidth', 1.5);
xlabel('Time (s)'); ylabel('Y (m)'); title('Y Position');
legend('Desired','Measured','Location','best'); grid on; box on
xlim(tlim); ylim(padlimits(y_d, y_measured));
set(gca,'FontSize',10)

subplot(3,1,3)
plot(simOut, z_d, 'r--', 'LineWidth', 2); hold on
plot(simOut, z_measured, 'k-', 'LineWidth', 1.5);
xlabel('Time (s)'); ylabel('Z (m)'); title('Z Position (Altitude)');
legend('Desired','Measured','Location','best'); grid on; box on
xlim(tlim); ylim(padlimits(z_d, z_measured));
set(gca,'FontSize',10)

fig2 = figure('Name','Attitude States','NumberTitle','off', ...
              'Color','w','Units','normalized','OuterPosition',[0.05 0.05 0.9 0.9]);
title('Attitude States')
subplot(3,1,1)
plot(simOut, Phi_desired, 'r--', 'LineWidth', 2); hold on
plot(simOut, phi_measured, 'k-', 'LineWidth', 1.5);
xlabel('Time (s)'); ylabel('Roll (rad)'); title('Roll Angle \phi');
legend('Desired','Measured','Location','best'); grid on; box on
xlim(tlim); ylim(padlimits(Phi_desired, phi_measured));
set(gca,'FontSize',10)

subplot(3,1,2)
plot(simOut, Theta_desired, 'r--', 'LineWidth', 2); hold on
plot(simOut, Theta_measured, 'k-', 'LineWidth', 1.5);
xlabel('Time (s)'); ylabel('Pitch (rad)'); title('Pitch Angle \theta');
legend('Desired','Measured','Location','best'); grid on; box on
xlim(tlim); ylim(padlimits(Theta_desired, Theta_measured));
set(gca,'FontSize',10)

subplot(3,1,3)
plot(simOut, Psi_desired, 'r--', 'LineWidth', 2); hold on
plot(simOut, Psi_measured, 'k-', 'LineWidth', 1.5);
xlabel('Time (s)'); ylabel('Yaw (rad)'); title('Yaw Angle \psi');
legend('Desired','Measured','Location','best'); grid on; box on
xlim(tlim); ylim(padlimits(Psi_desired, Psi_measured));
set(gca,'FontSize',10)


%% 5. 3D trajectory comparison
fig3 = figure('Name','3D Trajectory','NumberTitle','off', ...
              'Color','w','Units','normalized','OuterPosition',[0.15 0.15 0.7 0.7]);
plot3(x_d, y_d, z_d, 'r--', 'LineWidth', 2); hold on
plot3(x_measured, y_measured, z_measured, 'k-', 'LineWidth', 1.5);
grid on;
xlabel('X (m)'); ylabel('Y (m)'); zlabel('Z (m)');
title('3D Trajectory','FontSize',13,'FontWeight','bold');
legend('Desired','Measured','Location','best');
xlim(padlimits(x_d, x_measured));
ylim(padlimits(y_d, y_measured));
zlim(padlimits(z_d, z_measured));
% set(gca,'FontSize',10,'DataAspectRatio',[1 1 1])

%% ------------------------------------------------------------------
function lims = padlimits(varargin)
% PADLIMITS  Compute axis limits that comfortably frame one or more
% signals, so the full response (including any overshoot/undershoot
% between desired and measured) stays clear of the plot edges.
    alldata = [];
    for i = 1:nargin
        alldata = [alldata; varargin{i}(:)]; 
    end
    alldata = alldata(isfinite(alldata));
    lo = min(alldata);
    hi = max(alldata);
    span = hi - lo;
    if span < eps            % flat / near-constant signal -- avoid a zero-height axis
        span = max(abs(hi), 1);
    end
    pad = 0.1 * span;
    lims = [lo - pad, hi + pad];
end