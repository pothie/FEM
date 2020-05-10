function [K,F] = assemble1D(nodelist,kn,fn,K,F)
    % Assemble kn and fn to global K and F to designated spot
    el = nodelist(1):nodelist(2);
    K(el,el) = K(el,el)+kn;
    F(el) = F(el)+fn;
end