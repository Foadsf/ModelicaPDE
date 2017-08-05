model Coduction1D

  parameter Real rho =1; //Material density
  parameter Real Cp=1; // specific heat capacity of the material
  parameter Real L=1; // Length of the rod
  parameter Real k=1; // heat conduction coefficient
  parameter Real Tlo=0; //cold-end tempreture
  parameter Real Thi=100; //hot-end tempreture
  parameter Real Tinit =30; // rod's initial tempreture
  parameter Integer N=10; // Number of segments
  parameter Real deltaX =L/N; // discritization length

  Real T[N-1]; // state variables representing rod temreture


initial equation

  for i in 1:N-1 loop
    T[i]=Tinit;
  end for;

equation

  rho*Cp*der(T[1])=k*(T[2]-2*T[1]+Thi)/(deltaX^2);
  rho*Cp*der(T[N-1])=k*(Tlo-2*T[N-1]+T[N-2])/(deltaX^2);

  for i in 2:N-2 loop
      rho*Cp*der(T[i])=k*(T[i+1]-2*T[i]+T[i-1])/(deltaX^2);
  end for;

end Coduction1D;
