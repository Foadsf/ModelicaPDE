within PDELib.Interfaces;

connector BoundaryPort "Connector for 1D boundary conditions: This connector is used to define boundary conditions for 1D problems."
  Real u "Value of the variable at the boundary";
  flow Real du_dx "Spatial derivative of the variable at the boundary (normal pointing out of the domain)";

end BoundaryPort;
