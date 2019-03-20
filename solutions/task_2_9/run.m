clc;
clear ALL;
close ALL;
warning ('off','all');

Parameter;

do_rerun = true;

path_arr = strsplit(mfilename('fullpath'), {'/', '\'});
task_name = string(path_arr(end-1));
disp('running ' + task_name);

%GET SIM DATA
simOut = simulate('Controller', do_rerun);
time = simOut.get('time');
F1 = simOut.get('F1');
F2 = simOut.get('F2');
alpha1 = simOut.get('alpha1');
alpha2 = simOut.get('alpha2');

W1 = F1.*alpha1;
W2 = F2.*alpha2;

DW1 = diff(W1);
DT = diff(time);
DW2 = diff(W2);

P1 = DW1./DT;
P2 = DW2./DT;

paw_dedfault_alpha1(2:end),P1);

paw_default({time}, {F1}, {'default'}, '\alpha_{1}', 'P_{1} [N]', task_name, "F1", "plots", false, true);
paw_default({time}, {F2}, {'default'}, 'time [s]', 'F_{2} [N]', task_name, "F2", "plots", false, true);
paw_default({time}, {q1}, {'default'}, 'time [s]', '\alpha_{1} [rad]', task_name, "Alpha1", "plots", false, true);
paw_default({time}, {q2}, {'default'}, 'time [s]', '\alpha_{2} [rad]', task_name, "Alpha2", "plots", false, true);

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
%     alpha1 = q1(i);
%     alpha2 = q2(i);
% 
%     A1x = -sin(alpha1)*L0/2;
%     A1y = -cos(alpha1)*L0/2;
%     A1 = [A1x A1y];
% 
%     B1x = -sin(alpha1)*L0;
%     B1y = -cos(alpha1)*L0;
%     B1 = [B1x B1y];
% 
%     C1x = -sin(pi/4)*L0-Lp;
%     C1y = -cos(pi/4)*L0;
%     C1 = [C1x C1y];
% 
%     D1x = B1x + cos(beta-pi/2+alpha1)*L0;
%     D1y = B1y - sin(beta-pi/2+alpha1)*L0;
%     D1 = [D1x D1y];
% 
%     A2x = sin(alpha2)*L0/2;
%     A2y = -cos(alpha2)*L0/2;
%     A2 = [A2x A2y];
% 
%     B2x = sin(alpha2)*L0;
%     B2y = -cos(alpha2)*L0;
%     B2 = [B2x B2y];
% 
%     C2x = +sin(pi/4)*L0+Lp;
%     C2y = -cos(pi/4)*L0; 
%     C2 = [C2x C2y];
% 
%     D2x = B2x - cos(beta-pi/2+alpha2)*L0;
%     D2y = B2y - sin(beta-pi/2+alpha2)*L0;
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

