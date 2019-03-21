clc;
clear ALL;
close ALL;
warning ('off','all');

do_rerun = true;

params_SMA; %load simulation params
params_plot; %load plot params

path_arr = strsplit(mfilename('fullpath'), {'/', '\'});
task_name = string(path_arr(end-1));
disp('running ' + task_name);

%GET SIM DATA
simOut_working = simulate('system_SOLENOID_working', do_rerun);
working_time         = simOut_working.get('time');
working_temperature  = simOut_working.get('temperature');

paw_default({working_time}, {working_temperature}, {'working temperature plot'}, 'time [s]', 'temperature [K]', task_name, "temperature plot long", "plots", false, true)


