%%-------------------------------------------------------------------------
%
%  read_input.m
%  ------------
%
%  Reads in input file for 1D model problem (input.1d)
%
%  The following variables are assigned in this script:
%
%   - problemID = character string identifying problem
%   - KofXY(nelems,1) = material function k(x,y) evaluated at the 
%                       at the centroid of each element.
%   - BofXY(nelems,1) = material function b(x,y) evaluated at the 
%                       at the centroid of each element.
%   - FofXY(nelems,1) = forcing function f(x,y) evaluated at the 
%                       at the centroid of each element.
%   - boundaryValues = a "Map object" storing the values of the boundary 
%       conditions according to type, which can be accessed by 
%       invoking:
%       - boundaryValues('Dirichlet') ==> returns all Dirichlet 
%           boundary condition values.
%       - boundaryValues('Neumann') ==> returns all Neumann boundary
%           condition values.
%       Note: These values are ordered consistent with the node numbers of
%       boundaryNodes defined in read_2D_mesh.
%
%--------------------------------------------------------------------------

% Open input file

fid = fopen('input.2d');

% Read in mesh name

problemID = fgetl(fid);

% Read in material functions and forcing term values

KofXY = zeros(nElems,1);
BofXY = zeros(nElems,1);
FofXY = zeros(nElems,1);
for j = 1:nElems
    jj = fscanf(fid,'%g',1);
    if (jj~=j)
        fclose('all')
        error('********** Element numbering in input file is not sequential **********')
    end
    KofXY(j) = fscanf(fid,'%g',1);
    BofXY(j) = fscanf(fid,'%g',1);
    FofXY(j) = fscanf(fid,'%g',1);    
end

% Read in boundary condition data

nbc1 = length(boundaryNodes('Dirichlet'));
nbc2 = length(boundaryNodes('Neumann'));
NODEBC1 = boundaryNodes('Dirichlet');
NODEBC2 = boundaryNodes('Neumann');
VBC1 = zeros(nbc1,1);
VBC2 = zeros(nbc2,1);
for i = 1:nbc1
    nbc1_temp = fscanf(fid,'%g',1);    
    if (nbc1_temp ~= NODEBC1(i))
        fclose('all')
        error('********** Your mesh and input file boundary data are not consistent **********')        
    else
        NODEBC1(i) = nbc1_temp;
    end        
    VBC1(i) = fscanf(fid,'%g',1);
end
for i =1:nbc2
    nbc2_temp = fscanf(fid,'%g',1);    
    if (nbc2_temp ~= NODEBC2(i))
        fclose('all')
        error('********** Your mesh and input file boundary data are not consistent **********')        
    else
        NODEBC2(i) = nbc2_temp;
    end   
    VBC2(i) = fscanf(fid,'%g',1);
end

% Create map object to store boundary values

boundaryValues = containers.Map({'Dirichlet','Neumann'},{VBC1, VBC2});

% Close the input file

fclose(fid);

% Clear out superfluous variables

clearvars -except meshName nElems nNodes p MESH boundaryNodes ...
    problemID KofXY BofXY FofXY boundaryValues