function sSMA_displacementIn(block)

setup(block);

function setup(block)
  
  % Number of input and output ports
  block.NumInputPorts  = 3;
  block.NumOutputPorts = 6;
  
  % Number of states
  block.NumContStates = 3;

  % Number of parameters
  block.NumDialogPrms = 2;
  
  % Details on input ports
  block.InputPort(1).Dimensions        = 1;
  block.InputPort(1).SamplingMode = 'Sample';
  block.InputPort(1).DirectFeedthrough = true;
  
  block.InputPort(2).Dimensions        = 1;
  block.InputPort(2).SamplingMode = 'Sample';
  block.InputPort(2).DirectFeedthrough = false;
  
  block.InputPort(3).Dimensions        = 1;
  block.InputPort(3).SamplingMode = 'Sample';
  block.InputPort(3).DirectFeedthrough = false;

  % Details on output ports 
  block.OutputPort(1).Dimensions       = 1;
  block.OutputPort(1).SamplingMode = 'Sample';
  
  block.OutputPort(2).Dimensions       = 3;
  block.OutputPort(2).SamplingMode = 'Sample';
  
  block.OutputPort(3).Dimensions       = 1;
  block.OutputPort(3).SamplingMode = 'Sample';
  
  block.OutputPort(4).Dimensions       = 1;
  block.OutputPort(4).SamplingMode = 'Sample';
  
  block.OutputPort(5).Dimensions       = 1;
  block.OutputPort(5).SamplingMode = 'Sample';
  
  block.OutputPort(6).Dimensions       = 1;
  block.OutputPort(6).SamplingMode = 'Sample';
  
  block.SampleTimes = [0 0];
  

  block.RegBlockMethod('InitializeConditions',    @InitConditions); 
  block.RegBlockMethod('Outputs',                 @Output);  
  block.RegBlockMethod('Derivatives',             @Derivatives);  
  block.RegBlockMethod('Terminate',               @Terminate);

function InitConditions(block)
  
  initConds = block.DialogPrm(2).Data;
    
  x(1) = initConds.xp0;
  x(2) = initConds.xm0;
  x(3) = initConds.T0;
  
  block.ContStates.Data = x;

  
function Output(block)

  params = block.DialogPrm(1).Data;
 
  
  E_A 			= params.E_A;	
  E_M			= params.E_M;
  epsilon_T 	= params.epsilon_T;
  epsilon_A_T0 	= params.epsilon_A_T0;	
  epsilon_M_T0 	= params.epsilon_M_T0;
  T0 			= params.T0;	
  dsigma_dT 	= params.dsigma_dT;	
  V_d           = params.V_d;	
  tau_x         = params.tau_x; 	
  k_b           = params.k_b;
  alpha 		= params.alpha;
  c_v 			= params.c_v;
  rho 			= params.rho;	
  latentHpls 	= params.latentHpls;	
  latentHmns 	= params.latentHmns;	
  r0 			= params.r0;	
  L0 			= params.L0;	
  T0R           = params.T0R;
  rho0A         = params.rho0A;
  rho0Mp        = params.rho0Mp;
  rho0Mm        = params.rho0Mm;
  alphaA        = params.alphaA;
  alphaMp       = params.alphaMp;
  alphaMm       = params.alphaMm;
  poisson       = params.poisson;
 
 
 
  displacement 	= block.InputPort(1).Data;  
  x = block.ContStates.Data;
  
  epsilon = (displacement - L0)/L0;

  % Output 1, force
  sigma = (epsilon - epsilon_T*(x(1)-x(2)))/((x(1)+x(2))/E_M + (1-x(1)-x(2))/E_A);
  y1(1) = sigma*pi*r0^2;
  
  % Output 2, phase fractions
  y2(1) = x(1);
  y2(2) = x(2);
  y2(3) = 1-x(1)-x(2);
  
  % Output 3, temperature
  temp = x(3);
  y3(1) = temp;
  
  % Output 4, strain
  y4(1) = epsilon;
  
  % Output 5, stress
  y5(1) = sigma;
  
  % Output 6, resistance
  rhoMp = rho0Mp*(1+alphaMp*(temp - T0R));
  rhoA = rho0A*(1+alphaA*(temp - T0R));
  rhoMm = rho0Mm*(1+alphaMm*(temp - T0R));
  rhoR = x(1)*rhoMp + x(2)*rhoMm + (1-x(1)-x(2))*rhoA;
  R = rhoR*(L0*(1+epsilon))/(pi*r0^2*(1-poisson*epsilon)^2);
  y6(1) = R;

  % Set all outputs
  block.OutputPort(1).Data = y1;
  block.OutputPort(2).Data = y2;
  block.OutputPort(3).Data = y3;
  block.OutputPort(4).Data = y4;
  block.OutputPort(5).Data = y5;
  block.OutputPort(6).Data = y6;
  


function Derivatives(block)

  params = block.DialogPrm(1).Data;
 
  E_A 			= params.E_A;	
  E_M			= params.E_M;
  epsilon_T 	= params.epsilon_T;
  epsilon_A_T0 	= params.epsilon_A_T0;	
  epsilon_M_T0 	= params.epsilon_M_T0;
  T0 			= params.T0;	
  dsigma_dT 	= params.dsigma_dT;	
  V_d           = params.V_d;	
  tau_x         = params.tau_x; 	
  k_b           = params.k_b;
  alpha 		= params.alpha;
  c_v 			= params.c_v;
  rho 			= params.rho;	
  latentHpls 	= params.latentHpls;	
  latentHmns 	= params.latentHmns;	
  r0 			= params.r0;	
  L0 			= params.L0;	
  T0R           = params.T0R;
  rho0A         = params.rho0A;
  rho0Mp        = params.rho0Mp;
  rho0Mm        = params.rho0Mm;
  alphaA        = params.alphaA;
  alphaMp       = params.alphaMp;
  alphaMm       = params.alphaMm;
  poisson       = params.poisson;
 
 
  
  displacement = block.InputPort(1).Data;
  p_el    = block.InputPort(2).Data;
  T_ext   = block.InputPort(3).Data;
  
  x = block.ContStates.Data;
  
  epsilon = (displacement-L0)/L0;
  sigma = (epsilon - epsilon_T*(x(1)-x(2)))/((x(1)+x(2))/E_M + (1-x(1)-x(2))/E_A);
  temp = x(3);
  
  % Compute model coefficients at temperature T

  sigma_A_T0 = E_A*epsilon_A_T0;
  sigma_M_T0 = E_M*(epsilon_M_T0 - epsilon_T);

  sigma_A_T = sigma_A_T0 + dsigma_dT*(temp - T0);
  sigma_M_T = sigma_M_T0 + dsigma_dT*(temp - T0);

  epsilon_A_T = sigma_A_T/E_A;
  epsilon_M_T = sigma_M_T/E_M + epsilon_T;

  beta_T_old = 0.5*(E_M*(epsilon_T-epsilon_A_T)*(epsilon_T-epsilon_M_T)-E_A*epsilon_A_T*epsilon_M_T);

  if sigma_A_T < 0  % Be sure that sigma_A is always positive
      sigma_A_T = 0;    
      sigma_M_T = sigma_A_T - (sigma_A_T0 - sigma_M_T0);
      epsilon_A_T = sigma_A_T/E_A;
      epsilon_M_T = sigma_M_T/E_M + epsilon_T;
      beta_T = 0.5*(E_M*(epsilon_T-epsilon_A_T)*(epsilon_T-epsilon_M_T)-E_A*epsilon_A_T*epsilon_M_T);
  else
      beta_T = beta_T_old; 
  end
  
  % Compute strain values associated with each of energy well extremum:

  a(1) = E_M/2;
  a(2) = (E_M*(epsilon_T-epsilon_M_T)+E_A*epsilon_A_T)/2/(epsilon_A_T-epsilon_M_T);
  a(3) = E_A/2;
  a(4) = a(2);
  a(5) = a(1);

  b(1) = E_M*epsilon_T;
  b(2) = epsilon_A_T*(E_M*(epsilon_T-epsilon_M_T)+E_A*epsilon_M_T)/(epsilon_A_T-epsilon_M_T);
  b(3) = 0;
  b(4) = -b(2);
  b(5) = -E_M*epsilon_T;

  c(1) = E_M/2*epsilon_T^2;
  c(2) = (2*beta_T*(epsilon_A_T-epsilon_M_T)+epsilon_A_T^2*(E_M*(epsilon_T-epsilon_M_T)+E_A*epsilon_M_T))/2/(epsilon_A_T-epsilon_M_T);
  c(3) = beta_T;
  c(4) = c(2);
  c(5) = c(1);

  eps_ext = (sigma - b)./a/2;

  if eps_ext(1) > -epsilon_M_T
      eps_ext(1)=-epsilon_M_T;
  end
  if eps_ext(2) < -epsilon_M_T
      eps_ext(2)=-epsilon_M_T;
  elseif eps_ext(2) > -epsilon_A_T
      eps_ext(2)=-epsilon_A_T;
  end

  if eps_ext(3) < -epsilon_A_T
      eps_ext(3)=-epsilon_A_T;
  elseif eps_ext(3) > epsilon_A_T
      eps_ext(3)=epsilon_A_T;
  end

  if eps_ext(4) < epsilon_A_T
      eps_ext(4)=epsilon_A_T;
  elseif eps_ext(4) > epsilon_M_T
      eps_ext(4)=epsilon_M_T;
  end

  if eps_ext(5) < epsilon_M_T
      eps_ext(5)=epsilon_M_T;
  end


  G = a.*eps_ext.^2 + b.*eps_ext + c - sigma*eps_ext;


  deltaG_mA = G(2)-G(1);
  deltaG_Am = G(2)-G(3);
  deltaG_Ap = G(4)-G(3);
  deltaG_pA = G(4)-G(5);

  lambda = V_d/k_b/temp;


  pma = 1/tau_x*exp(-lambda*deltaG_mA);
  pam = 1/tau_x*exp(-lambda*deltaG_Am);
  ppa = 1/tau_x*exp(-lambda*deltaG_pA);
  pap = 1/tau_x*exp(-lambda*deltaG_Ap);

  A_surface = 2*pi*r0*L0;		% SMA wire side surface
  A_crosssec = pi*r0^2;			% SMA wire cross section area
  V_wire = A_crosssec*L0;       % SMA wire volume
  
  % Compute states derivatives
  
  dx(1) = -ppa*x(1) + pap*(1-x(1)-x(2));
  dx(2) = -pma*x(2) + pam*(1-x(1)-x(2));
  dx(3) = 1/rho/c_v*(-alpha*(x(3)-T_ext)*A_surface/A_crosssec/L0+p_el/V_wire+latentHpls*dx(1)+latentHmns*dx(2));

  block.Derivatives.Data = dx;


function Terminate(block)

