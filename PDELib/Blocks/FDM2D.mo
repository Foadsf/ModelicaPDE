within PDELib.Blocks;

model FDM2D "2D Finite Difference Method on a rectangular domain."
  extends PDELib.Interfaces.Discretization2D;

  function laplacian "Calculates the 2D Laplacian using a 5-point stencil."
    input Real u_ij "Value at the current node (i, j)";
    input Real u_im1j "Value at node (i-1, j)";
    input Real u_ip1j "Value at node (i+1, j)";
    input Real u_ijm1 "Value at node (i, j-1)";
    input Real u_ijp1 "Value at node (i, j+1)";
    input Real dx "Spatial step in x-direction";
    input Real dy "Spatial step in y-direction";
    output Real laplacian_u "Approximated Laplacian";
  algorithm
    laplacian_u := (u_ip1j - 2*u_ij + u_im1j) / dx^2 + (u_ijp1 - 2*u_ij + u_ijm1) / dy^2;
  end laplacian;

equation
  // Connect the potential 'u' of the boundary ports to the grid edges.
  // The flow variables 'du_dx' are left unconstrained for the user
  // to define via their boundary condition models.
  for i in 1:Ny loop
    boundary_x_min[i].u = pde[1, i].u;
    boundary_x_max[i].u = pde[Nx, i].u;
  end for;

  for i in 1:Nx loop
    boundary_y_min[i].u = pde[i, 1].u;
    boundary_y_max[i].u = pde[i, Ny].u;
  end for;

end FDM2D;
