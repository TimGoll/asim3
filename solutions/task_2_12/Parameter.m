% parameter list


params = struct;		% system parameters

params.L1 = 5e-2*5;              %	DE membrane 1-length		[m]
params.L2 = params.L1*10*5;              %	DE membrane 2-length		[m]
params.L3 = 50e-6;             %	DE membrane 3-length		[m]
params.epsilon_0 = 8.854e-12;  % 	Void permittivity			[F/m]
params.epsilon_r = 3;		   %	DE relative permittivity
params.alpha = [1 1.5 2];               %	DE Ogden model exponents [-]
params.mu = [774 -885 277]*1e6;         %	DE Ogden model coefficient [Pa]
params.kv = [0.59 0.18 6.32*1]*1e6;            % 	DE viscoelastic model stiffness	[Pa]
params.bv = [0.08 0.25 0.00632*1]*1e6;            %   DE viscoelastic model damping [Pa*s]
params.rho = 1e12;                      %	DE resistivity [Ohm*m]
params.Re_s = 50;                       %	Electrodes resistance scaling coefficient [Ohm*m^2]

initConds = struct;		% initial conditions
initConds.epsilon1          = 0.12;                                              % 	Initial strain 1, only used to compute initial viscoelastic strains [-]
initConds.epsilon_v 	    = initConds.epsilon1*ones(size(params.kv));        % 	Initial viscoelastic strain [-]
initConds.q                 = 0;                                              % 	Initial charge [C]


initConds.alpha1_0 = pi/4;
initConds.alpha2_0 = pi/4;



L0 = 0.1;           % beam length [m]
beta = 110*pi/180;      % angle between beams [rad]
Lp = 0.2778;
%Lp = params.L1*1.2;     
k1 = 1000;
% k2 = 0; %task 2_8
k2 = 200;
%q1_0 = initConds.alpha1_0;
q1_0 = 1.0935;
q1_dot_0 = 0;
%q2_0 = initConds.alpha2_0;
q2_0 = q1_0;
q2_dot_0 = 0;
d01 = 0.05;%L0/2*sin(q1_0)*0.8;
d02 = 0.1;
m = 0.001;
I = L0^2*m;


%% Define symcolic variables

syms q1 q2

%%Berechnung der Punkte A1/2, B1/2, C1/2 und D1/2 (Task_2_1)


A1x = -sin(q1)*L0/2;
A1y = -cos(q1)*L0/2;
A1 = [A1x A1y];

B1x = -sin(q1)*L0;
B1y = -cos(q1)*L0;
B1 = [B1x B1y];

C1x = -sin(pi/4)*L0-Lp;
C1y = -cos(pi/4)*L0;
C1 = [C1x C1y];

D1x = B1x + cos(beta-pi/2+q1)*L0;
D1y = B1y - sin(beta-pi/2+q1)*L0;
D1 = [D1x D1y];

A2x = sin(q2)*L0/2;
A2y = -cos(q2)*L0/2;
A2 = [A2x A2y];

B2x = sin(q2)*L0;
B2y = -cos(q2)*L0;
B2 = [B2x B2y];

C2x = +sin(pi/4)*L0+Lp;
C2y = -cos(pi/4)*L0; 
C2 = [C2x C2y];

D2x = B2x - cos(beta-pi/2+q2)*L0;
D2y = B2y - sin(beta-pi/2+q2)*L0;
D2 = [D2x D2y];
