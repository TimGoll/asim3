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
working_flowrate     = simOut_working.get('flowrate');
working_energy       = simOut_working.get('energy_consumption');
working_engery_int   = simOut_working.get('energy_consumption_int');

simOut_working = simulate('system_SOLENOID_working_temp', do_rerun);
temp_working_time         = simOut_working.get('time');
temp_working_flowrate     = simOut_working.get('flowrate');
temp_working_energy       = simOut_working.get('energy_consumption');
temp_working_engery_int   = simOut_working.get('energy_consumption_int');

paw_default({working_time, temp_working_time}, {working_flowrate, temp_working_flowrate}, {'without temperature influence', 'with temperature influence'}, 'time [s]', 'flowrate [m^3/s]', task_name, "flow rate plot temp comparison", "plots", true, true)
paw_default({working_time, temp_working_time}, {working_energy, temp_working_energy}, {'without temperature influence', 'with temperature influence'}, 'time [s]', 'power [W]', task_name, "energy plot temp comparison", "plots", true, true)
paw_default({working_time, temp_working_time}, {working_engery_int, temp_working_engery_int}, {'without temperature influence', 'with temperature influence'}, 'time [s]', 'energy [J]', task_name, "integrated enegery plot temp comparison", "plots", true, true)



