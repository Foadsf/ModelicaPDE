within PDELib.Examples;

model HeatEquation2D "2D Heat Equation on a square domain with Dirichlet boundaries."
  extends PDELib.Blocks.FDM2D(
    redeclare model PDE = HeatPDE,
    Lx=1, Ly=1, Nx=10, Ny=10
  );

  parameter Real rho = 1 "Material density";
  parameter Real Cp = 1 "Specific heat capacity";
  parameter Real k = 1 "Heat conduction coefficient";
  parameter Real alpha = k / (rho*Cp) "Thermal diffusivity";

  parameter Real T_cold = 273.15 "Cold temperature for boundaries";
  parameter Real T_hot = 373.15 "Hot temperature for one boundary";

  // Arrays of Dirichlet blocks for each boundary
  PDELib.Blocks.Dirichlet boundary_conditions_x_min[Ny](each u0 = T_cold);
  PDELib.Blocks.Dirichlet boundary_conditions_x_max[Ny](each u0 = T_cold);
  PDELib.Blocks.Dirichlet boundary_conditions_y_min[Nx](each u0 = T_cold);
  PDELib.Blocks.Dirichlet boundary_conditions_y_max[Nx](each u0 = T_hot);

equation
  // Connect boundary conditions
  // x-boundaries (vertical edges)
  for i in 1:Ny loop
    connect(boundary_conditions_x_min[i].port, boundary_x_min[i]);
    connect(boundary_conditions_x_max[i].port, boundary_x_max[i]);
  end for;
  // y-boundaries (horizontal edges), excluding corners to avoid over-determining them
  for i in 2:Nx-1 loop
    connect(boundary_conditions_y_min[i].port, boundary_y_min[i]);
    connect(boundary_conditions_y_max[i].port, boundary_y_max[i]);
  end for;

  // Heat equation for interior nodes
  for i in 2:Nx-1 loop
    for j in 2:Ny-1 loop
      der(pde[i,j].T) = alpha * laplacian(pde[i,j].T, pde[i-1,j].T, pde[i+1,j].T, pde[i,j-1].T, pde[i,j+1].T, dx, dy);
    end for;
  end for;

  // Set time derivatives of boundary nodes to zero
  for i in 1:Ny loop
    der(pde[1, i].T) = 0;
    der(pde[Nx, i].T) = 0;
  end for;
  for i in 2:Nx-1 loop // Avoid double-counting corners
    der(pde[i, 1].T) = 0;
    der(pde[i, Ny].T) = 0;
  end for;

end HeatEquation2D;
