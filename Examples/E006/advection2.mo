model advection2
  parameter Real L = 1;
  parameter Integer N = 100;
  parameter Real dx = L / (N - 1);
  //parameter Real[N] x = array(i * dx for i in 0:N - 1);
  parameter Real c = 1;
  Real u[N], ux[N];
initial equation
  for i in 1:N loop
    u[i] = 0;
  end for;
equation

  if c>0 then
    u[N] = time ^ 2;
    ux[N] = 0;
    for i in 1:N-1 loop
      u[i] = u[i + 1] - dx * ux[i];
      der(u[i]) = c*ux[i];
    end for;
  else
    u[1] = time ^ 2;
    ux[1] = 0;
    for i in 2:N loop
      u[i] = u[i - 1] + dx * ux[i];
      der(u[i]) = c*ux[i];
    end for;
  end if;
end advection2;
