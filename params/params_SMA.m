% parameter list
clear all

% valve
valve.m   = 0.1;                    % [kg]      mass of plunger
valve.g   = 9.81;                   % [m/s^2]   gravity
valve.k   = 100;                    % [N/m]     spring stiffness
valve.x_0 = -10e-3;                 % [m]       spring pre-displacement
valve.b_d = 50;                     % [Ns/m]    damping
valve.v_0 = 0;                      % [m/s]     inital plunger velocity
valve.y_0 = max(0, valve.m*valve.g/valve.k+valve.x_0); % [m]

% fluid
fluid.rho   = 900;                  % [kg/m^3]  fluid density
fluid.eta   = 0.5;                  % [1]       valve flow efficiency
fluid.x_o   = 1.5e-3;               % [m]       position of completely open
fluid.x_c   = 0.2e-3;               % [m]       position of completely closed
fluid.dx    = fluid.x_o-fluid.x_c;  % [m]       stroke
fluid.A_max = pi*2e-3*fluid.dx;     % [m^2]     orifice flow area
fluid.dP    = 0.1e5;                % [Pa]      pressure difference
fluid.A     = @(x)(x<fluid.x_c)*0 + (fluid.x_c<x).*(x<=fluid.x_o).*(fluid.A_max-0)/(fluid.x_o-fluid.x_c).*(x-fluid.x_c) + (fluid.x_o<x)*fluid.A_max;

% solenoid
solenoid.mu_0    = 4*pi*1e-7;       % [N/A^2]   vacuum permeability
solenoid.N       = 6000;            % [1]       number of coil turns
solenoid.R       = 25.2;            % [Ohm]     constant coil resitance at T0
solenoid.d       = 5e-3;            % [m]       plungerr diameter
solenoid.A_f     = pi/4*solenoid.d^2; % [m^2]   punger axial area
solenoid.A_g     = pi*solenoid.d * 1e-3*0.1; % [m^2] punger radial area
solenoid.l_g     = 0.4e-3;          % [m]       air gap
solenoid.x_0     = 2.0e-3;          % [m]       offset between valve system and solenoid system = plunger position at closed valve
solenoid.rhoR    = 1.68e-8;         % [Ojm*m]   resistivity of copper
solenoid.alphaR  = 3.86e-3;         % [1/K]     temperature dependence of resistivity
solenoid.T0R     = 293;             % [K]       reference temperature for resistivity
solenoid.d_cu    = 0.4e-3;          % [m]       diameter copper wire
solenoid.l_cu    = solenoid.N*pi*10e-3; % [m]    length copper wire
solenoid.d_case  = 15e-3;           % [m]       diameter case
solenoid.l_case  = 25e-3;           % [m]       length case
solenoid.alpha   = 50;              % [W/(m^2*K)] convection coefficient
solenoid.rho_case= 7874;            % [kg/m^3]  density of case	
solenoid.c_v     = 449;             % [J/(kg*K)] heat capacity of case
solenoid.T0      = 293;             % [K]       initial temperature

% SMA Parameters
sma.E_A 	     = 70.0e9;			%   [Pa]    Austenite modulus of elasticity
sma.E_M			 = 30.0e9;			%	[Pa]    Martensite modulus of elasticity
sma.epsilon_T 	 = 0.04;            %	[-]     epsilon_T
sma.epsilon_A_T0 = 0.0035;	        %   [-]     epsilon_A at temperature T0
sma.epsilon_M_T0 = 0.0415;	        %   [-]     epsilon_M at temperature T0
sma.T0 			 = 293;	            %	[K]     reference temperature at which epsilon_A_T0 and epsilon_M_T0 are measured
sma.dsigma_dT 	 = 7e6;             %   [Pa]    dsigma/dtemp
sma.V_d 		 = 5e-23;           % 	[m^3]   volume of a layer
sma.tau_x 		 = 1e-2;            %	[s]     vibration frequency
sma.k_b 		 = 1.380649e-23;    %	[J/K]   Boltzman constant
sma.alpha 		 = 210;				%	[W/(m^2*K)] convection coefficient
sma.c_v          = 0.45e3;			%	[J/(kg*K)]  Heat capacity		
sma.rho 		 = 6500;			%	[kg/m^3]    density					
sma.latentHpls 	 = 24e3*sma.rho;	% 	[J/m^3]     Latent heat of phase transformation
sma.latentHmns 	 = 24e3*sma.rho;	% 	[J/m^3]     Latent heat of phase transformation
sma.r0 			 =  50e-6;          %	[m]     wire radius
sma.L0 			 = 100e-3;          %	[m]     wire length
sma.T0R          = 293;             %   [K]     reference temperature for computing R
sma.rho0A        =  8.9e-7;         %   [Ohm*m] resistivity of austenite
sma.rho0Mp       = 10.2e-7;         %   [Ojm*m] resistivity of martensite plus
sma.rho0Mm       = 10.2e-7;         %   [Ojm*m] resistivity of martensite minus
sma.alphaA       = 2e-4;            %   [1/K]   temperature dependence of austenite
sma.alphaMp      = 3e-4;            %   [1/K]   temperature dependence of austenite
sma.alphaMm      = 3e-4;            %   [1/K]   temperature dependence of austenite
sma.poisson      = 0.3;             %   [-]     Poisson's ratio

% Initial conditions
init = struct;		% initial conditions
init.xp0 		 = 1.0;             %   [-]     initial phase fraction x+
init.xm0 		 = 0.0;             %   [-]     initial phase fraction x-
init.T0 		 = 293;             %   [K]     initial temperature of wire
init.H0 		 =  7e-3;           % 	[m]     inital height of triangle actuator, martensite
init.B 		     = 30e-3;           % 	[m]     width of triangle actuator
sma.L0           = sqrt(init.H0^2 + (init.B/2)^2)/(1 + sma.epsilon_T + (sma.E_A*sma.epsilon_A_T0+sma.dsigma_dT*(init.T0 - sma.T0))/sma.E_M);% [m] inital lngth of SMA wire 
