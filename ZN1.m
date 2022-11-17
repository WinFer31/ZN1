% Define Transfer Function
s = tf('s');
sys = 0.03/(49*s^2+2.8*s+1);
[y,time] = step(sys);

% K is final value of y
k = y(end);

% Find value of L and T, using an amplitude threshold criteria
% Where L > 5%; T > 63%
L_index = find(y >= 0.05*k,1);
L = time(L_index);
T_index = find(y >= (1-exp(-1))*k,1);
T = time(T_index);

% Find tangential line slope
slope = diff(y)./diff(time);
inflctn = find(diff(slope)./diff(time(1:end-1))<0,1);


% Tangent Equation
A = slope(inflctn)*time(inflctn)-y(inflctn);
tangent = slope(inflctn)*time - A;

% Plot the results
hold on
step(sys, 'b');
scatter(L,y(L_index),75, 'filled', 'r');
scatter(T,y(T_index), 75, 's', 'filled', 'r')
legend('Control Plant', 'L', 'T')
% plot(time,tangent); % <- Optional, to plot tanget

% Results output
L, T
P_Controller = [(T/(k*L)), 0, 0]
PI_Controller = [(0.9*(T/(k*L))), (1/(3.3*L)), 0]
PID_Controller = [(1.2*(T/(k*L))), (1/(2*L)), (0.5*L)]