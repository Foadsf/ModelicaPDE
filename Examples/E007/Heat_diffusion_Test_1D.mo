package Heat_diffusion_Test_1D
  import SI = Modelica.SIunits;

  model HeatDiffusion1D
    import SI = Modelica.SIunits;
    parameter SI.Length L = 1;
    import Heat_diffusion_Test_1D.Fields.*;
    import Heat_diffusion_Test_1D.Domains.*;
    import Heat_diffusion_Test_1D.FieldDomainOperators1D.*;
    import Heat_diffusion_Test_1D.DifferentialOperators1D.*;
    constant Real PI = Modelica.Constants.pi;
    Domain1D rod(left = 0, right = L, n = 50);
    Field1D u(domain = rod, redeclare type FieldValueType = SI.Temperature, start = array(20 * sin(PI / 2 * x) + 300 for x in rod.x));
  equation
    interior(der(u.val)) = interior(4 * pder(u, x = 2));
    left(u.val) = 20 * sin(PI / 12 * time) + 300;
    right(pder(u, x = 1)) = 0;
    //right(u.val)=320;
    annotation(Icon(coordinateSystem(preserveAspectRatio = false)), Diagram(coordinateSystem(preserveAspectRatio = false)));
  end HeatDiffusion1D;

  package Fields
    record Field1D "Field over a 1D spatial domain"
      replaceable type FieldValueType = Real;
      parameter Domains.Domain1D domain;
      parameter FieldValueType start[domain.n] = zeros(domain.n);
      FieldValueType val[domain.n](start = start);
      annotation(Icon(coordinateSystem(preserveAspectRatio = false)), Diagram(coordinateSystem(preserveAspectRatio = false)));
    end Field1D;
    annotation();
  end Fields;

  package Domains
    import SI = Modelica.SIunits;

    record Domain1D "1D spatial domain"
      parameter SI.Length left = 0.0;
      parameter SI.Length right = 1.0;
      parameter Integer n = 100;
      parameter SI.Length dx = (right - left) / (n - 1);
      parameter SI.Length x[n] = linspace(right, left, n);
      annotation(Icon(coordinateSystem(preserveAspectRatio = false)), Diagram(coordinateSystem(preserveAspectRatio = false)));
    end Domain1D;
    annotation();
  end Domains;

  package FieldDomainOperators1D "Selection operators of field on 1D domain"
    function left "Returns the left value of the field vector v1"
      input Real[:] v1;
      output Real v2;
      annotation(Inline = true);
    algorithm
      v2 := v1[1];
    end left;

    function right "Returns the left value of the field vector v1"
      input Real[:] v1;
      output Real v2;
      annotation(Inline = true);
    algorithm
      v2 := v1[end];
    end right;

    function interior "returns the interior values of the field as a vector"
      input Real v1[:];
      output Real v2[size(v1, 1) - 2];
      annotation(Inline = true);
    algorithm
      v2 := v1[2:end - 1];
    end interior;

  end FieldDomainOperators1D;

  package DifferentialOperators1D "Finite difference differential operators"
    function pder "returns vector of spatial derivative values of a 1D field"
      input Heat_diffusion_Test_1D.Fields.Field1D f;
      input Integer x = 1 "Diff order - first or second order derivative";
      output Real df[size(f.val, 1)];
      annotation(Inline = true);
    algorithm
      df := if x == 1 then SecondOrder.diff1(f.val, f.domain.dx) else SecondOrder.diff2(f.val, f.domain.dx);
    end pder;

    package SecondOrder "Second order polynomial derivative approximations"
      function diff1 "First derivative"
        input Real u[:];
        input Real dx;
        output Real du[size(u, 1)];
        annotation(Inline = true);
      algorithm
        du := cat(1, {((-3 * u[1]) + 4 * u[2] - u[3]) / 2 / dx}, (u[3:end] - u[1:end - 2]) / 2 / dx, {(3 * u[end] - 4 * u[end - 1] + u[end - 2]) / 2 / dx});
      end diff1;

      function diff2
        input Real u[:];
        input Real dx;
        output Real du2[size(u, 1)];
        annotation(Inline = true);
      algorithm
        du2 := cat(1, {(2 * u[1] - 5 * u[2] + 4 * u[3] - u[4]) / dx / dx}, (u[3:end] - 2 * u[2:end - 1] + u[1:end - 2]) / dx / dx, {(2 * u[end] - 5 * u[end - 1] + 4 * u[end - 2] - u[end - 3]) / dx / dx});
      end diff2;
      annotation();
    end SecondOrder;

    package FirstOrder "First order polynomial derivative approximations"
      function diff1 "First derivative"
        input Real u[:];
        input Real dx;
        output Real du[size(u, 1)];
        annotation(Inline = true);
      algorithm
        // Left, central and right differences
        du := cat(1, {(u[2] - u[1]) / dx}, (u[3:end] - u[1:end - 2]) / 2 / dx, {(u[end] - u[end - 1]) / dx});
      end diff1;
      annotation();
    end FirstOrder;
    annotation();

  end DifferentialOperators1D;
  annotation(uses(Modelica(version = "3.2.1")));
end Heat_diffusion_Test_1D;
