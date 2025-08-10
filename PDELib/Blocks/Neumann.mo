within PDELib.Blocks;

model Neumann "Neumann boundary condition: Sets the value of the derivative du_dx at the boundary."
  parameter Real du_dx0 = 0 "Value of du_dx at the boundary";
  PDELib.Interfaces.BoundaryPort port;

equation
  port.du_dx = du_dx0;

end Neumann;
