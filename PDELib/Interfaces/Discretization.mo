within PDELib.Interfaces;

partial model Discretization "Base class for discretization schemes: This model defines the common interface for all discretization schemes."
  replaceable model PDE = PartialPDE "The PDE model to be discretized";

  parameter Integer N "Number of discretization points";
  parameter Real L "Length of the spatial domain";
  parameter Real dx = L/(N-1) "Spatial step";

  // Array of PDE models, one for each discretization point.
  PDE pde[N];

  // Boundary ports
  BoundaryPort boundary1 "Boundary at x=0";
  BoundaryPort boundaryN "Boundary at x=L";

  // The concrete discretization scheme will add equations here
  // to connect the variables in the `pde` array and the boundary ports.

end Discretization;
