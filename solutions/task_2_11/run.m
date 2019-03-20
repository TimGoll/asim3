clc;
clear ALL;
close ALL;
warning ('off','all');

Parameter;
%beta = pi;

do_rerun = false;

path_arr = strsplit(mfilename('fullpath'), {'/', '\'});
task_name = string(path_arr(end-1));
disp('running ' + task_name);

%GET SIM DATA
simOut = simulate('Controller', do_rerun);
time = simOut.get('time');
alpha1_ = simOut.get('alpha1');
alpha2_ = simOut.get('alpha2');

start_distance = getDist(45,45, L0, beta);
distances = zeros(length(time), 1);

for i=1:1:length(time)
    distances(i) = getDist(alpha1_(i), alpha2_(i), L0, beta);
end

grip_force = ((-1)*distances + start_distance + d02) * k2;

prod = grip_force.*alpha1;

paw_default({time}, {prod}, {'Produkt of Angle and Force for '}, 'time [s]' ,  'F_{grip}*\alpha [N*rad]', task_name, "produkt", "plots", false, true);
paw_default({time}, {distances}, {'distances'}, 'time [s]', 'dist [m]', task_name, "distance", "plots", false, true);
paw_default({time}, {grip_force}, {'grip_force'}, 'time [s]', 'F_{grip} [N]', task_name, "F-grip", "plots", false, true);

stepsize = 0.033;
starttime = 10;
endtime = 20;

i = 0;
nextstep = starttime;
img_num = 1;

% while true
%     i = i+1;
%     if (time(i) < nextstep)
%         continue;
%     end
%     
%     if (time(i) > endtime)
%         break;
%     end
%     
%     h = figure(img_num);   
% 
%     alpha1_ = alpha1(i);
%     alpha2_ = alpha2(i);
% 
%     A1x = -sin(alpha1_)*L0/2;
%     A1y = -cos(alpha1_)*L0/2;
%     A1 = [A1x A1y];
% 
%     B1x = -sin(alpha1_)*L0;
%     B1y = -cos(alpha1_)*L0;
%     B1 = [B1x B1y];
% 
%     C1x = -sin(pi/4)*L0-Lp;
%     C1y = -cos(pi/4)*L0;
%     C1 = [C1x C1y];
% 
%     D1x = B1x + cos(beta-pi/2+alpha1_)*L0;
%     D1y = B1y - sin(beta-pi/2+alpha1_)*L0;
%     D1 = [D1x D1y];
% 
%     A2x = sin(alpha2_)*L0/2;
%     A2y = -cos(alpha2_)*L0/2;
%     A2 = [A2x A2y];
% 
%     B2x = sin(alpha2_)*L0;
%     B2y = -cos(alpha2_)*L0;
%     B2 = [B2x B2y];
% 
%     C2x = +sin(pi/4)*L0+Lp;
%     C2y = -cos(pi/4)*L0; 
%     C2 = [C2x C2y];
% 
%     D2x = B2x - cos(beta-pi/2+alpha2_)*L0;
%     D2y = B2y - sin(beta-pi/2+alpha2_)*L0;
%     D2 = [D2x D2y];
% 
%     hold on;
%     axis equal;
%     xlim([-0.35 0.35])
%     ylim([-0.2 0.05])
%     viscircles([0 0],0.002,'color','r');
%     viscircles(A1,0.002,'color','r');
%     viscircles(A2,0.002,'color','r');
%     viscircles(B1,0.002,'color','r');
%     viscircles(B2,0.002,'color','r');
%     viscircles(C1,0.002,'color','b');
%     viscircles(C2,0.002,'color','b');
%     viscircles(D1,0.002,'color','r');
%     viscircles(D2,0.002,'color','r');
%     line([0 B1x],[0 B1y],'color','r','Linewidth',2);
%     line([B1x D1x],[B1y D1y],'color','r','Linewidth',2);
%     line([B1x C1x],[B1y C1y],'color','b','Linewidth',1);
% 
%     line([0 B2x],[0 B2y],'color','r','Linewidth',2);
%     line([B2x D2x],[B2y D2y],'color','r','Linewidth',2);
%     line([B2x C2x],[B2y C2y],'color','b','Linewidth',1);
% 
%     s1 = 'Animation';
%     s2 = num2str(i);
%     s3 = '.png';
%     
%     set(gcf, 'PaperUnits', 'centimeters');
%     set(gcf, 'PaperPosition', [0 0 25 11]);
% 
%     path = "plots/animations/animation"+task_name+"___"+string(img_num)+".png";
%     disp(path);
%     
%     saveas(h, path);
%     
%     %%%%%
%     nextstep = nextstep + stepsize;
%     img_num = img_num +1;
% 
% end

%TESTPLOT
%paw_default({x1;x2}, {y1;y2}, {'sinus'; 'cosinus'}, 'x', 'y', task_name, "sinus vs. cosinus", "plots", true, true)

function [dist] = getDist(alpha1, alpha2, L0, beta)
    cur_B1x = -sin(alpha1)*L0;
    cur_B1y = -cos(alpha1)*L0;
    cur_D1x = cur_B1x + cos(beta-pi/2+alpha1)*L0;
    cur_D1y = cur_B1y - sin(beta-pi/2+alpha1)*L0;

    cur_B2x = sin(alpha2)*L0;
    cur_B2y = -cos(alpha2)*L0;
    cur_D2x = cur_B2x - cos(beta-pi/2+alpha2)*L0;
    cur_D2y = cur_B2y - sin(beta-pi/2+alpha2)*L0;

    dist = sqrt((cur_D1x - cur_D2x)^2 + (cur_D1y - cur_D2y)^2);
end

