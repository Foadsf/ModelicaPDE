model TestPde
  parameter Integer l = 10 "lenght";
  parameter Integer n = 30 "Number of section";
  parameter Real deltax = l / n "section lenght";
  parameter Real C = 1 "diffusion coefficient";

  parameter Real Ts(unit = "s") = 0.01 "time bettween samples";
  discrete Real T[n](start = fill(0, n));
  Real T0 = 0;
equation
  T[1] = T0 "initial condition";
  T[n] = T[n - 1] "limit condition";
  for i in 2:n-1 loop
    when sample(0,Ts) then
      T[n]  = pre(T[i]) + Ts * (C * ( pre(T[i+1]) + pre(T[i-1]) -2*pre(T[i])/ deltax^2));
    end when;
  end for;
end TestPde;
