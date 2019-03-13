%% Define initial conditions

q1_0 = 45*pi/180;
q1_dot_0 = 0;
q2_0 = 45*pi/180;
q2_dot_0 = 0;

%% Define symcolic variables

syms q1 q2 dq1 dq2 L0 Lp k1 k2 d10 d20 I

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

X = A1-A2;
Y = D1-D2;

%Berechnungen Task_2_4

global Sf lf Jf

L = 0.5*I*dq1^2+0.5*I*dq2^2-0.5*k1*(sqrt(X(1)^2+ X(2)^2)-d10)^2-0.5*k2*(sqrt(Y(1)^2+Y(2)^2)-d20)^2;
S11 = simplify(diff(L, q1));
S12 = simplify(diff(L, q2));
S21 = simplify(diff(L, dq1));
S22 = simplify(diff(L, dq2));
S = [S11 S12;S21 S22];

l1 = sqrt((C1(1)-B1(1))^2+(C1(2)-B1(2))^2);
l2 = sqrt((C2(1)-B2(1))^2+(C2(2)-B2(2))^2);
l=[l1;l2];

J11 = simplify(diff(l1, q1));
J12 = simplify(diff(l1, q2));
J21 = simplify(diff(l2, q1));
J22 = simplify(diff(l2, q2));
J = [J11 J12;J21 J22];

lf = matlabFunction(l);
Jf = matlabFunction(J);
Sf = matlabFunction(S);