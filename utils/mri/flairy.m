function [Y] = flairy(TERI)
TE = TERI(1);
TR = TERI(2);
TI = TERI(3);
% tiss:  GM,   WM,  CSF,  les
T1 = [  940,  550, 4210, 1300];
T2 = [  100,   90, 2100,  150];
P  = [ 0.75, 0.65, 1.00, 0.80];
Y  = P.*(1 - 2.*exp(-TI./T1) + exp(-(TR)./T1)).*exp(-TE./T2); % Conventional Spin Echo
Y  = max(0, Y);