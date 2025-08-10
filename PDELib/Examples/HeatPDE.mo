within PDELib.Examples;

model HeatPDE "PDE model for 1D heat equation"
  extends PDELib.Interfaces.PartialPDE(u(unit="K", start=300));
  Modelica.Units.SI.Temperature T = u;
end HeatPDE;
