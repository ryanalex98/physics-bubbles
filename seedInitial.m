%% function seedInitial
function [spheres] = seedInitial(ns,vs,rs,BC)
% The function seedInitial involves itself with
% a creation of an ns x 5 array of spheres, 
% with their velocity, coordinate, and radius.

%% Error Checks

% ns
if ~(ns>0)
    error('Enter a positive number of spheres')
end
% radius
if (size(rs,1) ~= 10 && size(rs,1) ~= 1) || size(rs,2) ~= 1
    error('Enter valid radius information')
elseif max(rs) > (BC(4) - BC(3))/2 || max(rs) > (BC(2) - BC(1))/2
    error('Radius exceeds boundary dimensions')
end
% velocity
if (size(vs,1) ~= 10 && size(vs,1) ~= 1) || size(vs,2) ~= 1
    error('Enter valid velocity information')
end
% boundary conditions
if BC(2)-BC(1) <= 0 || BC(4) - BC(3) <= 0
    error('Enter valid boundary maxima and minima')
elseif size(BC,1) ~= 1 || size(BC,2) ~= 4
    error('Enter valid dimensions for BC array')
end


%% Main Function
spheres = zeros(ns, 5);

% RADIUS
if length(rs) == ns % radius array must have the same length as ns
    spheres(:,1) = rs;
else                % single value case
    for i=1:ns
        spheres(i,1) = rs;
    end
end

% COORDINATES
% x -- length, y -- width
rad = spheres(:,1); % declares a temporary radius array
oldCoord = zeros(ns,2);
for i = 1:ns
    willFit = 0;
    % first set of coordinates created
    newCoord(1) = rand*(BC(2) - BC(1) - 2*rad(i)) + BC(1) + rad(i);
    newCoord(2) = rand*(BC(4) - BC(3) - 2*rad(i)) + BC(3) + rad(i);
    while willFit == 0 && i > 1
        % generates new x and y coordinates for every instance of while
        newCoord(1) = rand*(BC(2) - BC(1) - 2*rad(i)) + BC(1) + rad(i);
        newCoord(2) = rand*(BC(4) - BC(3) - 2*rad(i)) + BC(3) + rad(i);
        willFit = 1;
        for j=1:i-1 %iterates through previous coordinates
            xdist = oldCoord(j,1) - newCoord(1); % x val for dist formula
            ydist = oldCoord(j,2) - newCoord(2); % y val for dist formula
            dist = sqrt(xdist^2 + ydist^2); % distance formula
            if dist < (rad(j) + rad(i)) % ensures no 2 are the same
                willFit = 0;
            end
        end
    end
    oldCoord(i,1) = newCoord(1); % stores the x coord
    oldCoord(i,2) = newCoord(2); % stores the y coord
end
spheres(:,2:3) = oldCoord;

% VELOCITY
mag_vel = ones(1,ns); % array for magnitude of velocities
if length(vs) == ns % radius array must have the same length as ns
    mag_vel = vs;
else                % single value case
    mag_vel = mag_vel*vs;
end

for i=1:ns
    r = rand*2*pi; % generates a random point between zero and 2pi
    spheres(i,4:5) = [cos(r) sin(r)]*mag_vel(i); % converts to cartesian
end

end