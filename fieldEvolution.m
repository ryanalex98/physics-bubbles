%% function fieldEvolution
function [spheres] = fieldEvolution(spheres,dt,abs,den,BC)
% The function fieldEvloution involves itself
% with tracking the motion through each iterative
% time step of all objects inside the CV. Also 
% keeps track of collisions. The function calls
% on two other functions, elasticCollision and
% absorption. These help simulate the collisions
% and are further discussed in their own respective
% descriptions.

%% Error Checks

% spheres - already created within program

% dt - size check // positive check
if size(dt,1) ~= 1 || size(dt,2) ~= 1
    error('Enter a valid size for density')
elseif ~(dt > 0)
    error('Choose a positive dt value')
end

% absorption percentage
if abs < 0 || abs > 1
    error('Enter a valid absorption percentage')
elseif size(abs,1) ~= 1 || size(abs,2) ~= 1
    error('Enter a valid size for absorption percentage')
end
% density
if den <= 0
    error('Enter a valid density')
elseif size(den,1) ~= 1 || size(den,2) ~= 1
    error('Enter a valid size for density')
end


%% Main Function

rad = spheres(:,1);
vel = spheres(:,4:5);
xy = spheres(:,2:3);
N = length(spheres(:,1));

% advance the particles to a new position
for i=1:N
    % updating x coordinate
    xy(i,1) = xy(i,1) + dt*vel(i,1);
    % updating y coordinate
    xy(i,2) = xy(i,2) + dt*vel(i,2);
end

collision = 0; % dummy variable to find a collision
for i=1:N % index of testing coordinate
    % wall tests (x_max and x_min, respectively)
    if xy(i,1)+rad(i) > BC(2) || xy(i,1)-rad(i) < BC(1)
        collision = 1; % a collision occurs
    % wall tests (y_max and y_min, respectively)
    elseif xy(i,2)+rad(i) > BC(4) || xy(i,2)-rad(i) < BC(3)
        collision = 1;
    end
    for j=i:N % index of comparison coordinate
        if i ~= j % ensures same coord wont test against itself
            xdist = (xy(i,1) - xy(j,1))^2;
            ydist = (xy(i,2) - xy(j,2))^2;
            dist = sqrt(xdist + ydist); % dist formula broken up
            if dist < rad(i) + rad(j)
                collision = 1; % a collision occurs
            end
        end
    end
end    

% If a collision has been found
if collision == 1
    % need to find timestep that collision occurs at
    small_dt = dt/100; % defines the smaller timestep
    for t=small_dt:small_dt:dt
        % defines dummy intermediate arrays
        xy_small = spheres(:,2:3);
        vel_small = spheres(:,4:5);
        rad_small = spheres(:,1);
        xy_before = xy_small;
        
        for i=1:N
            % updating x coordinate
            xy_small(i,1) = xy_small(i,1) + small_dt*vel_small(i,1);
            % updating y coordinate
            xy_small(i,2) = xy_small(i,2) + small_dt*vel_small(i,2);
        end
        
        i = 1; % essentially a while loop but N can change
        while i <= N % search for collisions
            % WALL COLLISIONS
            % upper x boundary || lower x boundary
            if xy_small(i,1)+rad_small(i) > BC(2) || ...
                    xy_small(i,1)-rad_small(i) < BC(1)
                % inverts x component of velocity
                spheres(i,4) = -vel_small(i,1);
                spheres(i,2:3) = xy_before(i,:);
            % upper y boundary || lower y boundary
            elseif xy_small(i,2)+rad_small(i) > BC(4) || ...
                    xy_small(i,2)-rad_small(i) < BC(3)
                % inverts y component of velocity
                spheres(i,5) = -vel_small(i,2);
                spheres(i,2:3) = xy_before(i,:);
            end
            
            % SPHERE COLLISIONS
            j = i; % while loop with dynamic N
            while j <= N % j represents index of comparison coordinate
                if i ~= j % ensures same coord wont test against itself
                    xdist = (xy_small(i,1) - xy_small(j,1))^2;
                    ydist = (xy_small(i,2) - xy_small(j,2))^2;
                    dist = sqrt(xdist + ydist); % dist formula broken up
                    if dist < rad_small(i) + rad_small(j) % a collision
                        if rand < abs % absorption case
                            spheres(i,2:3) = xy_before(i,:); %resets coords
                            spheres = absorption(spheres,i,j,den,BC);
                            N = length(spheres(:,1));
                            xy_small = spheres(:,2:3); % gives new coords
                        else % elastic collision case
                            spheres(i,2:3) = xy_before(i,:); %resets coords
                            spheres = elasticCollision(spheres,i,j,den);
                        end
                    end
                end
                j = j+1; % advances j (comparison) counter
            end
            i = i+1; % advances i (current sphere) counter
        end
        spheres(:,2:3) = xy_small; % replacing spheres with revised coords
    end
else % NO COLLISIONS
    spheres(:,2:3) = xy; % updated coordinates
end

end