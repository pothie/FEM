%%--------------------------------------------------------------------------
%
%  read_1D_mesh.m
%  ------------
%
%  Reads in a finite element mesh file (mesh.1d).
%
%  The following variables are also assigned in this script:
%
%   - meshName = character string of mesh name.
%   - nElems = total number of elements in the mesh.
%   - nNodes = total number of nodes in the mesh. 
%   - p = polynomial degree of elements.
%   - MESH = a structure storing the FEM mesh with two fields:
%       - MESH.Points = an array of size nNodes × 1, where row i stores the
%               x coordinates of node i.
%       - MESH.ConnectivityList = an array of size nElems × 2, where row i
%               stores the the node numbers of the two end-point nodes that 
%               are "connected" to form element i. 
%   - boundaryNodes = a "Map object" storing the boundary node numbers
%     according to type, which can be accessed by invoking:
%       - boundaryNodes('Dirichlet') ==> returns all Dirichlet boundary
%               node numbers.
%       - boundaryNodes('Neumann') ==> returns all Neumann boundary node
%               numbers.
%
%--------------------------------------------------------------------------

%% Open mesh file

fid = fopen('mesh.1d');

% Read in mesh name

meshName = fgetl(fid);

% Read in number of elements and number of nodes

nElems = fscanf(fid,'%g',1);
nNodes = fscanf(fid,'%g',1);

% Compute the degree of polynomial

p = (nNodes-1)/nElems;

% Read in element end-point coordinates and generate internal element nodes
% (for p > 1 elements)

MESH.Points = zeros(nNodes,1);
ii = fscanf(fid,'%g',1);
MESH.Points(ii) = fscanf(fid,'%g',1);
for i = 1:nElems  
    jj = fscanf(fid,'%g',1);
    if ((ii + p)~=jj)
        fclose('all');
        error('********** Node numbering in mesh file is not sequential **********')
    else
        MESH.Points(ii+p) = fscanf(fid,'%g',1); 
        for j = 1:p-1
            MESH.Points(ii+j) = MESH.Points(ii) + ...
                j/p*(MESH.Points(ii+p)-MESH.Points(ii));
        end  
        ii = ii + p;        
    end
end

% Read in element connectivity table

MESH.ConnectivityList = zeros(nElems,2);
for j = 1:nElems
    jj = fscanf(fid,'%g',1);
    if (jj~=j)
        fclose('all');
        error('********** Element numbering in mesh file is not sequential **********')
    end
    MESH.ConnectivityList(j,1:2) = fscanf(fid,'%g %g',[1 2]);
end

% Read in the Dirichlet (type 1) boundary condition data

nbc1 = fscanf(fid,'%g',1);
if ( nbc1<0 | nbc1>2 )
    fclose('all')
    error('********** Number of boundary nodes must be 0, 1, or 2 **********')    
end
NODEBC1 = zeros(nbc1,1);
for i = 1:nbc1 
    NODEBC1(i) = fscanf(fid,'%g',1);    
end

% Read in the Neumann (type 2) boundary condition data

nbc2 = fscanf(fid,'%g',1);
if ( (nbc1+nbc2)~=2 )
    fclose('all')
    error('********** Total number of boundary nodes must equal 2 **********')    
end
NODEBC2 = zeros(nbc2,1);
for i = 1:nbc2
    NODEBC2(i) = fscanf(fid,'%g',1);
end

% Create map object to store boundary nodes

boundaryNodes = containers.Map({'Dirichlet','Neumann'},{NODEBC1, NODEBC2});

% Close the mesh file

fclose(fid);

% Clear out superfluous variables

clearvars -except meshName nElems nNodes p MESH boundaryNodes