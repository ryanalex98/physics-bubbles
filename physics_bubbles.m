% =============================
% Final Project
% Ryan Alexander
% 404 906 898
% Collisions
% =============================
% This code will simulate both elastic and stochastic inelastic collisions
% for several spheres in a given control volume. Common laws of physics
% will be observed and the movement of the spheres will be portrayed in a
% video.
% =============================

% clears Cache
clc
close all
clear all

% shuffles the seed
rng('shuffle')

% Video file
vidfile = VideoWriter('ExpMovie.mp4','MPEG-4');
vidfile.FrameRate = 60;
open(vidfile);

%% Switch function for variable declaration
trial = input('Enter a trial number (1 through 4): ');

% ensure trial is correct
if (trial > 4 || trial < 1) || mod(trial,1) ~= 0
    error('Try again with the trial value')
end

% arrays for Trial 3
vel = [0; 1; 0.5; 0.5; 0.25; 0.25; 0.3; 0.3; 0.3; 0];
rad = [1; 1.25; 1.5; 1.75; 2; 1; 1.15; 1.35; 1.65; 1.85];

switch trial
    case 1
        ns = 10;        % number of spheres
        vs = 0.5;       % velocity
        rs = 0.5;       % radius
        x_min = 0;      % min x value
        x_max = 10;     % max x value
        y_min = 0;      % min y value
        y_max = 10;     % max y value
        BC = [x_min x_max y_min y_max]; % combining to form boundaries
        den = 0.05;     % density
        abs = 0.1;      % absorption ratio
    case 2
        ns = 10;        % number of spheres
        vs = 1;         % velocity
        rs = 1;         % radius
        x_min = 0;      % min x value
        x_max = 10;     % max x value
        y_min = 0;      % min y value
        y_max = 10;     % max y value
        BC = [x_min x_max y_min y_max]; % combining to form boundaries
        den = 0.05;     % density
        abs = 0.1;      % absorption ratio
    case 3
        ns = 10;        % number of spheres
        vs = vel;       % velocity
        rs = rad;       % radius
        x_min = 0;      % min x value
        x_max = 25;     % max x value
        y_min = 0;      % min y value
        y_max = 25;     % max y value
        BC = [x_min x_max y_min y_max]; % combining to form boundaries
        den = 0.05;     % density
        abs = 0.1;      % absorption ratio
    case 4
        ns = 100;       % number of spheres
        vs = 0.35;      % velocity
        rs = 0.50;      % radius
        x_min = 0;      % min x value
        x_max = 25;     % max x value
        y_min = 0;      % min y value
        y_max = 25;     % max y value
        BC = [x_min x_max y_min y_max]; % combining to form boundaries
        den = 0.05;     % density
        abs = 0.25;      % absorption ratio   
end

% Declaring time information
t0 = 0;         % intial time
tf = 100;       % final time
dt = 0.1;       % timestep

%% Error Checks

% Time
if dt > tf - t0
    error('Choose a smaller dt value')
elseif ~(tf > t0)
    error('The final time must be greater than the initial time')
elseif ~(dt > 0)
    error('Choose a positive dt value')
end

%% Main function

% intializing spheres
spheres = seedInitial(ns,vs,rs,BC);

% sets the figure
figure(1)

% main for loop, iterates through timestep increments
for t = t0:dt:tf
    % declares x and y limits on plot
    xlim([BC(1),BC(2)]); 
    ylim([BC(3),BC(4)]);
    cla reset % clears current plot
    spheres = fieldEvolution(spheres,dt,abs,den,BC);
    
    ns = length(spheres(:,1)); % keep redefining ns
    for i = 1:ns % plot each sphere
        pos = [spheres(i,2)-spheres(i,1) spheres(i,3)-spheres(i,1)...
            2*spheres(i,1) 2*spheres(i,1)]; % sets positions according
            % to 'rectangle'
        cur = [1 1]; % sets curvature according to 'rectangle'
        rectangle('Position', pos, 'Curvature', cur,'FaceColor','b')
        axis(BC) % sets the axes
        axis square % makes the plot a square
    end
    drawnow % draws the spheres
    set(gcf,'Position',[30 350 850 450])
    set(gca,'LineWidth',3,'FontSize',20) % aesthetic appeal
    mult = round(t/dt); % rounds to a whole number (for array storing)
    Fr(mult+1) = getframe(gcf);
    writeVideo(vidfile,Fr(mult+1));
end
close(vidfile)