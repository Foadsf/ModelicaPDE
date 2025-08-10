within PDELib.Examples;

model HeatEquation1D_Neumann "1D Heat Equation with one Dirichlet and one Neumann boundary"
  extends PDELib.Blocks.FDM1D(
    redeclare model PDE = HeatPDE,
    L=1, N=10
  );

  parameter Real rho = 1 "Material density";
  parameter Real Cp = 1 "Specific heat capacity";
  parameter Real k = 1 "Heat conduction coefficient";
  parameter Real alpha = k / (rho*Cp) "Thermal diffusivity";

  parameter Real Thi = 373.15 "Hot-end temperature";

  PDELib.Blocks.Dirichlet bc1(u0 = Thi);
  PDELib.Blocks.Neumann bc2(du_dx0 = 0); // Insulated end

equation
  // Connect boundary conditions
  connect(bc1.port, boundary1);
  connect(bc2.port, boundaryN);

  // Heat equation for interior nodes
  for i in 2:N-1 loop
    der(pde[i].T) = alpha * d2_dx2(pde[i-1].T, pde[i].T, pde[i+1].T, dx);
  end for;

  // For the boundary node 1, the temperature is fixed.
  der(pde[1].T) = 0;

  // For the boundary node N, we apply the heat equation using the special
  // function for the second derivative at the boundary.
  der(pde[N].T) = alpha * d2_dx2_right_bnd(pde[N-1].T, pde[N].T, bc2.du_dx0, dx);

end HeatEquation1D_Neumann;
