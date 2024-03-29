function cost=positioning_cost(x,N_sat,N_time,T_quats,quats,fms,params)


lambdas=x(1:N_sat);
phis=x(N_sat+1:2*N_sat);
alphas=x(2*N_sat+1:3*N_sat);
betas=x(3*N_sat+1:4*N_sat);


% params=rigid_positioning(N_sat,params.a,params.b,params.c,lambdas,phis,alphas,betas);
% % control_mat=param1.Moment_Vectors';
% params=control_mat(params,quat);




exitflagS=zeros(1,N_time);
sum_u=zeros(1,N_time);

[Force_Vectors,Moment_Vectors]=rigid_positioning(params,N_sat,lambdas,phis,alphas,betas);

for i=1:N_time
    quat=quats(:,i)';
    fm=fms(:,i);
    

    c_mat=control_mat(Force_Vectors,Moment_Vectors,quat,N_sat);
    
    [u_star,~,~,exitflag,~] = lsqnonneg(c_mat,fm);
    
    exitflagS(i)=exitflag;
    sum_u(i)=sum(u_star);
end

cost=trapz(T_quats,sum_u);

sum_flags=sum(exitflagS);
if sum_flags<N_time
    cost=cost*(N_time-sum_flags);
end






end