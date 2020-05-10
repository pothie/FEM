function [K,F,M] = assemblead(nodelist,kn,fn,me,K,F,M)
    % Assemble kn and fn to global K and F to designated spot
    el = nodelist(1):nodelist(2);
    K(el,el) = K(el,el)+kn;
    F(el) = F(el)+fn;
    M(el,el) = M(el,el)+me;
end