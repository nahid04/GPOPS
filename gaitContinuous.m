function phaseout = gaitContinuous(input)

x = input.phase.state;
u = input.phase.control;
% keyboard
% 
% Nnodes = size(x,1);
xdot = gait2dem(x', u')';

%acceleration = -k*pos -b*vel + u;

% k = 500;
% b = 100;
% 
% xdot = zeros(Nnodes,18);
% xdot(:, 1:9)   = x(:,10:18);
% xdot(:, 10:18) = u - k*x(:,1:9) - b*x(:,10:18);

phaseout.dynamics  = xdot;
phaseout.integrand = sum(u'.^2)';
