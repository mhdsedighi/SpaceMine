
% A=[1 2 4;3 0 5];
% b=[3;4];
%
% x_b = lsqminnorm(A,b)

% params=[];
clc
clear

load solve3
quatS=sol2.y';
% fmS=[Force_command_xyz; Moment_command];
fmS=U';
% tS=T;
N_time=length(T2);

a=10;
b=8;
c=6;

N_sat=20;


% lambdas=[-45 45 180+45   180-45   90         90       0      0]
% phis=[0 0    0         0     90+30      90-30    -90+30 -90-30]
% pitchs=zeros(1,N_sat);
% yaws=zeros(1,N_sat);

lambdas=rand_gen(1,N_sat,0,360);
phis=rand_gen(1,N_sat,-90,90);
% pitchs=zeros(1,N_sat);
% yaws=zeros(1,N_sat);
alphas=rand_gen(1,N_sat,0,30);
betas=rand_gen(1,N_sat,0,360);





params=rigid_positioning(N_sat,a,b,c,lambdas,phis,alphas,betas);



% quat=eul2quat(deg2rad([20 0 40]));

% N_time=100;
% Tmax=1000;
% quatS=eul2quat(deg2rad([rand_gen(N_time,1,-90,90) rand_gen(N_time,1,-90,90) rand_gen(N_time,1,0,360)]));
% max_moment=5;
% max_force=7;
% fmS=[rand_gen(3,N_time,-max_force,max_force) ; rand_gen(3,N_time,-max_moment,max_moment)];
% 
% tS=linspace(0,Tmax,N_time);


% U=zeros(N_sat,N_time);

exitflagS=zeros(1,N_time);
sum_u=zeros(1,N_time);
% resi=zeros(1,N_time);
for i=1:N_time
    quat=quatS(i,:);
%     fm=fmS(:,i);
fm=interp1(T,fmS,T2(i))';

    [params]=control_mat(params,quat);
    %     u_star=lsqnonneg(params.control_mat,fm);
    [u_star,~,~,exitflag,~] = lsqnonneg(params.control_mat,fm);
    
    exitflagS(i)=exitflag;
    sum_u(i)=sum(u_star);
%     U(:,i)=u_star;
end
% cost=trapz(tS,sum_u)*(1+sum(-exitflagS+1))

% cost=trapz(tS,sum_u);
cost=trapz(T2,sum_u);

sum_flags=sum(exitflagS);
if sum_flags<N_time
    cost=cost*(N_time-sum_flags)
end

cost

plot_sats

% sum2=0;
% for i=1:N_sat
% sum2=sum2+trapz(tS,U(i,:));
% end
% sum2


% [params]=control_mat(params,quat);
%
% A=params.control_mat
% b=[1;1;1;1;1;1]
%
% u_star = lsqminnorm(A,b)
% A*u_star-b
% u_star=lsqnonneg(A,b)
% A*u_star-b




% pitch=0;
% yaw=0;
% V=[1 2 3];
% O=[3 4 6];
% [V_new]=rotate_about(V,O,pitch,yaw)