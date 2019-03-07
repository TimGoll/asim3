clc;
clear ALL;
close ALL;
warning ('off','all');

params_SMA; %load simulation params
params_plot; %load plot params

path_arr = strsplit(mfilename('fullpath'), {'/', '\'});
task_name = string(path_arr(end-1));
disp('running ' + task_name);

%GET SIM DATA
%simOut = sim('system_SOLENOID_r2016a', 'SimulationMode', 'normal');
%bla = simOut.get('bla');

%TESTPLOT
x1 = 0:pi/100:2*pi;
y1 = sin(x1);

x2 = x1;
y2 = cos(x2);

paw_default({x1;x2}, {y1;y2}, {'sinus'; 'cosinus'}, 'x', 'y', task_name, "sinus vs. cosinus", "plots", true, true)

