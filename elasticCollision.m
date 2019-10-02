%% function elasticCollision
function[spheres] = elasticCollision(spheres,A,B,den)
% The function elasticCollision involves itself
% with emulating an elastic collision between
% two bodies in the CV. Newtonian physics equations
% are used as models in the equations below.

%% Error Checks

% spheres - already created within program

% A and B - doesn't matter which val is greater, A and B generated within
% outer function.

% density
if den <= 0
    error('Enter a valid density')
elseif size(den,1) ~= 1 || size(den,2) ~= 1
    error('Enter a valid size for density')
end

%% Main Function

m = 4/3*pi*spheres(:,1).^3 * den; %mass
% each component of velocity
vax = spheres(A,4);
vbx = spheres(B,4);
vay = spheres(A,5);
vby = spheres(B,5);
% each coordinate
xa = spheres(A,2);
ya = spheres(A,3);
xb = spheres(B,2);
yb = spheres(B,3);

% unit normal vector
unx = xb-xa;
uny = yb-ya;
un = [unx uny] ./ sqrt(unx^2 + uny^2);
% unit tangent vector
ut = [-un(2) un(1)];

% magnitude of normal/tangential directions: use dot product w/ unit
van = vax*un(1) + vay*un(2);
vat = vax*ut(1) + vay*ut(2);
vbn = vbx*un(1) + vby*un(2);
vbt = vbx*ut(1) + vby*ut(2);

% new magnitudes of A_normal and B_normal (tangential stays the same)
van_n = (van*(m(A)-m(B))+2*m(B)*vbn)/(m(A)+m(B));
vbn_n = (vbn*(m(B)-m(A))+2*m(A)*van)/(m(A)+m(B));

% new velocities, in normal/tangential coordinates, converted back to
% 1 x 2 vectors of x and y coordinates
newvela = un*van_n;
newvelb = un*vbn_n;
newvelat = ut*vat;
newvelbt = ut*vbt;

% new velocities in x and y coordinates (converted from n-t)
NEW_VELOCITY_AX = newvela(1) + newvelat(1);
NEW_VELOCITY_BX = newvelb(1) + newvelbt(1);
NEW_VELOCITY_AY = newvela(2) + newvelat(2);
NEW_VELOCITY_BY = newvelb(2) + newvelbt(2);

% replacing values in spheres
spheres(A,4:5) = [NEW_VELOCITY_AX NEW_VELOCITY_AY];
spheres(B,4:5) = [NEW_VELOCITY_BX NEW_VELOCITY_BY];

end