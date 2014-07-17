%---------------------------------%
% BEGIN: gaitEndpoint.m %
%---------------------------------%
function output = gaitEndpoint(input)

xi = input.phase.initialstate;
xf = input.phase.finalstate;
q  = input.phase.integral; 

% boundary conditions for difference between final and initial state

output.eventgroup.event = xf - xi;
output.objective = q; 
