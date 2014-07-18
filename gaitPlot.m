function gaitPlot (solution)

   
	% make graphs from an optimization result
	% example:
	% report('solution.mat')
    % keyboard
    

	% initialize figure window
    % close all
	figure(1);
	set(gcf,'Position',[5 5 815 960]);

	% Loading the Result structure form the mat-file specified
         
    x = solution.phase.state;
    u = solution.phase.control;
    t = solution.phase.time;
    
	% Computing ground reaction forces
%     xx=guess.phase.state;
%     uu=guess.phase.control;
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


end