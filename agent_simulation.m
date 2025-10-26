
clc
clear
close all

% Parameters
m = 6;
n = 10;
N = m * n;

ZOR = 1;
ZOO = 3;
ZOA = 10 + ZOO;

sight = 270;
turn_rate = pi/8;
err = 0.0;

t_steps = 3*1e3;
dt = 0.1;

L = 50; % Domain size (WALL)
tankcenterX = 0;
tankcenterY = 0;

pos = zeros(N,2,t_steps);
vel = zeros(N,2,t_steps);

% Initial configuration
L = 50;      % radius of tank
th = 2*pi*rand(N,1);
r  = L*sqrt(rand(N,1));   % uniform in circle
pos(:,1,1) = r.*cos(th);
pos(:,2,1) = r.*sin(th);


th0 = rand(N,1) * 2*pi;
vel(:,1,1) = cos(th0);
vel(:,2,1) = sin(th0);

% Simulation loop
for t = 2:t_steps
    vel(:,:,t) = vel(:,:,t-1);

    % Distance and interaction zones
    dist_ij = squareform(pdist(pos(:,:,t-1)));
    isrepulsion = dist_ij <= ZOR;
    for k = 1:N
        isrepulsion(k,k) = 0;
    end
    isalignment = dist_ij > ZOR & dist_ij <= ZOO;
    isattraction = dist_ij > ZOO & dist_ij <= ZOA;

    % Vision
    issight = zeros(N);
    for j = 1:N
        for js = 1:N
            if j ~= js
                angle = acos(dot(vel(j,:,t-1), diff(pos([js j],:,t-1))) / norm(diff(pos([js j],:,t-1))));
                if angle < deg2rad(sight)
                    issight(j,js) = 1;
                end
            end
        end
    end
    isalignment = isalignment .* issight;
    isattraction = isattraction .* issight;

    % Agent interactions
    for j = 1:N
        if sqrt((pos(j,1,t-1) - tankcenterX)^2 + (pos(j,2,t-1) - tankcenterY)^2) >= L
            db = [tankcenterX - pos(j,1,t-1), tankcenterY - pos(j,2,t-1)];
            db = db / norm(db);
            dberror = pi/8 * randn(1,2);
            db = db + dberror;
            db = db / norm(db);
            dj = db;
        elseif sum(isrepulsion(j,:)) > 0
            jj = find(isrepulsion(j,:));
            dr = [mean(pos(j,1,t-1) - pos(jj,1,t-1)), mean(pos(j,2,t-1) - pos(jj,2,t-1))];
            dr = dr / norm(dr);
            dj = dr;
        elseif sum(isalignment(j,:)) > 0 || sum(isattraction(j,:)) > 0
            jk = find(isalignment(j,:));
            jl = find(isattraction(j,:));
            if numel(jk) > 0 && numel(jl) > 0
                dal = mean(vel(jk,:,t-1), 1);
                dal = dal / norm(dal);
                datt = mean(pos(jl,:,t-1), 1) - pos(j,:,t-1);
                datt = datt / norm(datt);
                ds = (dal + datt)/2;
            elseif numel(jk) > 0
                dal = mean(vel(jk,:,t-1), 1);
                dal = dal / norm(dal);
                ds = dal;
            elseif numel(jl) > 0
                datt = mean(pos(jl,:,t-1), 1) - pos(j,:,t-1);
                datt = datt / norm(datt);
                ds = datt;
            end
            dj = ds;
        else
            vel(j,:,t) = vel(j,:,t-1);
            continue
        end

        % Add estimation error
        dj = dj + err * randn(1,2);
        dj = dj / norm(dj);

        % Turn smoothly
        turn_angle = atan2(dj(2)*vel(j,1,t-1) - dj(1)*vel(j,2,t-1), dj(1)*vel(j,1,t-1) + dj(2)*vel(j,2,t-1));
        if abs(turn_angle) > turn_rate * dt
            theta_j = atan2(vel(j,2,t-1), vel(j,1,t-1)) + sign(turn_angle)*turn_rate*dt;
            vel(j,:,t) = [cos(theta_j), sin(theta_j)];
        else
            vel(j,:,t) = dj;
        end
    end

    pos(:,:,t) = pos(:,:,t-1) + vel(:,:,t) * dt;
end

save('agent_simulation_output.mat','pos','vel');
