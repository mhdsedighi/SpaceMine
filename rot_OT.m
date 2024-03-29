clc; clear; close all
addpath OptimTraj
addpath chebfun
load('params')

%parameters
% params.N_sat=6;
% params.mu = 3.986005*10^5;
% Re=6378.14;

mass=450e9; %kg
R=435; %meters 
Ixx=0.4*mass*R^2;

rotation_period=7.627; %hours
spin_speed=(2*pi)/(7.63*3600);

Iyy=0.9*Ixx;
Izz=0.8*Ixx;
Ixy=0.2*Ixx;
Ixz=0.2*Ixx;
Iyz=0.2*Ixx;

params.Inertia =[Ixx -Ixy -Ixz;-Ixy Iyy -Iyz;-Ixz -Iyz Izz];
params.inv_Inertia=inv(params.Inertia);

%%%%%%%%%%%%%%%%%%%

% a_0=100*Re;
% e_0=0;
% incl_0=deg2rad(0);
% omega_0=0;
% RA_0=0;
% theta_0=deg2rad(0);
% 
% a_f=10*Re;
% e_f=0;
% incl_f=deg2rad(0);
% omega_f=0;
% RA_f=0;
% theta_f=deg2rad(10);
% 
% min_revolution=0;
% max_revolution=2;

min_hours=0;
max_hours=3;

% oe_0=[a_0 e_0 incl_0 omega_0 RA_0 theta_0];
% oe_f=[a_f e_f incl_f omega_f RA_f theta_f];
% mee_0=oe2mee(oe_0,params.mu)';
% mee_f=oe2mee(oe_f,params.mu)';

% mee_f=mee_0;

% quat_0=eul2quat(deg2rad([20 30 40]));
% quat_f=eul2quat(deg2rad([30 40 50]));

% state_0=[1e-2;2e-2;5e-2;quat_0';mee_0];
% state_f=[0;0;0;quat_f';mee_f];

% low_bound=[5*Re -inf -inf -inf -inf -inf];
% upp_bound=[20*Re 1 1 1 1 pi];

spin_vector=[2;1;0.3];
state_0=spin_speed*spin_vector/norm(spin_vector);
state_f=[0;0;0];

moment_max=500;
max_angular_speed_end=1e-6;



%%%%%%%%%%%%%%%%%%%%%

% User-defined dynamics and objective functions
problem.func.dynamics = @(t,x,u)( rot_dynamics(x,u,params) );
problem.func.pathObj = @(t,x,u)( pathcost(t,x,u) );

% Problem bounds
problem.bounds.initialTime.low = 0;
problem.bounds.initialTime.upp = 0;
problem.bounds.finalTime.low = min_hours*3600;
problem.bounds.finalTime.upp = max_hours*3600;

% problem.bounds.state.low = [-20 -20 -20 -inf -inf -inf -inf 0.7*min([a_0 a_f])   -inf -inf -inf -inf -inf]';
% problem.bounds.state.upp = [ 20  20  20  inf  inf  inf  inf 1.3*max([a_0 a_f])   1    1     1    1  inf]';
problem.bounds.state.low = [-20 -20 -20]';
problem.bounds.state.upp = [ 20  20  20]';
problem.bounds.initialState.low = state_0;
problem.bounds.initialState.upp = state_0;
% 
% problem.bounds.initialState.low(end)=0;
% problem.bounds.initialState.upp(end)=2*pi;


% problem.bounds.finalState.low = state_f;
% problem.bounds.finalState.upp = state_f;


% Guess at the initial trajectory
problem.guess.time = [0,0.5*(min_hours+max_hours)*24*3600];
% state_f(13)=mee_f(end)+max_revolution*2*pi;
problem.guess.state = [state_0  state_f];
problem.guess.control = zeros(3,2)+0.01*moment_max;


problem.bounds.control.low = 0*ones(3,1);
problem.bounds.control.upp = moment_max*ones(3,1);




state_f(1:3)=-max_angular_speed_end;
% state_f(4:7)=-1;
% state_f(13)=mee_0(end)+min_revolution*2*pi;
problem.bounds.finalState.low = state_f;
state_f(1:3)=max_angular_speed_end;
% state_f(4:7)=1;
% state_f(13)=mee_f(end)+max_revolution*2*pi;
% state_f(13)=1000;
problem.bounds.finalState.upp = state_f;


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
        problem.options(step).chebyshev.nColPts =100;
%         problem.options(step).defaultAccuracy = 'low';
%         problem.options(step).nlpOpt.MaxFunEvals=1e6;
%         problem.options(step).MaxIterations = 700;
%         problem.options.nlpOpt.MaxIter=500;
        
%         step=step+1;
%         problem.options(step).method = 'chebyshev';
%         problem.options(step).chebyshev.nColPts =150;
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
%                 problem.options(step).trapezoid.nGrid = 60;
%                 problem.options(step).defaultAccuracy = 'medium';
%                 problem.options(step).nlpOpt.MaxFunEvals=1e5;
%                 problem.options(step).MaxIterations=1000;
        
        
%                 problem.options(2).method = 'chebyshev';
%                 problem.options(2).chebyshev.nColPts =100;
%                 problem.options(2).defaultAccuracy = 'medium';
%                 problem.options(2).nlpOpt.MaxFunEvals=1e5;
       
%          step=step+1;
%         problem.options(step).method = 'rungeKutta';
%         problem.options(step).chebyshev.nColPts = 50;
%         problem.options(step).defaultAccuracy = 'medium';
%         problem.options(step).nlpOpt.MaxFunEvals=1e5;

%   step=step+1;
%         problem.options(step).method = 'rungeKutta';
%         problem.options(step).defaultAccuracy = 'medium';

%   step=step+1;
%         problem.options(step).method = 'hermiteSimpson';
%         problem.options(step).hermiteSimpson.nSegment = 300;
        
    case 'gpops'
        problem.options(1).method = 'gpops';
        
end


% Solve the problem
soln = optimTraj(problem);
T = soln(end).grid.time;
U = soln(end).grid.control;


N=length(T);
% R=zeros(3,N);
% V=zeros(3,N);
% 
% for i=1:N
%     
%     [r,v]=mee2rv(soln.grid.state(:,i)',params.mu);
%     R(:,i)=r;
%     V(:,i)=v;
%     
% end
% 
% Force_history=[U(1,:).*cos(U(2,:)).*sin(U(3,:)) ;U(1,:).*cos(U(2,:)).*cos(U(3,:)) ; U(1,:).*sin(U(2,:))  ];
% 
plotting_rot

T(end)/3600/24


save solve_rot
