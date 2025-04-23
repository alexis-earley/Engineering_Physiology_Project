
% Time parameters
dt = 1e-5;                % Time step (s)
T_end = 0.05;             % Total simulation time (s)
t = 0:dt:T_end;           % Time vector



% Inner Hair Cell Parameters (from López-Poveda & Eustaquio-Martín, 2006, Table 1 - In Vivo)
C_bas = 8.0e-12;          % Capacitance (F), Table 1: C_b
G_bas = 0.33e-9;          % Basolateral leakage conductance (S), Table 1: G_b
G_K = 30.72e-9;           % Fast potassium conductance (S), Table 1: G_K,f
V_bas = -60e-3;           % Basolateral potential (V), assumed standard IHC resting value
V_K = -78e-3;             % Potassium reversal potential (V), Table 1: E_K

%{

% Inner Hair Cell Parameters (sources noted)
C_bas = 11.0e-12;         % Capacitance (F) from Rattay et al. (1998)
G_bas = 0.33e-9;          % Basolateral leakage conductance (S), from López-Poveda & Eustaquio-Martín (2006), Table 1
G_K = 30.72e-9;           % Fast potassium conductance (S), from López-Poveda & Eustaquio-Martín (2006), Table 1
V_bas = -60e-3;           % Basolateral potential (V), assumed standard IHC resting value, used in López-Poveda & Eustaquio-Martín (2006)and Rattay et al.(1998) 
V_K = -78e-3;             % Potassium reversal potential (V), Table 1: E_K
%V_K = -43e-3;             % Potassium reversal potential (V), from Rattay et al. (1998), Table I (E_III)

%}
% Half-wave rectified stereocilia current (biologically inspired)

% THIS IS WHAT IS BEING VARIED:
f_stereo = 500;           % Test between 500 and 4000 Hz, supported by Dubno et al. (1989)

A_stereo = 0.8e-9;       % 800 pA; López-Poveda et al. (2006) used 1–2000 pA sweeps
J_stereo = A_stereo * sin(2 * pi * f_stereo * t);
J_stereo(J_stereo < 0) = 0;  % Half-wave rectification to mimic MET directionality as in López-Poveda & Eustaquio-Martín (2006)

J_K = 0.1e-9;             % Constant potassium current (A), small background current

% Initial membrane voltage
V_mem = zeros(size(t));
V_mem(1) = -60e-3;        % Initial condition (V), matches V_bas (used in both papers)

% Euler Integration
for i = 1:length(t)-1
    dVdt = ( J_stereo(i) ...
            - G_bas * (V_mem(i) - V_bas) ...
            - G_K * (V_mem(i) - V_K) ...
            + J_K ) / C_bas;
    V_mem(i+1) = V_mem(i) + dt * dVdt;
end

% Plotting
figure
plot(t*1000, V_mem*1000, 'b', 'LineWidth', 1.5)
xlabel('Time (ms)')
ylabel('Membrane Voltage (mV)')
title('Inner Hair Cell V_{membrane} Response to Half-Wave Rectified J_{stereocilia}')
grid on
