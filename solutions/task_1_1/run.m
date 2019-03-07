clc;
clear ALL;
close ALL;
warning ('off','all');

do_rerun = false;

params_SMA; %load simulation params
params_plot; %load plot params

path_arr = strsplit(mfilename('fullpath'), {'/', '\'});
task_name = string(path_arr(end-1));
disp('running ' + task_name);

%GET SIM DATA
simOut_default = simulate('system_SOLENOID_default', do_rerun);
default_displacement = simOut_default.get('displacement');
default_time         = simOut_default.get('time');
default_force        = simOut_default.get('force');

simOut_no_volatage = simulate('system_SOLENOID_no_voltage', do_rerun);
no_volatage_displacement = simOut_no_volatage.get('displacement');
no_volatage_time         = simOut_no_volatage.get('time');

simOut_working = simulate('system_SOLENOID_working', do_rerun);
working_displacement = simOut_working.get('displacement');
working_time         = simOut_working.get('time');
working_force        = simOut_working.get('force');


paw_default({default_time}, {default_displacement}, {'default'}, 'time [s]', 'displacement [m]', task_name, "solonoid default", "plots", false, true)
paw_default({no_volatage_time}, {no_volatage_displacement}, {'no volatage'}, 'time [s]', 'displacement [m]', task_name, "solonoid no voltage", "plots", false, true)
paw_default({working_time}, {working_displacement}, {'working'}, 'time [s]', 'displacement [m]', task_name, "solonoid working", "plots", false, true)

paw_default({default_time}, {default_force}, {'default force plot'}, 'time [s]', 'force [N]', task_name, "solonoid default force plot", "plots", false, true)
paw_default({working_time}, {working_force}, {'working force plot'}, 'time [s]', 'force [N]', task_name, "solonoid working force plot", "plots", false, true)



