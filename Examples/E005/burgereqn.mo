model burgereqn
  Real u[N + 2](start = u0);
  parameter Real h = 1 / (N + 1);
  parameter Integer N = 10;
  parameter Real v = 234;
  parameter Real Pi = 3.14159265358979;
  parameter Real u0[N + 2] = array(sin(2 * Pi * x[i]) + 0.5 * sin(Pi * x[i]) for i in 1:N + 2);
  parameter Real x[N + 2] = array(h * i for i in 1:N + 2);
equation
  der(u[1]) = 0;
  for i in 2:N + 1 loop
    der(u[i]) = (-(u[i + 1] ^ 2 - u[i - 1] ^ 2) / (4 * (x[i + 1] - x[i - 1]))) + v / (x[i + 1] - x[i - 1]) ^ 2 * (u[i + 1] - 2 * u[i] + u[i + 1]);
  end for;
  der(u[N + 2]) = 0;
end burgereqn;
