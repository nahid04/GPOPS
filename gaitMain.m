%-------------------------- Gait Problem ----------------------------%
%--------------------------------------------------------------------%
clear all
clc

% Parameters:
%-------------------------------------------------------------------%
%-------------------- Data Required by Problem ---------------------%
%-------------------------------------------------------------------%
% Some model related constants
	ndof     = 9;
	nstates  = 2*ndof;
	joints   = {'Hip' 'Knee' 'Ankle' 'LHip' 'LKnee' 'LAnkle'};
	njoints  = size(joints,2);
	
	dofnames = {'trunk x','trunk y','trunk angle', ...
			'Rhip angle','Rknee angle','Rankle angle', ...
			'Lhip angle','Lknee angle','Lankle angle'};
        
N  = 18;        % number of state variables in model
Nu = 9;         % number of controls
Nt = 10;        % number of time points in initial guess

%-------------------------------------------------------------------%
%----------------------------- Bounds ------------------------------%
%-------------------------------------------------------------------%
t0  = 0;
tf  = 1;

xMin = [ ...
0        0.5     -pi/4   -pi/2   -pi     -pi/2    -pi/2   -pi     -pi/2 ...
-0.1    -0.5     -20     -20     -20     -20      -20     -20     -20 ...
];       %minimum of coordinates
xMax = ...
[5     2       pi/4        pi/2    0   pi/2    pi/2    0   pi/2 ...
 2     0.5     20          20      20  20      20      20  20 ...
    ];       %maximum of coordinates


uMin = [0 0 0 -200 -200 -200 -200 -200 -200];        %minimum of torques
uMax = [0 0 0  200  200  200  200  200  200];        %maximum of torques

bounds.phase.initialtime.lower  = t0;
bounds.phase.initialtime.upper  = t0;
bounds.phase.finaltime.lower    = tf; 
bounds.phase.finaltime.upper    = tf;
bounds.phase.initialstate.lower = xMin;
bounds.phase.initialstate.upper = xMax;
bounds.phase.state.lower        = xMin;
bounds.phase.state.upper        = xMax;
bounds.phase.finalstate.lower   = xMin;
bounds.phase.finalstate.upper   = xMax;
bounds.phase.control.lower      = uMin; 
bounds.phase.control.upper      = uMax; 
bounds.phase.integral.lower     = 0;
bounds.phase.integral.upper     = 200;

% for standing the final state should be the same as initial state
% for walking state, the final state should be bigger than initial state
% xf = x0 + c  & c = [v*T, 0, 0, ..., 0]
% for every case, the above condition should be substituted into eventgroup 

bounds.eventgroup.lower = zeros(1, nstates);
bounds.eventgroup.upper = zeros(1, nstates);
guess.phase.time        = t0 + (0:Nt-1).'*(tf-t0)/(Nt-1);
rng('shuffle');

% for i = 1:Nt
%     guess.phase.state(i,:)   = xMin + (xMax - xMin) .* rand(1, N);
%     guess.phase.control(i,:) = uMin + (uMax - uMin) .* rand(1, Nu);
% end
for i = 1:Nt
    guess.phase.state(i,:)    = zeros(1, 18); 
    guess.phase.state(:,2)    = 1.2;
    guess.phase.control(i, :) = zeros(1, 9);
end
guess.phase.integral         = 0;

%-------------------------------------------------------------------%
%--------------------------- Problem Setup -------------------------%
%-------------------------------------------------------------------%
setup.name                        = 'gait-Problem';
setup.functions.continuous        = @gaitContinuous;
setup.functions.endpoint          = @gaitEndpoint;
setup.bounds                      = bounds;
setup.functions.report            = @report;
setup.guess                       = guess;
setup.nlp.solver                  = 'ipopt';
setup.derivatives.supplier        = 'sparseCD';
setup.derivatives.derivativelevel = 'first';
setup.scales.method               = 'none';
setup.derivatives.dependencies    = 'full';
setup.mesh.method                 = 'hp-PattersonRao';
setup.mesh.tolerance              = 1e-4;
setup.method                      = 'RPM-Integration';

%-------------------------------------------------------------------%
%------------------- Solve Problem Using GPOPS2 --------------------%
%-------------------------------------------------------------------%
output = gpops2(setup);
output.result.nlptime
solution = output.result.solution;

%-------------------------------------------------------------------%
%--------------------------- Plot Solution -------------------------%
%-------------------------------------------------------------------%

close all
	figure(1);
	set(gcf,'Position',[5 5 815 960]);

	% Loading the Result structure form the mat-file specified
    x = solution.phase.state;
    u = solution.phase.control;
    t = solution.phase.time;
    
	% Computing ground reaction forces
    [~, GRF] = gait2dem(x',u');

	% plot the horizontal ground reaction force Fx, right and left
	subplot(3,3,1);
	plot(t, GRF([1 4],:));
	legend('Right','Left');
	xlabel('time (s)');
	ylabel('force (N)');
	title('Horizontal GRF');


	% plot the hip angles, right and left
	subplot(3,3,2);
	plot(t, x(:,[4 7])*180/pi);
	xlabel('time (s)');
	ylabel('angle (deg)');
	title('Hip Angle');

    
	% plot the hip torques, right and left
	subplot(3,3,3);
	plot(t, u(:,[4 7]));
	xlabel('time (s)');
	ylabel('torque (N.m)');
	title('Hip Torque');

    
    % plot the vertical ground reaction force Fy, right and left
	subplot(3,3,4);
	plot(t, GRF([2 4],:));
	legend('Right','Left');
	xlabel('time (s)');
	ylabel('force (N)');
	title('Vertical GRF');
    
    
    % plot the knee angles, right and left
	subplot(3,3,5);
	plot(t, x(:,[5 8])*180/pi);
	xlabel('time (s)');
	ylabel('angle (deg)');
	title('Knee Angle');

    
    % plot the knee torques, right and left
	subplot(3,3,6);
	plot(t, u(:,[5 8]));
	xlabel('time (s)');
	ylabel('torque (N.m)');
	title('Knee Torque');
    
    
    % plot the ankle angles, right and left
	subplot(3,3,8);
	plot(t, x(:,[6 9])*180/pi);
	xlabel('time (s)');
	ylabel('angle (deg)');
	title('Ankle Angle');

    
    % plot the ankle torques, right and left
	subplot(3,3,9);
	plot(t, u(:,[6 9]));
	xlabel('time (s)');
	ylabel('torque (N.m)');
	title('Ankle Torque');
