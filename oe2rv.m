function [r, v] = oe2rv(oe,mu)

% convert classical orbital elements to eci state vector

% input

%  mu     = gravitational constant (km**3/sec**2)
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

% output

%  r = eci position vector (kilometers)
%  v = eci velocity vector (kilometers/second)

% Orbital Mechanics with MATLAB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

r = zeros(3, 1);
v = zeros(3, 1);

% unload orbital elements array
   
sma = oe(1);
ecc = oe(2);
inc = oe(3);
argper = oe(4);
raan = oe(5);
tanom = oe(6);

slr = sma * (1 - ecc * ecc);

rm = slr / (1 + ecc * cos(tanom));
   
arglat = argper + tanom;

sarglat = sin(arglat);
carglat = cos(arglat);
   
c4 = sqrt(mu / slr);
c5 = ecc * cos(argper) + carglat;
c6 = ecc * sin(argper) + sarglat;

sinc = sin(inc);
cinc = cos(inc);

sraan = sin(raan);
craan = cos(raan);

% position vector

r(1) = rm * (craan * carglat - sraan * cinc * sarglat);
r(2) = rm * (sraan * carglat + cinc * sarglat * craan);
r(3) = rm * sinc * sarglat;

% velocity vector

v(1) = -c4 * (craan * c6 + sraan * cinc * c5);
v(2) = -c4 * (sraan * c6 - craan * cinc * c5);
v(3) = c4 * c5 * sinc;

end

