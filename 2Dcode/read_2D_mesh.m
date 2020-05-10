%%--------------------------------------------------------------------------
%
%  read_2D_mesh.m
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
%       - MESH.Points = an array of size nNodes × 2, where row i stores the
%               x and y coordinates (in columns 1 and 2, respectively) of 
%               node i.
%       - MESH.ConnectivityList = an array of size nElems × 3, where row i
%               stores the the node numbers of the vertex nodes that are 
%               "connected" to form element i. 
%     Note: The MESH data structure is saved as a Matlab "triangulation 
%           object"; see help triangulation and the references therein for
%           more details.
%   - boundaryNodes = a "Map object" storing the boundary node numbers
%     according to type, which can be accessed by invoking:
%       - boundaryNodes('Dirichlet') ==> returns all Dirichlet boundary
%               node numbers.
%       - boundaryNodes('Neumann') ==> returns all Neumann boundary node
%               numbers.
%
%--------------------------------------------------------------------------

% Open mesh file

fid = fopen('mesh.2d');

% Read in mesh name

meshName = fgetl(fid);

% Read in number of elements and number of (end-point) nodes

nElems = fscanf(fid,'%g',1);
nNodes = fscanf(fid,'%g',1);

% Set the degree of polynomial (currently hard-wired for linear elements)

p = 1;

% Read in nodal coordinates

MESH.Points = zeros(nNodes,2);
Z = zeros(nNodes,1);
for i = 1:nNodes
    ii    = fscanf(fid,'%g',1);
    if (ii~=i)
        fclose('all')
        error('********** Node numbering in mesh file is not sequential **********')
    end
    MESH.Points(ii,1) = fscanf(fid,'%g',1);
    MESH.Points(ii,2) = fscanf(fid,'%g',1);
    Z(i) = fscanf(fid,'%g',1);
end

% Read in element connectivity table

MESH.ConnectivityList = zeros(nElems,3);
for j = 1:nElems
    jj = fscanf(fid,'%g',1);
    if (jj~=j)
        fclose('all')
        error('********** Element numbering in mesh file is not sequential **********')
    end
    n = fscanf(fid,'%g',1);
    for i = 1:n
        MESH.ConnectivityList(j,i) = fscanf(fid,'%g',1);
    end
end

% Read in the Dirichlet (type 1) boundary condition data

nbc1 = fscanf(fid,'%g',1);
NODEBC1 = zeros(nbc1,1);
for i = 1:nbc1
    NODEBC1(i) = fscanf(fid,'%g',1);        
end

% Read in the Neumann (type 2) boundary condition data

nbc2 = fscanf(fid,'%g',1);
NODEBC2 = zeros(nbc2,1);
for i = 1:nbc2
    NODEBC2(i) = fscanf(fid,'%g',1);        
end

% Create map object to store boundary nodes

boundaryNodes = containers.Map({'Dirichlet','Neumann'},{NODEBC1, NODEBC2});

% Create triagnulation object to store MESH

MESH = triangulation(MESH.ConnectivityList,MESH.Points);

% Close the mesh file

fclose(fid);

% Clear out superfluous variables

clearvars -except meshName nElems nNodes p MESH boundaryNodes