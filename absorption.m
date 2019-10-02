%% function absorption
function[spheres] = absorption(spheres,LOW,HIGH,den,BC)
% The function absorption involves itself with
% inelastic collisions and two spheres colliding
% with each other to form a larger sphere. The 
% spheres array, the boundary conditions, density
% and the indices of the two combining spheres
% will be considered, and the output will be an 
% updated spheres array.

%% Error Checks
% spheres - already created within program

% HIGH and LOW generated within program
% ensures 'HIGH' is greater than 'LOW'
if ~(HIGH > LOW)
    error('Ensure the higher value is greater than the lower')
end

% density
if den <= 0
    error('Enter a valid density')
elseif size(den,1) ~= 1 || size(den,2) ~= 1
    error('Enter a valid size for density')
end
% boundary conditions
if BC(2)-BC(1) <= 0 || BC(4) - BC(3) <= 0
    error('Enter valid boundary maxima and minima')
elseif size(BC,1) ~= 1 || size(BC,2) ~= 4
    error('Enter valid dimensions for BC array')
end

%% Main Function
mass = 4/3*pi*spheres(:,1).^3 * den;    % masss of each sphere
velx = spheres(:,4);    % x velocity
vely = spheres(:,5);    % y velocity
x = spheres(:,2);       % x coordinates
y = spheres(:,3);       % y coordinates

% Conservation of volume
new_rad = (spheres(HIGH,1)^3 + spheres(LOW,1)^3)^(1/3);

% Conservation of momentum
new_velx = (mass(HIGH)*velx(HIGH) + mass(LOW)*velx(LOW))/...
    (mass(HIGH) + mass(LOW));
new_vely = (mass(HIGH)*vely(HIGH) + mass(LOW)*vely(LOW))/...
    (mass(HIGH) + mass(LOW));

% Weighted avg of new coords
xdist = x(HIGH) - x(LOW);
ydist = y(HIGH) - y(LOW);
% center of mass formula used to calculate new coordinates
newx = x(LOW) + xdist * mass(HIGH)/(mass(LOW) + mass(HIGH));
newy = y(LOW) + ydist * mass(HIGH)/(mass(LOW) + mass(HIGH));

% case if two spheres are up against wall
if newx + new_rad > BC(2)
    newx = BC(2) - new_rad;
elseif newx - new_rad < BC(1)
    newx = BC(1) + new_rad;
elseif newy + new_rad > BC(4)
    newy = BC(4) - new_rad;
elseif newy - new_rad < BC(3)
    newy = BC(3) + new_rad;
end

% generates new combined sphere
spheres(LOW,:) = [new_rad newx newy new_velx new_vely];

% eliminates extra sphere
spheres(HIGH,:) = [];

% NEED TO ACCCOUNT FOR PARALLEL TO WALL CASE

end