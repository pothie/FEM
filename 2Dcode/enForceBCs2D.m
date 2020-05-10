function [K,F] = enForceBCs2D(bNodes,bValues,K,F)
    BC = K(:,bNodes)*bValues; 
    % Modify F
    F = F - BC; 
    % Update Nodes in F
    F(bNodes) = bValues;
    
    % zero out corresponding columns and rows
    K(bNodes,:) = 0;
    K(:,bNodes) = 0;
    
    % change Nodes in K
    K(bNodes,bNodes) = eye(length(bNodes));
end