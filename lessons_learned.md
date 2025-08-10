# Lessons Learned: Debugging a Modelica Library with OMC

This document summarizes the key lessons learned during the development and testing of the `PDELib` library using the OpenModelica Compiler (`omc`) in a command-line environment. The process involved significant debugging and revealed several subtleties about the OpenModelica ecosystem and the Modelica language itself.

## 1. Environment Setup for `omc` on Ubuntu

Setting up a working `omc` environment on a modern Ubuntu system (like 24.04 "Noble Numbat") from the command line is non-trivial.

*   **APT Repository Configuration is Critical:** The most robust method for adding the OpenModelica APT repository is to use `lsb_release -cs` to automatically detect the OS codename. Hardcoding a version name (e.g., `jammy`) can lead to dependency conflicts if the OS version is different, as was seen when the `jammy` packages required `libomniorb4-2`, which is not available on `noble`.
    ```bash
    # Correct command for adding the repository
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/openmodelica-keyring.gpg] https://build.openmodelica.org/apt $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/openmodelica.list
    ```

*   **Minimal Installation:** For headless/CI environments, `sudo apt install omc` is sufficient and preferable to installing the full `openmodelica` suite.

## 2. `omc` Scripting Best Practices

Automating `omc` with `.mos` scripts requires understanding its execution model.

*   **Command-Line Pre-loading is Essential:** The most critical lesson was the difference between `loadModel()` inside a script and providing a library as a command-line argument. To make a library's contents available to the parser for another library (`loadFile`), the dependency must be loaded *before* the script starts.
    ```bash
    # Correct way to test PDELib, which depends on Modelica
    omc test.mos Modelica
    ```
    Simply calling `loadModel(Modelica)` inside `test.mos` is not enough, as the parser context for the subsequent `loadFile("PDELib/package.mo")` does not include the session-loaded MSL.

*   **Explicitly Install MSL in Minimal Environments:** The base `omc` package does not guarantee that the Modelica Standard Library (MSL) is installed. A script may need to run `installPackage(Modelica)` on its first execution to download and set up the MSL.

*   **Robust Error Checking:** The `omc` scripting language can have subtle error reporting. Simply checking `getErrorString() <> ""` is not always reliable. It is better to check the boolean return status of functions like `loadModel()` and `installPackage()`.
    ```modelica
    success := loadModel(Modelica);
    if not success then
      print("Error: " + getErrorString());
      exit(1);
    end if;
    ```

## 3. Modelica Language and Library Design Subtleties

Several issues were traced back to specific rules of the Modelica language.

*   **MSL Versioning is a Major Factor:** The breaking change between MSL 3.x and 4.x, where `Modelica.SIunits` was moved to `Modelica.Units.SI`, was the root cause of the persistent `Class not found` error. Code written against one version may not work with another.

*   **The `uses` Annotation is Best Practice:** Explicitly declaring dependencies in the top-level `package.mo` file is crucial for portability and helps tools manage dependencies correctly. This also provides helpful notifications from the compiler if a different version is used.
    ```modelica
    package PDELib
      annotation(uses(Modelica(version="4.0.0")));
    end PDELib;
    ```

*   **Strict File and Class Structure:**
    *   A `.mo` file intended as part of a library should contain **only one** top-level class definition.
    *   `import` statements must be placed **inside** a `package` or `model`, not at the top level of the file alongside the `within` clause.
    *   A class definition can only have **one** primary documentation string immediately following its name.

*   **Component Design and Over-determination:** The final "over-determined system" error highlighted the difficulty of creating one-size-fits-all components. The `FDM1D` model had conflicting requirements for handling Dirichlet vs. Neumann boundary conditions. The original implementation, which defined the boundary flux, worked for the Dirichlet case but conflicted with the logic for the Neumann case. Removing it fixed the Neumann case but broke the Dirichlet case. This indicates that a more sophisticated design (e.g., using replaceable models for boundary equations or conditional logic) is needed for a truly general component.
