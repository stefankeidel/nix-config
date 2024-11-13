{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }:
    let
      pkgs = import nixpkgs { system = "aarch64-darwin"; };
      # A list of shell names and their Python versions
      pythonVersions = {
        python39 = pkgs.python39;
        python310 = pkgs.python310;
        python311 = pkgs.python311;
        python312 = pkgs.python312;
        python313 = pkgs.python313;
        default = pkgs.python312;
      };
      # A function to make a shell with a python version
      makePythonShell = shellName: pythonPackage: pkgs.mkShell {
        # You could add extra packages you need here too
        packages = [
          pythonPackage
          pkgs.poetry
        ]; 
        # You can also add commands that run on shell startup with shellHook
        shellHook = ''
          # Ensure credentials are set if needed
          if [ -z "$LICHTBLICKARTIFACTORY_USER" ] || [ -z "$LICHTBLICKARTIFACTORY_SECRET" ]; then
            echo "Error: Please set LICHTBLICKARTIFACTORY_USER and LICHTBLICKARTIFACTORY_SECRET environment variables."
            return 1
          fi

          # use nix python
          poetry env use $(which python)

          # Configure Poetry with private registry credentials
          poetry config http-basic.lichtblickartifactory_pypi $LICHTBLICKARTIFACTORY_USER $LICHTBLICKARTIFACTORY_SECRET
          # install locally
          poetry config virtualenvs.in-project true

          # Install dependencies
          poetry install --with dev
        '';
      };
    in
    {
      # mapAttrs runs the given function (makePythonShell) against every value
      # in the attribute set (pythonVersions) and returns a new set
      devShells.aarch64-darwin = builtins.mapAttrs makePythonShell pythonVersions;
    };
}
