% demo_analysis.m
% ---------------
% Load the full simulation, make animation, compute metrics.

clear, close all

fname = 'agent_simulation_output_full.mat';     % change if needed
load(fname,'pos','vel')                         % brings pos,vel
dt   = 0.1;                                     % time-step used
ZOO  = 10;                                      % zone of orientation radius

% ---- metrics ----
[pol,clust] = compute_metrics(pos,vel,ZOO);
disp('Metrics saved:  polarization_plot.png, clustering_plot.png, group_metrics.csv')

% ---- animation ----
animate_agents(pos,vel,dt,'agent_animation.gif',20);  % also plays live
disp('GIF saved as agent_animation.gif')


