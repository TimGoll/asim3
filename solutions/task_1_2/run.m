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
simOut_working = simulate('system_SOLENOID_working', do_rerun);
working_time         = simOut_working.get('time');
working_flowrate     = simOut_working.get('flowrate');
working_energy       = simOut_working.get('energy_consumption');
working_engery_int   = simOut_working.get('energy_consumption_int');

paw_default({working_time}, {working_flowrate}, {'working flow rate plot'}, 'time [s]', 'flowrate [m^3/s]', task_name, "flow rate plot", "plots", false, true)
paw_default({working_time}, {working_energy}, {'working power plot'}, 'time [s]', 'power [W]', task_name, "power plot", "plots", false, true)
paw_default({working_time}, {working_engery_int}, {'working integrated energy plot'}, 'time [s]', 'energy [J]', task_name, "integrated enegery plot", "plots", false, true)



