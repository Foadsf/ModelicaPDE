model HeatTransfer "One Dimensional Heat Transfer"
  import Modelica.SIunits;
  //Configuration parameters
  parameter Integer n = 100 "Number of Nodes";
  parameter SIunits.Density rho = 1 "Material Density";
  parameter SIunits.HeatCapacity c_p = 1;
  parameter SIunits.ThermalConductivity k = 1;
  parameter SIunits.Length L = 10 "Domain Length";
  //Temperature Array
  SIunits.Temp_K T_array[n](start = fill(300, n)) "Nodal Temperatures";
  //variabes
  Real x_array[n];
  Real x;
  Real T;
protected
  // Computed parameters
  parameter SIunits.Length dx = L / n "Distance between nodes";
equation
  // Loop over interior nodes
  for i in 2:n - 1 loop
    x_array[i] = i * dx;
    rho * c_p * der(T_array[i]) = k * (T_array[i + 1] - 2 * T_array[i] + T_array[i - 1]) / dx ^ 2;
  end for;
  // Boundary Conditions
  x_array[1] = 0;
  x_array[n] = L;
  T_array[1] = 1000;
  T_array[n] = 300;
  //array2time
  x = array2time(x_array, time);
  T = array2time(T_array, time);
end HeatTransfer;
