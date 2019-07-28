clear all;

solver = ocl.acados.Solver( ...
  3, ...
  'vars', @ocl.examples.cartpole.vars, ...
  'dae', @ocl.examples.cartpole.dae_acados, ...
  'pathcosts', @ocl.examples.cartpole.pathcosts, ...
  'N', 100);

solver.setInitialState('p', 0);
solver.setInitialState('v', 0);
solver.setInitialState('theta', pi);
solver.setInitialState('omega', 0);

solver.initialize('theta', [0 1], [pi 0]);

% Run solver to obtain solution
[sol,times] = solver.solve();

% visualize solution
figure; hold on; grid on;
ocl.stairs(times.controls, sol.controls.F/10.)
xlabel('time [s]');
ocl.plot(times.states, sol.states.p)
xlabel('time [s]');
ocl.plot(times.states, sol.states.v)
xlabel('time [s]');
ocl.plot(times.states, sol.states.theta)
legend({'force [10*N]','position [m]','velocity [m/s]','theta [rad]'})
xlabel('time [s]');

ocl.examples.cartpole.animate(sol,times);





