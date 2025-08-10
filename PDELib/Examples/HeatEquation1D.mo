within PDELib.Examples;

model HeatEquation1D "1D Heat Equation solved with PDELib"
  extends PDELib.Blocks.FDM1D(
    redeclare model PDE = HeatPDE,
    L=1, N=10
  );

  parameter Real rho = 1 "Material density";
  parameter Real Cp = 1 "Specific heat capacity";
  parameter Real k = 1 "Heat conduction coefficient";
  parameter Real alpha = k / (rho*Cp) "Thermal diffusivity";

  parameter Real Tlo = 273.15 "Cold-end temperature";
  parameter Real Thi = 373.15 "Hot-end temperature";

  PDELib.Blocks.Dirichlet bc1(u0 = Thi);
  PDELib.Blocks.Dirichlet bc2(u0 = Tlo);

equation
  // Connect boundary conditions
  connect(bc1.port, boundary1);
  connect(bc2.port, boundaryN);

  // Heat equation for interior nodes
  for i in 2:N-1 loop
    der(pde[i].T) = alpha * d2_dx2(pde[i-1].T, pde[i].T, pde[i+1].T, dx);
  end for;

  // For the boundary nodes, the temperature is fixed by the Dirichlet BCs,
  // so their time derivatives are zero.
  der(pde[1].T) = 0;
  der(pde[N].T) = 0;

end HeatEquation1D;
