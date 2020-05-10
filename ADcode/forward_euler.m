clear all; close all;
%==========================================================================
% Define input parameters for the initial value problem:
%
%    du/dt = lambda*u  in 0 <= t <= T
%    u = u0            at t = 0
%==========================================================================
lambda = -2.3; u0 = 1; T = 10;
%==========================================================================
% Set time step (try dt = 0.7 (stable) and dt = 1 (unstable))
%==========================================================================
dt = 0.7;
% Plot exact solution 
syms t; ezplot(u0*exp(lambda*t),[0,T]); axis([0,T,-5*u0,5*u0]); hold on
% Step in time
for n = 1:floor(T/dt)
    % Apply the forward Euler method
    u1 = u0 + dt*lambda*u0;
    % Plot the approximation
    plot([(n-1)*dt,n*dt],[u0,u1],'ro-') 
    legend('Exact Solution','Forward Euler approximation')
    pause(1/2)
    drawnow
    % Now set u0 equal to the new time value
    u0 = u1;
end