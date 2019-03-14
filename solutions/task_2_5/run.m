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
simOut_working = simulate('Controller', do_rerun);

%TESTPLOT
%paw_default({x1;x2}, {y1;y2}, {'sinus'; 'cosinus'}, 'x', 'y', task_name, "sinus vs. cosinus", "plots", true, true)

