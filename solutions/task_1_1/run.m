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
simOut = sim('system_SOLENOID_r2016a', 'SimulationMode', 'normal');
%bla = simOut.get('bla');



