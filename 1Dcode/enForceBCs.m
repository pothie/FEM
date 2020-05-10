function [K,F] = enForceBCs(bNodes,bValues,K,F)
    BC = K(:,bNodes)*bValues; %u(0)K(:,1)+u(1)K(:,end)
    % Modify F
    F = F - BC; 
    % Update Nodes in F
    F(bNodes) = bValues;
    
    % zero out corresponding columns and rows
    K(bNodes,:) = 0;
    K(:,bNodes) = 0;
    
    % change Nodes in K
    K(bNodes(1),bNodes(1)) = 1;
    if length(bValues) == 2
        K(bNodes(2),bNodes(2)) = 1;
    end
end