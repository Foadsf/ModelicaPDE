within PDELib.Blocks;

model FDM1D "1D Finite Difference Method: This model provides functions to discretize a 1D PDE using the finite difference method."
  extends PDELib.Interfaces.Discretization;

  function d_dx "Calculates the first derivative using a central difference scheme."
    input Real u_prev "Value at the previous node";
    input Real u_next "Value at the next node";
    input Real dx "Spatial step";
    output Real du_dx "Approximated first derivative";
  algorithm
    du_dx := (u_next - u_prev) / (2*dx);
  end d_dx;

  function d2_dx2 "Calculates the second derivative using a central difference scheme."
    input Real u_prev "Value at the previous node";
    input Real u_curr "Value at the current node";
    input Real u_next "Value at the next node";
    input Real dx "Spatial step";
    output Real d2u_dx2 "Approximated second derivative";
  algorithm
    d2u_dx2 := (u_next - 2*u_curr + u_prev) / (dx^2);
  end d2_dx2;

  function d_dx_forward "Calculates the first derivative using a forward difference scheme."
    input Real u_curr "Value at the current node";
    input Real u_next "Value at the next node";
    input Real dx "Spatial step";
    output Real du_dx "Approximated first derivative";
  algorithm
    du_dx := (u_next - u_curr) / dx;
  end d_dx_forward;

  function d_dx_backward "Calculates the first derivative using a backward difference scheme."
    input Real u_prev "Value at the previous node";
    input Real u_curr "Value at the current node";
    input Real dx "Spatial step";
    output Real du_dx "Approximated first derivative";
  algorithm
    du_dx := (u_curr - u_prev) / dx;
  end d_dx_backward;

  function d2_dx2_left_bnd "Calculates the second derivative at the left boundary"
    input Real u_curr "Value at the current node";
    input Real u_next "Value at the next node";
    input Real du_dx_bnd "Derivative at the boundary";
    input Real dx "Spatial step";
    output Real d2u_dx2 "Approximated second derivative";
  algorithm
    d2u_dx2 := 2*(u_next - u_curr - du_dx_bnd*dx) / dx^2;
  end d2_dx2_left_bnd;

  function d2_dx2_right_bnd "Calculates the second derivative at the right boundary"
    input Real u_prev "Value at the previous node";
    input Real u_curr "Value at the current node";
    input Real du_dx_bnd "Derivative at the boundary";
    input Real dx "Spatial step";
    output Real d2u_dx2 "Approximated second derivative";
  algorithm
    d2u_dx2 := 2*(u_prev - u_curr + du_dx_bnd*dx) / dx^2;
  end d2_dx2_right_bnd;

equation
  // Connect the boundary ports to the grid
  boundary1.u = pde[1].u;
  boundaryN.u = pde[N].u;

  // The du_dx flow from the boundary port is the negative of the derivative
  // at the boundary, because the normal vector points out of the domain.
  -boundary1.du_dx = (pde[2].u - pde[1].u) / dx; // Forward difference
  boundaryN.du_dx = (pde[N].u - pde[N-1].u) / dx; // Backward difference

end FDM1D;
