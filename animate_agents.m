function animate_agents(pos,vel,dt,filename,fps)
% Animate agents with heading arrows.
% pos … N×2×T   positions
% vel … N×2×T   velocities
% dt  … time-step (sec)
% filename … ''  = just play,  '.gif' = save GIF,  '.mp4' = save video
% fps … frames per second for recording   (default 20)

if nargin<5, fps = 20; end
[N,~,T] = size(pos);
L = 50;

% -------- prepare figure ----------
fig = figure('Color','w');
ax  = axes(fig);   hold(ax,'on');
axis(ax,'equal');                 % keep 1:1 aspect
axis(ax,[-L-5  L+5  -L-5  L+5]);  % show the full circle (±55 for L = 50)
axis(ax,'off');

% boundary (radius = L=50)
thc = linspace(0,2*pi,200);
plot(ax,L*cos(thc),L*sin(thc),'k--','LineWidth',1.5);

% preallocate graphics objects
% --- NEW (red, wider, slightly larger head) ---
hQ = quiver(ax, nan(N,1), nan(N,1), nan(N,1), nan(N,1), ...
            'Color', [1 0 0], ...        % red arrows
            'LineWidth', 1.5, ...        % thicker shafts
            'MaxHeadSize', 1.0, ...      % bigger arrow-heads
            'AutoScale','off');


% -------- recorder ----------
if ~isempty(filename)
    if endsWith(filename,'.gif','IgnoreCase',true)
        mode = 'gif';
    else
        mode = 'video';
        v = VideoWriter(filename,'MPEG-4');
        v.FrameRate = fps;
        open(v);
    end
end

% -------- main loop -------------
for t = 1:T
    set(hQ,{'XData','YData','UData','VData'}, ...
           {pos(:,1,t), pos(:,2,t), vel(:,1,t), vel(:,2,t)});
    title(ax,sprintf('t = %.1f s', (t-1)*dt),'FontWeight','normal');
    drawnow;
    
    if exist('mode','var')
        frame = getframe(fig);
        if mode=="gif"
            [im,cm] = rgb2ind(frame.cdata,256);
            if t==1
                imwrite(im,cm,filename,'gif','LoopCount',inf,'DelayTime',1/fps);
            else
                imwrite(im,cm,filename,'gif','WriteMode','append','DelayTime',1/fps);
            end
        else
            writeVideo(v,frame);
        end
    end
end

if exist('mode','var') && mode=="video", close(v), end
end
