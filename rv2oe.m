function oe = rv2oe (r, v,mu)

% convert eci state vector to six classical orbital
% elements via equinoctial elements

% input

%  mu = central body gravitational constant (km**3/sec**2)
%  r  = eci position vector (kilometers)
%  v  = eci velocity vector (kilometers/second)

% output

%  oev(1) = semimajor axis (kilometers)
%  oev(2) = orbital eccentricity (non-dimensional)
%           (0 <= eccentricity < 1)
%  oev(3) = orbital inclination (radians)
%           (0 <= inclination <= pi)
%  oev(4) = argument of perigee (radians)
%           (0 <= argument of perigee <= 2 pi)
%  oev(5) = right ascension of ascending node (radians)
%           (0 <= raan <= 2 pi)
%  oev(6) = true anomaly (radians)
%           (0 <= true anomaly <= 2 pi)

% Orbital Mechanics with MATLAB
oe=zeros(1,6);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pi2 = 2.0 * pi;

% position and velocity magnitude

rmag = norm(r);

vmag = norm(v);

% position unit vector

rhat = r / rmag;

% angular momentum vectors

hv = cross(r, v);

hhat = hv / norm(hv);

% eccentricity vector

vtmp = v / mu;

ecc = cross(vtmp, hv);

ecc = ecc - rhat;

% semimajor axis

sma = 1.0 / (2.0 / rmag - vmag * vmag / mu);

p = hhat(1) / (1.0 + hhat(3));

q = -hhat(2) / (1.0 + hhat(3));

const1 = 1.0 / (1.0 + p * p + q * q);

fhat=zeros(3,1);
ghat=zeros(3,1);

fhat(1) = const1 * (1.0 - p * p + q * q);
fhat(2) = const1 * 2.0 * p * q;
fhat(3) = -const1 * 2.0 * p;

ghat(1) = const1 * 2.0 * p * q;
ghat(2) = const1 * (1.0 + p * p - q * q);
ghat(3) = const1 * 2.0 * q;

h = dot(ecc, ghat);

xk = dot(ecc, fhat);

x1 = dot(r, fhat);

y1 = dot(r, ghat);

% orbital eccentricity

eccm = sqrt(h * h + xk * xk);

% orbital inclination

inc = 2.0 * atan(sqrt(p * p + q * q));

% true longitude

xlambdat = atan3(y1, x1);

% check for equatorial orbit

if (inc > 0.00000001)
    raan = atan3(p, q);
else
    raan = 0.0;
end

% check for circular orbit

if (eccm > 0.00000001)
    argper = mod(atan3(h, xk) - raan, pi2);
else
    argper = 0.0;
end

% true anomaly

tanom = mod(xlambdat - raan - argper, pi2);

% load orbital element vector

oe(1) = sma;
oe(2) = eccm;
oe(3) = inc;
oe(4) = argper;
oe(5) = raan;
oe(6) = tanom;

end
