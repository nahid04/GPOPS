function gaitAnim(solution)

    % 	NOT TESTED!!

	% make a movie from an optimization result
	% example:
	%	>> anim('solution.mat', 20);		% make a movie with 20 frames
	
% 	load(file);
	nfr = 10;
	t0  = min(solution.phase.time);
	tf  = max(solution.phase.time);
	sampletimes = linspace(t0, tf, nfr);		
	x = interp1(solution.phase.time, solution.phase.state, sampletimes);
		
	% initialize movie file
	avi = VideoWriter('anim.avi');
	open(avi);

	% initialize figure window
	close all
	figure(1);
	
	% make the movie
	R = [1:6 4];			% stick figure points for right leg (see gait2dem.m)
	L = [2 7:10 8];			% stick figure points for left leg and trunk
	u = zeros(9,1);			% control does not matter
	for i=1:nfr
		hold on
		[~, ~, d] = gait2dem(x(i,:)',u);                            % get stick figure coordinates for state x (see gait2dem.m)
		d = reshape(d',2,10)';
		plot(d(R,1),d(R,2),'r',d(L,1),d(L,2),'b','LineWidth',2);	% draw right leg in red, left in blue
		plot([-1 1],[0 0],'k')                                      % draw the ground in black
		axis('equal');
		axis('off');
		if (i==1)
			F = getframe(gca);
			frame = [1 1 size(F.cdata,2) size(F.cdata,1)];
		else
			F = getframe(gca,frame);
		end
		writeVideo(avi,F);
		cla;
	end

	close(avi);
	hold off;
	close all
end