params.final_test=0;
close all
% mode='single'
mode='multi'
strategy=1;   %%% min time
% strategy=2;    %%% min energy


pqr_0=[1 2 3]*1e-4;

clc
warning('off','all')

params.mass_sat_empty=15;
mass_total=params.mass;  %%neglecting sats weight
Inertia_total=params.Inertia;

params.Isp=3000;
params.max_f=10;
params.mee_0=mee_0;
params.strategy=strategy;

maxIter=25;
params.options = optimoptions('lsqnonlin','Algorithm','levenberg-marquardt','MaxIterations',maxIter,'Display','none');
params.LB=zeros(N_sat,1);
params.UB=params.max_f*ones(N_sat,1);

N_sat=25;
% lambdas=rand_gen(1,N_sat,0,360);
% phis=rand_gen(1,N_sat,-90,90);
% alphas=zeros(1,N_sat);
% betas=zeros(1,N_sat);
% [Force_Vectors,Moment_Vectors]=rigid_positioning(params,N_sat,lambdas,phis,alphas,betas);
% Force_Vectors=Force_Vectors';
% Moment_Vectors=Moment_Vectors';

%%% all sats are the same weight
MFuel_0=30;
MFuel_min=30;
MFuel_max=30;



lambdas_0=rand_gen(1,N_sat,0,360);
phis_0=rand_gen(1,N_sat,-90,90);
alphas_0=90*ones(1,N_sat);
betas_0=zeros(1,N_sat);
% W_0=[1 1 1 1 1];
% theta_0=0;
if strategy==1
    W_0=[15.7691   19.1673   10.3197   18.2571   10.5895]/100;
    theta_0=5.4986;

        W_0=[0.1881    0.1580    0.0834    0.2126    0.1233];
    theta_0=2.3480+1.4885;
elseif strategy==2
    W_0=[1.0000    0.2350    0.1476    0.4439    0.3023];
    theta_0=6.0565;

    W_0=[15.7691   19.1673   10.3197   18.2571   10.5895]/100;
    theta_0=5.4986;

    W_0=[0.1881    0.1580    0.0834    0.2126    0.1233];
%     theta_0=2.3480+1.4885;
theta_0=2.3480;
%     W_0=[0.2038    0.0409    1.0000    0.0305    0.2375];
% theta_0 = 1.0518;

%     W_0=[0.1577    0.1917    0.1032    0.1826    0.1059];
%     theta_0=5.4986;

% W_0=[0.380594272044897	0.0531237770845092	1	0.0300062771543187	0.0555087864539103];
% theta_0=7.37594679346871-2*pi;
end
oe_0(6)=theta_0;
mee_0=oe2mp(oe_0);
rot_Gains_0=[1 1 1];
target_angles_0=[0 0 0];
dif_theta=0;


x0=[lambdas_0 phis_0 alphas_0 betas_0 W_0 rot_Gains_0 target_angles_0 0];
LB=[zeros(1,N_sat) -180*ones(1,N_sat) 45*ones(1,N_sat) 0*ones(1,N_sat) 0.98*W_0 0.9*ones(1,3) -pi*ones(1,3) -pi/8];
UB=[720*ones(1,N_sat) 180*ones(1,N_sat) 135*ones(1,N_sat) 720*ones(1,N_sat) 1.02*W_0 1.1*ones(1,3) pi*ones(1,3) pi/8];

% x0=[lambdas_0 phis_0 alphas_0 betas_0 W_0 rot_Gains_0 target_angles_0];
% LB=[lambdas_0 phis_0 alphas_0 betas_0 1*W_0 0.7*ones(1,3) -pi/2*ones(1,3)];
% UB=[lambdas_0 phis_0 alphas_0 betas_0 1*W_0 1.3*ones(1,3) pi/2*ones(1,3)];

if params.final_test==0

if strcmp(mode,'single')

cost_handle=@(inputArg)sim_cost(inputArg,N_sat,params);
options = optimoptions('simulannealbnd');
% options.Display='Iter';
% options.PlotFcns={@saplotbestf,@saplotbestx };
options.PlotFcns={@saplotbestf};
options.MaxIter=1e6;
options.InitialTemperature=700;
[x_opt,cost_opt,exitflag,output] = simulannealbnd(cost_handle,x0,LB,UB,options);





elseif strcmp(mode,'multi')

%%% must be updated


sim_data.params=params;
sim_data.mee_0=mee_0;
sim_data.pqr_0=pqr_0;
sim_data.eul_0=eul_0;
sim_data.N_sat=N_sat;
sim_data.max_f=max_f;
sim_data.strategy=strategy;
cost_handle_multi=@(inputArg)multi_sim2(inputArg,sim_data);
poolobj = gcp;
addAttachedFiles(poolobj,{'model_5_exact.slx','multi_sim2.m'});
pctRunOnAll('initial_sim2')

parfevalOnAll(@load_system,0,'model_5_exact');
options = optimoptions('particleswarm','UseParallel', true, 'UseVectorized', true,'Display','iter','PlotFcn','pswplotbestf','SwarmSize',4);
nvars=4*N_sat+5+3+3+1;
[x_opt,cost_opt,exitflag,output]=particleswarm(cost_handle_multi,nvars,LB,UB,options)

end



lambdas=x_opt(1:N_sat);
phis=x_opt(N_sat+1:2*N_sat);
alphas=x_opt(2*N_sat+1:3*N_sat);
betas=x_opt(3*N_sat+1:4*N_sat);
W=x_opt(4*N_sat+1:4*N_sat+5);
rot_Gains=x_opt(4*N_sat+6:4*N_sat+8);
target_angles=x_opt(4*N_sat+9:4*N_sat+11);
dif_theta_start=x_opt(4*N_sat+12);
oe_0(6)=oe_0(6)+0;
mee_0=oe2mp(oe_0);
[sat_pos,Force_Vectors,Moment_Vectors,min_dis]=rigid_positioning_dis(sim_data.params,N_sat,lambdas,phis,alphas,betas);

params.final_test=1;
sim_data.params.final_test=1;

%%%% why I Must write it again?
params.max_f=max_f;
params.mee_0=mee_0;
params.strategy=strategy;

maxIter=50;
params.options = optimoptions('lsqnonlin','Algorithm','levenberg-marquardt','MaxIterations',maxIter,'Display','none');
params.LB=zeros(N_sat,1);
params.UB=params.max_f*ones(N_sat,1);
%%%%
end
% params.max_f=max_f;

if strcmp(mode,'single')
cost_opt=sim_cost(x_opt,N_sat,params);
elseif strcmp(mode,'multi')
cost_opt=sim_cost(x_opt,N_sat,params);
end

mark_err
reach_fac
detumble_fac
min_dis
int_Fs
std_int_Fs
sum_int_Fs
T_end
% res_fuels


ylabel('Cost Function Value')
title('')
set(gca,'Yscale','log','Xgrid','on','Ygrid','on')

plot_sats
plot_sim
plot_motion




