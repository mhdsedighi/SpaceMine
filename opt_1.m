clc

lambdas_0=rand_gen(1,N_sat,0,360);
phis_0=rand_gen(1,N_sat,-90,90);
alphas_0=zeros(1,N_sat);
betas_0=zeros(1,N_sat);


sim_data.params=params;
sim_data.mee_0=mee_0;
sim_data.pqr_0=pqr_0;
sim_data.eul_0=eul_0;
sim_data.N_sat=N_sat;
sim_data.max_f=max_f;

x0=[lambdas_0 phis_0 alphas_0 betas_0];
LB=[zeros(1,N_sat) -90*ones(1,N_sat) -30*ones(1,N_sat) -30*ones(1,N_sat)];
UB=[360*ones(1,N_sat) 90*ones(1,N_sat) 30*ones(1,N_sat) 30*ones(1,N_sat)];


cost_handle=@(inputArg)specific_sim(inputArg,sim_data);



%%%%%% Single Thread

% specific_sim(x0,sim_data)

% 
% % % options = optimoptions('simulannealbnd');
% % % % options.Display='Iter';
% % % options.PlotFcns={@saplotbestf,@saplotbestx };
% % % options.MaxIter=1e6;
% % % [x_opt,cost_opt,exitflag,output] = simulannealbnd(cost_handle,x0,LB,UB,options);



%%%%%% Multi Thread


cost_handle_multi=@(inputArg)multi_sim(inputArg,sim_data);
poolobj = gcp;
pctRunOnAll('initial_sim')
% addAttachedFiles(poolobj,{'myFun1.m','myFun2.m'})
addAttachedFiles(poolobj,{'model_1.slx','multi_sim.m'});
parfevalOnAll(@load_system,0,'model_1');
options = optimoptions('particleswarm','UseParallel', true, 'UseVectorized', true,'Display','iter','PlotFcn','pswplotbestf','SwarmSize',10);
nvars=4*N_sat;


[x_opt,cost_opt,exitflag,output]=particleswarm(cost_handle_multi,nvars,LB,UB,options)


cost_handle(x_opt)


lambdas=x_opt(1:N_sat);
phis=x_opt(N_sat+1:2*N_sat);
alphas=x_opt(2*N_sat+1:3*N_sat);
betas=x_opt(3*N_sat+1:4*N_sat);

plot_sats


