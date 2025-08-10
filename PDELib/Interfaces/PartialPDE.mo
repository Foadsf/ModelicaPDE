within PDELib.Interfaces;

partial model PartialPDE "Base model for a PDE"
  // This model represents the variables at a single point in space.
  // It should be extended by concrete PDE models.
  // For example, for the heat equation, it would contain the temperature.
  // For a system of PDEs, it would contain multiple variables.

  // As a placeholder, we define a single variable 'u'.
  Real u "The dependent variable";

end PartialPDE;
