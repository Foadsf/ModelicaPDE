within PDELib.Blocks;

model Dirichlet "Dirichlet boundary condition: Sets the value of the variable u at the boundary."
  parameter Real u0 = 0 "Value of u at the boundary";
  PDELib.Interfaces.BoundaryPort port;

equation
  port.u = u0;

end Dirichlet;
