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

U = 0.5; %V

%GET SIM DATA
simOut_working = simulate('system_SMA_working', do_rerun);
sma_time         = simOut_working.get('time');
sma_displacement = simOut_working.get('displacement');
sma_flowrate     = simOut_working.get('flowrate');
sma_temperature  = simOut_working.get('temperature');
sma_engery_int   = simOut_working.get('energy_consumption_int');

paw_default({sma_time}, {sma_displacement}, {'SMA displacement plot'}, 'time [s]', 'displacement [m]', task_name, "SMA displacement U=" + string(U), "plots", false, true)
paw_default({sma_time}, {sma_temperature}, {'SMA temperature plot'}, 'time [s]', 'temperature [K]', task_name, "SMA temperature U=" + string(U), "plots", false, true)
paw_default({sma_time}, {sma_flowrate}, {'SMA flowrate plot'}, 'time [s]', 'flow rate [m^3/s]', task_name, "SMA flowrate U=" + string(U), "plots", false, true)
paw_default({sma_time}, {sma_engery_int}, {'SMA energy plot'}, 'time [s]', 'engergy [J]', task_name, "SMA engery U=" + string(U), "plots", false, true)


paw_default({sma_time, sma_time}, {sma_displacement ./ 100, sma_flowrate}, {'displacement [100m]', 'flow rate [m^3/s]'}, 'time [s]', 'displacement [m] / flow rate [m^3/s]', task_name, "SMA displacement with flowrate U=" + string(U), "plots", true, true)


