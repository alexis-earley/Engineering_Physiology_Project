% Time parameters
dt = 1e-5;                % Time step (s)
T_end = 0.1;              % Total simulation time (s)
t = 0:dt:T_end;           % Time vector

% Constants (biologically relevant)
C_bas = 10e-12;           % Capacitance (F)
G_bas = 2e-9;             % Basolateral conductance (S)
G_K = 5e-9;               % Potassium conductance (S)
V_bas = -60e-3;           % Basolateral potential (V)
V_K = -75e-3;             % Potassium reversal potential (V)

% Sinusoidal input current J_K(t)
A = 0.5e-9;               % Amplitude of J_K (A)
f = 100;                  % Frequency (Hz)
J_K = A * sin(2 * pi * f * t);

% Initialize membrane voltage
V_mem = zeros(size(t));
V_mem(1) = -65e-3;        % Initial membrane voltage (V)

% Euler integration
for i = 1:length(t)-1
    dVdt = ( -G_bas * (V_mem(i) - V_bas) ...
             -G_K * (V_mem(i) - V_K) ...
             + J_K(i) ) / C_bas;
    V_mem(i+1) = V_mem(i) + dt * dVdt;
end

% Plotting
plot(t*1000, V_mem*1000, 'b', 'LineWidth', 1.5)
xlabel('Time (ms)')
ylabel('Membrane Voltage (mV)')
title('Inner Hair Cell V_{membrane} Response to Sinusoidal J_K')
grid on