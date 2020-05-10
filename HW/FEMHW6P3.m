%==========================================================================
% Define input parameters for the initial value problem:
%
%    du/dt = lambda*u  in 0 <= t <= T
%    u = u0            at t = 0
%==========================================================================
[L,pt] = Globalad();
lambda = L; u0 = exact_HW6_Problem_3(pt,0); T = 5;
%==========================================================================
% Set time step (try dt = 0.7 (stable) and dt = 1 (unstable))
%==========================================================================
dt = 0.1;
% Plot exact solution 
U = exact_HW6_Problem_3(pt,T); hold on
plot(pt,U)
% Step in time
for n = 1:floor(T/dt)
    % Apply the forward Euler method
    u1 = u0 + dt*lambda*u0;
    % Now set u0 equal to the new time value
    u0 = u1;
end
plot(pt,u0)
legend("exact","approximate")
error = (max(U)-max(u0)/max(U))*100