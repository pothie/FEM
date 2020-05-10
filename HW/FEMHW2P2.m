%HW2 P2
clear all
k = 5;%3
node = linspace(-1,1,k+1);
x = linspace(-1,1,1e6);
figure()
for j = 1:k+1 %N_j
    N = poly([node(1:j-1)';node(j+1:k+1)']);
    disp("N"+num2str(j)+"(xi"+ num2str(j)+")="+rats(polyval(N,node(j))));
    psi = N/polyval(N,node(j)); %psi 1-4
    disp("N"+num2str(j)+" : "+num2str(psi));
    legend();
    plot(x,polyval(psi,x),"DisplayName","psi("+num2str(j)+")");
    hold on
end

% N1(xi1)=    -16/9     
% N1 : -0.5625      0.5625      0.0625     -0.0625
% N2(xi2)=     16/27    
% N2 : 1.6875     -0.5625     -1.6875      0.5625
% N3(xi3)=    -16/27    
% N3 : -1.6875     -0.5625      1.6875      0.5625
% N4(xi4)=     16/9     
% N4 : 0.5625      0.5625     -0.0625     -0.0625


