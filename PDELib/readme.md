# PDELib: A Modelica Library for Partial Differential Equations

`PDELib` is a Modelica library for solving partial differential equations (PDEs) using the method of lines. It provides a structured framework for discretizing and solving 1D PDEs within the Modelica environment.

## Getting Started

To get started with `PDELib`, let's solve a simple 1D heat equation: `der(T) = alpha * d2T/dx2`.

The full source code for this example can be found in `PDELib.Examples.HeatEquation1D`.

### 1. Define the PDE

First, we define a model for our PDE by extending `PDELib.Interfaces.PartialPDE`. We rename the variable `u` to `T` for clarity.

```modelica
within PDELib.Examples;

model HeatPDE "PDE model for 1D heat equation"
  extends PDELib.Interfaces.PartialPDE(u(unit="K", start=300));
  Modelica.SIunits.Temperature T = u;
end HeatPDE;
```

### 2. Create the main model

Next, we create the main model that will solve the PDE. This model extends `PDELib.Blocks.FDM1D`, which provides the 1D finite difference discretization.

We redeclare the `PDE` model to be our `HeatPDE`, and we set the physical parameters of the problem.

```modelica
model HeatEquation1D "1D Heat Equation solved with PDELib"
  extends PDELib.Blocks.FDM1D(
    redeclare model PDE = HeatPDE,
    L=1, N=10
  );

  parameter Real rho = 1 "Material density";
  parameter Real Cp = 1 "Specific heat capacity";
  parameter Real k = 1 "Heat conduction coefficient";
  parameter Real alpha = k / (rho*Cp) "Thermal diffusivity";
  ...
end HeatEquation1D;
```

### 3. Add boundary conditions

We use the `PDELib.Blocks.Dirichlet` component to define the boundary conditions. We create two instances of this component and connect them to the `boundary1` and `boundaryN` ports of the `FDM1D` model.

```modelica
  ...
  parameter Real Tlo = 273.15 "Cold-end temperature";
  parameter Real Thi = 373.15 "Hot-end temperature";

  PDELib.Blocks.Dirichlet bc1(u0 = Thi);
  PDELib.Blocks.Dirichlet bc2(u0 = Tlo);

equation
  // Connect boundary conditions
  connect(bc1.port, boundary1);
  connect(bc2.port, boundaryN);
  ...
end HeatEquation1D;
```

### 4. Write the PDE equation

Finally, we write the discretized PDE for the interior nodes. We use the `d2_dx2` function from the `FDM1D` model to approximate the second derivative. We also set the derivatives of the boundary nodes to zero, as their temperatures are fixed by the Dirichlet conditions.

```modelica
  ...
  // Heat equation for interior nodes
  for i in 2:N-1 loop
    der(pde[i].T) = alpha * d2_dx2(pde[i-1].T, pde[i].T, pde[i+1].T, dx);
  end for;

  // For the boundary nodes, the temperature is fixed by the Dirichlet BCs,
  // so their time derivatives are zero.
  der(pde[1].T) = 0;
  der(pde[N].T) = 0;

end HeatEquation1D;
```

This example shows the basic workflow for using `PDELib`. You can find more examples in the `PDELib.Examples` package, including how to use Neumann boundary conditions.

## Library Architecture

The library is organized into three main packages: `Interfaces`, `Blocks`, and `Examples`.

### `Interfaces`

This package contains the base classes and connectors that define the architecture of the library.

*   `PartialPDE`: The base model for all PDE definitions.
*   `Discretization`: The base model for all discretization schemes.
*   `BoundaryPort`: The connector used for applying boundary conditions.

### `Blocks`

This package contains the concrete, reusable components of the library.

*   `FDM1D`: A 1D finite difference discretization scheme.
*   `Dirichlet`: A component for defining Dirichlet boundary conditions.
*   `Neumann`: A component for defining Neumann boundary conditions.

## How to...

### ... define a new PDE?

Extend `PDELib.Interfaces.PartialPDE` and add the variables for your PDE.

### ... use a different discretization?

Extend `PDELib.Interfaces.Discretization` and implement the equations for your scheme.

### ... add a new type of boundary condition?

Create a new model with a `BoundaryPort` connector and the equations for your boundary condition.

## Future Work

`PDELib` is still in its early stages of development. Here are some ideas for future extensions:

*   **2D and 3D Problems:** Extend the library to support 2D and 3D spatial domains. This would involve creating new discretization blocks and interfaces for higher dimensions.
*   **More Discretization Schemes:** Implement other discretization methods, such as the Finite Volume Method (FVM) or the Finite Element Method (FEM).
*   **Advanced Boundary Conditions:** Add support for more complex boundary conditions, such as Robin boundary conditions, or time-dependent and non-linear conditions.
*   **Coupled Systems of PDEs:** Extend the `PartialPDE` interface to handle multiple dependent variables, allowing for the solution of coupled systems of PDEs.
*   **Improved Usability:** Develop a graphical user interface or a set of helper tools to simplify the process of building and simulating PDE models.
