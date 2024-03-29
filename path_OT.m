clc; clear; close all
addpath OptimTraj
addpath chebfun
load('params')

%parameters
% params.mu = 3.986005*10^5;
params.mu = 1.32712440018 *10^11;
% Re=6378.14;



% params.Ixx=1000;
% params.Iyy=1000;
% params.Izz=1000;
% params.Ixy=0;
% params.Ixz=0;
% params.Iyz=0;

%%%%%%%%%%%%%%%%%%%
AU=1.496e+8;

a_0=1.1896*AU;
e_0=0.1902;
incl_0=deg2rad(5.8837);
omega_0=deg2rad(211.43);
RA_0=deg2rad(251.62);
theta_0=deg2rad(0);

a_f=149598023;
e_f=0.0167086;
incl_f=deg2rad(7.155);
omega_f=deg2rad(114.20783);
RA_f=deg2rad(-11.26064);
theta_f=deg2rad(0);

min_revolution=1;
max_revolution=10;

min_days=0;
max_days=700;

oe_0=[a_0 e_0 incl_0 omega_0 RA_0 theta_0];
oe_f=[a_f e_f incl_f omega_f RA_f theta_f];
mee_0=oe2mee(oe_0,params.mu)';
mee_f=oe2mee(oe_f,params.mu)';

% mee_f=mee_0;

% quat_0=eul2quat(deg2rad([20 30 40]));
% quat_f=eul2quat(deg2rad([30 40 50]));

state_0=mee_0;
state_f=mee_f;

% low_bound=[5*Re -inf -inf -inf -inf -inf];
% upp_bound=[20*Re 1 1 1 1 pi];

thrust_max=0.000001;
% thrust_max=1;
% max_angular_speed_end=1e-5;



%%%%%%%%%%%%%%%%%%%%%

% User-defined dynamics and objective functions
problem.func.dynamics = @(t,x,u)( path_dynamics(x,u,params) );
problem.func.pathObj = @(t,x,u)( pathcost(t,x,u) );

% Problem bounds
problem.bounds.initialTime.low = 0;
problem.bounds.initialTime.upp = 0;
problem.bounds.finalTime.low = min_days*24*3600;
problem.bounds.finalTime.upp = max_days*24*3600;

problem.bounds.state.low = [0.5*min([a_0 a_f])   -inf -inf -inf -inf -inf]';
problem.bounds.state.upp = [1.5*max([a_0 a_f])   1    1     1    1  inf]';
problem.bounds.initialState.low = state_0;
problem.bounds.initialState.upp = state_0;
% 
% problem.bounds.initialState.low(end)=0;
% problem.bounds.initialState.upp(end)=2*pi;


% problem.bounds.finalState.low = state_f;
% problem.bounds.finalState.upp = state_f;


% Guess at the initial trajectory
problem.guess.time = [0,0.5*(min_days+max_days)*24*3600];
problem.guess.time = [0,max_days*24*3600];
state_f(6)=mee_f(end)+max_revolution*2*pi;
problem.guess.state = [state_0  state_f];
% problem.guess.control = zeros(3,2)+0.1*thrust_max;
problem.guess.control = zeros(3,2);


problem.bounds.control.low = 0*ones(3,1);
problem.bounds.control.upp = thrust_max*ones(3,1);




% state_f(1:3)=-max_angular_speed_end;
% state_f(4:7)=-1;
state_f(6)=mee_0(end)+min_revolution*2*pi;
problem.bounds.finalState.low = state_f;
% state_f(1:3)=max_angular_speed_end;
% state_f(4:7)=1;
state_f(6)=mee_f(end)+max_revolution*2*pi;
state_f(6)=1000;
problem.bounds.finalState.upp = state_f;



% Select a solver:
% problem.options.method = 'rungeKutta';
% problem.options.method = 'chebyshev';


% problem.options.method = 'trapezoid';
% problem.options.method = 'multiCheb';

problem.options.defaultAccuracy = 'medium';

% problem.options.rungeKutta.nSegment=100;
% problem.options.trapezoid.nGrid=200;

% problem.options.nlpOpt.MaxFunEvals=1e6;
% problem.options.nlpOpt.MaxIter=1e5;

% problem.options.chebyshev.nColPts=30;

% problem.options.multiCheb.nColPts=30;

% method = 'trapezoid'; %  <-- this is robust, but less accurate
% method = 'direct'; %  <-- this is robust, but some numerical artifacts
% method = 'rungeKutta';  % <-- slow, gets a reasonable, but sub-optimal soln
method = 'orthogonal';    %  <-- this usually finds bad local minimum
% method = 'gpops';      %  <-- fast, but numerical problem is maxTorque is large

switch method
    case 'direct'
        problem.options(1).method = 'trapezoid';
        problem.options(1).trapezoid.nGrid = 20;
        
        problem.options(2).method = 'trapezoid';
        problem.options(2).trapezoid.nGrid = 40;
        
        problem.options(3).method = 'hermiteSimpson';
        problem.options(3).hermiteSimpson.nSegment = 20;
        
    case 'trapezoid'
        problem.options(1).method = 'trapezoid';
        problem.options(1).trapezoid.nGrid = 30;
        problem.options(2).method = 'trapezoid';
        problem.options(2).trapezoid.nGrid = 40;
        problem.options(3).method = 'trapezoid';
        problem.options(3).trapezoid.nGrid = 60;
        
    case 'rungeKutta'
        problem.options(1).method = 'rungeKutta';
        problem.options(1).defaultAccuracy = 'low';
        
        problem.options(2).method = 'rungeKutta';
        problem.options(2).defaultAccuracy = 'medium';
       
        
        
        
        
        
    case 'orthogonal'
        step=0;
        
        
        step=step+1;
        problem.options(step).method = 'chebyshev';
        problem.options(step).chebyshev.nColPts =400;
        problem.options(step).defaultAccuracy = 'low';
        problem.options(step).nlpOpt.MaxFunEvals=1e5;
%         problem.options.nlpOpt.MaxIter=500;
        
%         step=step+1;
%         problem.options(step).method = 'chebyshev';
%         problem.options(step).chebyshev.nColPts =20;
%         problem.options(step).defaultAccuracy = 'low';
% %         problem.options(step).nlpOpt.MaxFunEvals=1e6;
%         
%         
%                 step=step+1;
%         problem.options(step).method = 'chebyshev';
%         problem.options(step).chebyshev.nColPts =60;
%         problem.options(step).defaultAccuracy = 'medium';
%         problem.options(step).nlpOpt.MaxFunEvals=1e5;
        
%                 step=step+1;
%                 problem.options(step).method = 'trapezoid';
%                 problem.options(step).chebyshev.nColPts = 40;
%                 problem.options(step).defaultAccuracy = 'medium';
% %                 problem.options(step).nlpOpt.MaxFunEvals=1e5;
        
        
%                 problem.options(2).method = 'chebyshev';
%                 problem.options(2).chebyshev.nColPts =100;
%                 problem.options(2).defaultAccuracy = 'medium';
%                 problem.options(2).nlpOpt.MaxFunEvals=1e5;
       
%          step=step+1;
%         problem.options(step).method = 'rungeKutta';
%         problem.options(step).chebyshev.nColPts = 50;
%         problem.options(step).defaultAccuracy = 'medium';
%         problem.options(step).nlpOpt.MaxFunEvals=1e5;
    case 'gpops'
        problem.options(1).method = 'gpops';
        
end


% Solve the problem
soln = optimTraj(problem);
T = soln(end).grid.time;
U = soln(end).grid.control;



T(end)/3600/24

plotting_path



ref_mee=soln(end).grid.state(1:6,:);
ref_T=T;

save('ref.mat','ref_mee','ref_T')


save solve_path