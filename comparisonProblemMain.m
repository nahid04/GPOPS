

%-------------------------------------------------------------------------%
%----------------- Provide All Bounds for Problem ------------------------%
%-------------------------------------------------------------------------%
t0 = 0;
tf = 10;
x0 = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
xf = [1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
xMax = [50 50 50 50 50 50 50 50 50 50 50 50 50 50 50 50 50 50];
xMin = [-50 -50 -50 -50 -50 -50 -50 -50 -50 -50 -50 -50 -50 -50 -50 -50 -50 -50];
wmMin = -10;
wmMax = +10;

%-------------------------------------------------------------------------%
%----------------------- Setup for Problem Bounds ------------------------%
%-------------------------------------------------------------------------%
bounds.phase.initialtime.lower = t0;
bounds.phase.initialtime.upper = t0;
bounds.phase.finaltime.lower = tf;
bounds.phase.finaltime.upper = tf;
bounds.phase.initialstate.lower = x0; 
bounds.phase.initialstate.upper = x0;
bounds.phase.finalstate.lower = xf; 
bounds.phase.finalstate.upper = xf;
bounds.phase.control.lower = wmMin; 
bounds.phase.control.upper = wmMax;
bounds.phase.state.lower = xMin; 
bounds.phase.state.upper = xMax;
bounds.phase.integral.lower = 0;
bounds.phase.integral.upper = 100000;

%-------------------------------------------------------------------------%
%---------------------- Provide Guess of Solution ------------------------%
%-------------------------------------------------------------------------%
guess.phase.time     = [t0; tf]; 
guess.phase.state    = [x0; xf];
guess.phase.control  = [0; 0];
guess.phase.integral = 0;

%-------------------------------------------------------------------------%
%----------Provide Mesh Refinement Method and Initial Mesh ---------------%
%-------------------------------------------------------------------------%
mesh.method          = 'hp-LiuRao-Legendre';
mesh.tolerance       = 1e-7;
mesh.maxiterations   = 45;
mesh.colpointsmin    = 2;
mesh.colpointsmax    = 14;
mesh.phase.colpoints = 4*ones(1,10);
mesh.phase.fraction  = 0.1*ones(1,10);

%-------------------------------------------------------------------------%
%------------- Assemble Information into Problem Structure ---------------%        
%-------------------------------------------------------------------------%
setup.name                           = 'Comparison-Problem';
setup.functions.continuous           = @comparisonProblemContinuous;
setup.functions.endpoint             = @comparisonProblemEndpoint;
setup.displaylevel                   = 2;
setup.bounds                         = bounds;
setup.guess                          = guess;
setup.mesh                           = mesh;
setup.nlp.solver                     = 'ipopt';
setup.nlp.snoptoptions.tolerance     = 1e-12;
setup.nlp.snoptoptions.maxiterations = 20000;
setup.nlp.ipoptoptions.linear_solver = 'ma57';
setup.nlp.ipoptoptions.tolerance     = 1e-10;
setup.derivatives.supplier           = 'adigator';
setup.derivatives.derivativelevel    = 'second';
setup.method                         = 'RPM-Differentiation';

%-------------------------------------------------------------------------%
%---------------------- Solve Problem Using GPOPS2 -----------------------%
%-------------------------------------------------------------------------%
tic
output = gpops2(setup);
toc
