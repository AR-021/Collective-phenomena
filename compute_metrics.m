function [pol,clust] = compute_metrics(pos,vel,ZOO)
% Returns     pol   … 1×T polarization
%             clust … 1×T clustering index
% Saves the two curves as PNGs and a CSV for later use.

[N,~,T] = size(pos);
dt = 0.1;                      % same as in the simulation
time = (0:T-1)*dt;

% --- polarization ---
vhat = vel ./ vecnorm(vel,2,2);           % N×2×T
pol  = vecnorm(sum(vhat,1),2,2) / N;      % 1×1×T
pol  = squeeze(pol);                      % >>> T×1  (now 1-D!)


% --- clustering index (largest-component / N) ---
clust = zeros(1,T);
for t = 1:T
    D     = squareform( pdist(pos(:,:,t)) );
    A     = (D < ZOO) & (D>0);       % adjacency
    G     = graph(A);
    bins  = conncomp(G);
    counts= histcounts(bins,1:max(bins)+1);
    clust(t) = max(counts) / N;
end

% ---------- plots ----------
figure, plot(time,pol),  xlabel('time (s)'), ylabel('Polarization'), grid on
title('Polarization vs time')
saveas(gcf,'polarization_plot.png')

figure, plot(time,clust)
xlabel('time (s)'), ylabel('Clustering index'), grid on
title('Clustering index vs time')
saveas(gcf,'clustering_plot.png')


