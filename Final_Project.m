clear
clc

% Set up range of times (x-axis)
dt = 1e-5; % Difference between time values
T_end = 0.08; % Total simulation time (s)
t = 0:dt:T_end; % List of times

G_bas = 1.104e-9; % Basolateral membrane conductance
% Calculated from Rattay et al. (1998) Table 1 and Appendix equations #8.
% They state that total membrane conductance = membrane surface area x 
% specific membrane conductance.
% This is equivalent to membrane conductance = membrane surface area / 
% specific membrane resistance.
% G_bas = (552 µm^2) / (5 kΩ m^2)
%       = (552 x 10e-12 m^2) / (0.5 Ω m^2) = 1.104e-9 S.

C_bas = 1.104e-11; % Basolateral membrane capacitance
% Calculated from Rattay et al. (1998) Table 1 and Appendix equations #8.
% They explain that total membrane capacitance = membrane surface area x 
% specific membrane capacitance.
% C_bas = (552 µm^2) x (2 µF / cm^2)
%       = (552 x 10e-12 m^2) x (0.02 F / m^2) = 1.104e-11 F.

G_K = 28.71e-9; % Potassium conductance
% From López-Poveda & Eustaquio-Martín (2006), Table 1.
% They utilized a potassium conductance of G_1 = 28.71 nS.

V_bas = -43e-3; % Basolateral membrane potential
% From Rattay et al. (1998), Table 1.
% They calculated the Nernst potential between the cortilymph and cytoplasm
% to be E_III = - 43 mV.

V_K = -75e-3; % Potassium equilibrium potential   
% From López-Poveda & Eustaquio-Martín (2006), Table 1.
% They used a potassium reversal potential of E_K = - 75 mV.

A_stereo = 2.0e-9; % Stereocilia current amplitude
% From López-Poveda & Eustaquio-Martín (2006), "Model Predictions" section.
% This was the maximum stereocilia current amplitude they employed.

freqs = [20, 200, 2000, 20000]; % Frequencies to simulate 
% The range of human hearing is from 20 to 20,000 Hz, as stated in the
% class neuron slide deck.

for idx = 1:length(freqs)
    freq = freqs(idx); % Get specific frequency

    J_stereo = A_stereo * sin(2 * pi * freq * t); % Current from stereocilia
    J_stereo(J_stereo < 0) = 0; % Half-wave rectification
    % From López-Poveda & Eustaquio-Martín (2006), "Model Predictions"
    % section.
    % They state a half-wave rectification of sine waves is a good 
    % approximation of the inner current of an IHC.
    
    J_K = 0.2e-9; % Outward potassium current
    % This value was chosen empirically, as models such as López-Poveda & 
    % Eustaquio-Martín (2006) describe an outward potassium current that 
    % varies. (See equation #1 in the Appendix.)
    % To simplify our model, we kept values as constants.
    % This value was chosen because it is biologically feasible, based
    % on other currents within the paper.

    V_mem = zeros(size(t)); % Set up list of membrane voltages
    V_mem(1) = -58e-3; % Initial membrane voltage
    % From López-Poveda & Eustaquio-Martín (2006), Figure 7.
    % They set V_m = -58 mV at the start of their model.
    
    % Euler method to determine membrane voltage (y-axis)
    for i = 1:(length(t) - 1)
        dVdt = (J_stereo(i) - G_bas * (V_mem(i) - V_bas) ...
                - G_K * (V_mem(i) - V_K) + J_K) / C_bas;
        V_mem(i+1) = V_mem(i) + dt * dVdt;
    end
    
    % Create graph
    subplot(2, 2, idx)
    ms = t*1000; % Convert to ms
    mV = V_mem*1000; % Convert to mV
    plot(ms, mV, 'b', 'LineWidth', 1) % Plot graph
    hold on
    plot(ms(1), mV(1), 'bx', 'MarkerSize', 6) % Plot starting point

    % Label graph and standardize axes 
    xlabel('Time (ms)')
    ylabel('Membrane Voltage (mV)')
    title(['f = ', num2str(freq), ' Hz'])
    sgtitle('IHC Membrane Voltage Responses to Frequency Stimuli');
    ylim([-70 10]);
    grid on
end
