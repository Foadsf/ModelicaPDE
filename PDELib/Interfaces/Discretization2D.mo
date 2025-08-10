within PDELib.Interfaces;

partial model Discretization2D "Base class for 2D discretization schemes on a rectangular domain"

  replaceable model PDE = PartialPDE "The PDE model to be discretized";

  parameter Real Lx "Length of the spatial domain in x-direction";
  parameter Real Ly "Length of the spatial domain in y-direction";
  parameter Integer Nx "Number of discretization points in x-direction";
  parameter Integer Ny "Number of discretization points in y-direction";

  parameter Real dx = Lx/(Nx-1) "Spatial step in x-direction";
  parameter Real dy = Ly/(Ny-1) "Spatial step in y-direction";

  // 2D array of PDE models, one for each discretization point.
  PDE pde[Nx, Ny];

  // Boundary port arrays for each of the four boundaries
  BoundaryPort boundary_x_min[Ny] "Boundary at x = 0";
  BoundaryPort boundary_x_max[Ny] "Boundary at x = Lx";
  BoundaryPort boundary_y_min[Nx] "Boundary at y = 0";
  BoundaryPort boundary_y_max[Nx] "Boundary at y = Ly";

end Discretization2D;
