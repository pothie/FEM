function [K,F] = assemble2D(nodelist,kn,fn,K,F)
    % Assemble kn and fn to global K and F to designated spot
    el = nodelist;
    K(el,el) = K(el,el)+kn;
    F(el) = F(el)+fn;
end