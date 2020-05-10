function [ke,fe] = element2D(psi)
    % Calculate be and fe
    % Deal with ke in the global mesh (Global assembly)

    % degree of the polynomial we construct
    d = length(psi);
    ke = struct('k',zeros(d),'b',zeros(d));
    fe = zeros(d,1);
    
    % Calculate quadratures
    Q1 = quadtriangle(2,'Type','nonproduct','Domain',[0 0;1 0;0 1]);
    Q2 = quadtriangle(1,'Type','nonproduct','Domain',[0 0;1 0;0 1]);
    
    for i = 1:d
        for j = 1:i
            % Calculate b-term
            psi_i = bipolyval(psi(i).fun,Q1.Points);
            psi_j = bipolyval(psi(j).fun,Q1.Points);
            ke.b(i,j) = Q1.Weights'*(psi_i.*psi_j);
            
            % Update ke due to symmetry
            if i~=j
                ke.b(j,i) = ke.b(i,j);
            end
        end
        % Update fe
        fe(i) = Q2.Weights'*bipolyval(psi(i).fun,Q2.Points);
    end
end