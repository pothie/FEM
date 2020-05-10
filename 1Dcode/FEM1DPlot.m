function FEM1DPlot(k,p,sol,points)
    % k: # of elements
    % n: # of nodes
    % p: degree of shape functions
    % sol: solution
    for i=1:k
        pt = points(p*(i-1)+1:p*(i)+1);
        coeff = polyfit(pt,sol(p*(i-1)+1:p*(i)+1),p);
        plot(pt,polyval(coeff,pt),'r')
        hold on
    end
    hold off
end