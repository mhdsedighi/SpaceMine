function [solution,times,ocp] = sampleOCL

clc
clear
close all

% saved_ig=load('ig.mat');



MAX_TIME = 100000;

ocp = ocl.Problem([], @varsfun, @daefun, ...
    'gridcosts', @gridcosts,...
    'N', 30);

%   ocp = ocl.Problem([], @varsfun, @daefun, ...
%     'gridcosts', @gridcosts, ...
%     'gridconstraints', @gridconstraints, ...
%     'N', 50);


mu=3.986005*10^5;
Re=6378.14;

orbit1.a=15*Re;
orbit1.e=0.5;
orbit1.incl=deg2rad(20);
orbit1.RA=deg2rad(2);
orbit1.omega=deg2rad(20);
orbit1.MA=deg2rad(10);


orbit2.a=17*Re;
orbit2.e=0.5;
orbit2.incl=deg2rad(10);
orbit2.RA=deg2rad(20);
orbit2.omega=deg2rad(20);
orbit2.MA=deg2rad(20);

ocp.setParameter('mu', mu);
ocp.setParameter('Re', Re);

ocp.setBounds('time', 0, MAX_TIME);

% ocp.setInitialBounds( 'x',   saved_ig.X_trajectory(1,1));
% ocp.setInitialBounds( 'y',   saved_ig.X_trajectory(2,1));
% ocp.setInitialBounds( 'z',   saved_ig.X_trajectory(3,1));
% ocp.setInitialBounds( 'xdot',   saved_ig.X_trajectory(4,1));
% ocp.setInitialBounds( 'ydot',   saved_ig.X_trajectory(5,1));
% ocp.setInitialBounds( 'zdot',   saved_ig.X_trajectory(6,1));
% 
% ocp.setEndBounds( 'x',   saved_ig.X_trajectory(1,end));
% ocp.setEndBounds( 'y',   saved_ig.X_trajectory(2,end));
% ocp.setEndBounds( 'z',   saved_ig.X_trajectory(3,end));
% ocp.setEndBounds( 'xdot',   saved_ig.X_trajectory(4,end));
% ocp.setEndBounds( 'ydot',   saved_ig.X_trajectory(5,end));
% ocp.setEndBounds( 'zdot',   saved_ig.X_trajectory(6,end));


ocp.setInitialBounds( 'a',orbit1.a);
ocp.setInitialBounds( 'e',orbit1.e);
ocp.setInitialBounds( 'incl',orbit1.incl);
ocp.setInitialBounds( 'RA',orbit1.RA);
ocp.setInitialBounds( 'omega',orbit1.omega);
ocp.setInitialBounds( 'MA',orbit1.MA);



ocp.setEndBounds( 'a',orbit2.a);
ocp.setEndBounds( 'e',orbit2.e);
% ocp.setEndBounds( 'incl',orbit2.incl);
% ocp.setEndBounds( 'RA',orbit2.RA);
% ocp.setEndBounds( 'omega',orbit2.omega);
% ocp.setEndBounds( 'MA',orbit2.MA);

% initialGuess    = ocp.getInitialGuess();
% N_i=length(initialGuess.states.x.value)
% N_c=length(initialGuess.controls.dFr.value)

% initialGuess.states.x.set(-initialGuess.states.x.value*2);
% initialGuess.states.y.set(-initialGuess.states.x.value*2);
% initialGuess.states.time
% initialGuess.states.x.value
% cvec=initialGuess.controls.dFs.value;
% cvec(1)=-1;
% cvec(end-1)=1;
% initialGuess.controls.dFw.set(cvec);

% initialGuess.states.x.set(saved_ig.X_trajectory(1,:));
% initialGuess.states.y.set(saved_ig.X_trajectory(2,:));
% initialGuess.states.z.set(saved_ig.X_trajectory(3,:));
% initialGuess.states.xdot.set(saved_ig.X_trajectory(4,:));
% initialGuess.states.ydot.set(saved_ig.X_trajectory(5,:));
% initialGuess.states.zdot.set(saved_ig.X_trajectory(6,:));
% 
% cvec=initialGuess.controls.dFr.value;
% cvec(1)=saved_ig.impulse1(1);
% cvec(end-1)=saved_ig.impulse2(1);
% initialGuess.controls.dFr.set(cvec);
% 
% cvec=initialGuess.controls.dFs.value;
% cvec(1)=saved_ig.impulse1(2);
% cvec(end-1)=saved_ig.impulse2(2);
% initialGuess.controls.dFs.set(cvec);
% 
% cvec=initialGuess.controls.dFw.value;
% cvec(1)=saved_ig.impulse1(3);
% cvec(end-1)=saved_ig.impulse2(3);
% initialGuess.controls.dFw.set(cvec);



%
%
%   initialGuess.states.x.set( [63781.4000000000,63649.0866925162,63507.3111579282,63356.1326308643,63195.6117380831,63025.8104837438,62846.7922344723,62658.6217042281,62461.3649389740,62255.0893011522,62039.8634539699,61815.7573454974,61582.8421925821,61341.1904645811,61090.8758669175,60831.9733244606,60564.5589647365,60288.7101009700,60004.5052149629,59712.0239398111,59411.3470424639,59102.5564061295,58785.7350125303,58460.9669240098,58128.3372654970,57787.9322063303,57439.8389419445,57084.1456754249,56720.9415989321,56350.3168750001,55972.3626177133,55587.1708737636,55194.8346033930,54795.4476612244,54389.1047769850,53975.9015361252,53555.9343603369,53129.3004879757,52696.0979543890,52256.4255721554,51810.3829112386,51358.0702790584,50899.5887004844,50435.0398977550,49964.5262703253,49488.1508746480,49006.0174038921,48518.2301676006,48024.8940712933,47526.1145960180,47021.9977778525]);
%   initialGuess.states.y.set([0,777.658982239087,1552.08525351513,2323.16392024137,3090.78105358399,3854.82370629364,4615.17992932101,5371.73878821418,6124.39037929505,6873.02584561279,7617.53739267185,8357.81830393221,9093.76295607979,9825.26683406470,10552.2265459054,11274.5398372561,11992.1056057367,12704.8239150211,13412.5960086843,14115.3243238048,14812.9125043206,15505.2654141382,16192.2891499907,16873.8910540458,17549.9797262597,18220.4650364768,18885.2581362731,19544.2714705420,20197.4187888203,20844.6151563537,21485.7769649009,22120.8219432731,22749.6691676099,23372.2390713885,23988.4534551660,24598.2354960538,25201.5097569225,25798.2021953357,26388.2401722137,26971.5524602238,27548.0692518983,28117.7221674775,28680.4442624791,29236.1700349909,29784.8354326878,30326.3778595722,30860.7361824365,31387.8507370478,31907.6633340541,32420.1172646116,32925.1573057326]);
%   initialGuess.states.y.value
% initialGuess.controls.dFs.set(0);
% initialGuess.controls.dFr.set(0);
% initialGuess.controls.dFw.set(0);
%

% Solve OCP
[solution,times] = ocp.solve;





N=length(solution.states.e.value);
a_ar=solution.states.a.value;
e_ar=solution.states.e.value;
incl_ar=solution.states.incl.value;
RA_ar=solution.states.RA.value;
omega_ar=solution.states.omega.value;
MA_ar=solution.states.MA.value;


theta_ar=zeros(1,N);
for i=1:N
   theta_ar(i)=MA2theta(MA_ar(i),e_ar(i));
end

R=zeros(3,N);
V=zeros(3,N);
for i=1:N
   [R(:,i), V(:,i)] = rv_from_oe(a_ar(i),e_ar(i),RA_ar(i),incl_ar(i),omega_ar(i),theta_ar(i),mu);
end


figure
subplot(6,1,1)
grid minor
plot(times.states.value,solution.states.a.value/Re)
ylabel('a')

subplot(6,1,2)
grid minor
plot(times.states.value,solution.states.e.value)
ylabel('e')

subplot(6,1,3)
grid minor
plot(times.states.value,solution.states.incl.value)
ylabel('i')

subplot(6,1,4)
grid minor
plot(times.states.value,solution.states.RA.value)
ylabel('\Omega')

subplot(6,1,5)
grid minor
plot(times.states.value,solution.states.omega.value)
ylabel('\omega')

subplot(6,1,6)
grid minor
plot(times.states.value,solution.states.MA.value)
ylabel('M')







figure
subplot(3,1,1)
grid minor
plot(times.controls.value,solution.controls.Fr.value)
subplot(3,1,2)
grid minor
plot(times.controls.value,solution.controls.Fs.value)
subplot(3,1,3)
grid minor
plot(times.controls.value,solution.controls.Fw.value)


figure
hold on
axis equal
grid minor
view(25,45)
plot_earth
plot3(R(1,:),R(2,:),R(3,:),'b')





end

function varsfun(sh)

sh.addState('a');   
sh.addState('e','lb' ,0.0001, 'ub', 0.9999);   
sh.addState('incl','lb',0.0001, 'ub', pi-0.1);  
sh.addState('RA'); 
sh.addState('omega');  
sh.addState('MA');


sh.addState('sFr');  % Force x[N]
sh.addState('sFs');  % Force y[N]
sh.addState('sFw');  % Force y[N]

sh.addState('time', 'lb', 0, 'ub', 100000);  % time [s]

sh.addControl('Fr', 'lb', -0.0001, 'ub', 0.0001);  % Force x[N]
sh.addControl('Fs', 'lb', -0.0001, 'ub', 0.0001);  % Force y[N]
sh.addControl('Fw', 'lb', -0.0001, 'ub', 0.0001);  % Force z[N]

sh.addParameter('mu');        % mu
sh.addParameter('Re');


end

function daefun(sh,x,~,u,p)



a=x.a;
e=x.e;
incl=x.incl;
RA=x.RA;
omega=x.omega;
MA=x.MA;
theta=MA2theta(MA,e);

n=sqrt(p.mu/(a^3));
c2=sqrt(1-e^2);
u1=theta+omega;
p1=a*(1-e^2);
h=sqrt(p.mu*p1);

r=p1/(1+e*cos(theta));

% a_dot=2*e*sin(theta)/(n*c2)*u.Fr+2*a*c2/(n*r)*u.Fs;
% e_dot=c2*sin(theta)/(n*a)*u.Fr+c2/(n*a^2*e)*((a^2*c2^2)/r-r)*u.Fs;
% i_dot=r*cos(u)/(n*a^2*c2)*u.Fw;
% RA_dot=r*sin(u)/(n*a^2*c2*sin(inc))*u.Fw;
% omega_dot=-c2*cos(theta)/(n*a*e)*u.Fr+(p/(e*h))*(sin(theta)*(1+(1/(1+e*cos(theta)))))*u.Fs-r*cot(inc)*sin(u)/(n*a^2*c2)*u.Fw;
% M_dot=n-1/(n*a)*(2*r/a-(c2^2)/e*cos(theta))*u.Fr-c2^2/(n*a*e)*(1+r/(a*c2^2))*sin(theta)*u.Fs;


sh.setODE( 'a', 2*e*sin(theta)/(n*c2)*u.Fr+2*a*c2/(n*r)*u.Fs);
sh.setODE( 'e', c2*sin(theta)/(n*a)*u.Fr+c2/(n*a^2*e)*((a^2*c2^2)/r-r)*u.Fs);
sh.setODE( 'incl', r*cos(u1)/(n*a^2*c2)*u.Fw);
sh.setODE( 'RA', r*sin(u1)/(n*a^2*c2*sin(incl))*u.Fw);
sh.setODE( 'omega', -c2*cos(theta)/(n*a*e)*u.Fr+(p1/(e*h))*(sin(theta)*(1+(1/(1+e*cos(theta)))))*u.Fs-r*(1/tan(incl))*sin(u1)/(n*a^2*c2)*u.Fw);
sh.setODE( 'MA', n-1/(n*a)*(2*r/a-(c2^2)/e*cos(theta))*u.Fr-c2^2/(n*a*e)*(1+r/(a*c2^2))*sin(theta)*u.Fs);


sh.setODE('sFr', abs(u.Fr));
sh.setODE('sFs', abs(u.Fs));
sh.setODE('sFw', abs(u.Fw));
sh.setODE('time', 1);
end

function gridcosts(ch,k,K,x,~)



if k==K
    
%     R=[x.x x.y x.z];
%     R_=norm(R);
%     ch.add((R_-102050.24)^2)
%     V=[x.xdot x.ydot x.zdot];
%     V_=norm(V);
%     ch.add((V_-1.97634110924459)^2);
% 
%     fuel_cost=;
    

% ch.add(x.time)
ch.add(x.sFr^2+x.sFs^2+x.sFw^2);
    
end


end

function gridconstraints(ch,~,~,x,p)

% R=[x.x x.y x.z];
% V=[x.xdot x.ydot x.zdot];
% oe = oe_from_sv(R,V,p.mu);
% e=oe(2);
% 
% ch.add(e,'<=',0.99);
% ch.add(e,'>=',0);
% 
% ch.add(sqrt(x.x^2+x.y^2+x.z^2),'<=',p.Re+1000);
  
  
  
end