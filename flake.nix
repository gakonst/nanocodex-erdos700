{
  description = "Reproducible AI-assisted mathematics environment for nanocodex-erdos";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      toolsets =
        pkgs:
        let
          python = pkgs.python3.withPackages (
            ps: with ps; [
              cvxpy
              hypothesis
              jupyterlab
              ps."lrcalc-python"
              matplotlib
              mpmath
              networkx
              numpy
              pandas
              pulp
              pytest
              scipy
              sympy
              z3-solver
            ]
          );
          environmentReport = pkgs.writeShellApplication {
            name = "math-env-report";
            runtimeInputs = [ pkgs.jq ];
            text = ''
              commands=(
                rustc cargo lean lake python jupyter
                z3 cvc5 highs glpsol cbc minizinc cadical kissat
                gap gp Singular maxima sage coqc isabelle vampire eprover
              )

              report='[]'
              for program in "''${commands[@]}"; do
                if path=$(command -v "$program" 2>/dev/null); then
                  version=$(
                    "$program" --version </dev/null 2>&1 \
                      | head -n 1 \
                      || true
                  )
                  report=$(jq \
                    --arg program "$program" \
                    --arg path "$path" \
                    --arg version "$version" \
                    '. + [{program: $program, path: $path, version: $version}]' \
                    <<<"$report")
                fi
              done
              jq . <<<"$report"
            '';
          };
          base = with pkgs; [
            cargo
            cargo-nextest
            clang
            clippy
            cmake
            curl
            direnv
            fd
            gh
            git
            hyperfine
            jq
            just
            ninja
            openssl
            parallel
            pkg-config
            ripgrep
            rust-analyzer
            rustc
            rustfmt
            shellcheck
            uv
            w3m
          ];
          proofAndSolver = with pkgs; [
            cadical
            cbc
            cvc5
            flint
            glpk
            highs
            kissat
            lean4
            minizinc
            z3
          ];
          computationalMath = with pkgs; [
            gap
            gnuplot
            graphviz
            nauty
            maxima
            pari
            singular
          ];
          formalExtras = with pkgs; [
            boolector
            coq
            eprover
            isabelle
            vampire
            yices
          ];
          lrExtras =
            with pkgs;
            [
              latte-integrale
              normaliz
              sage.passthru."with-env"
            ]
            ++ lib.optionals stdenv.isLinux [ polymake ];
          default =
            base
            ++ proofAndSolver
            ++ computationalMath
            ++ [
              python
              environmentReport
            ];
          formal =
            base
            ++ proofAndSolver
            ++ formalExtras
            ++ [
              python
              environmentReport
            ];
          lr =
            base
            ++ proofAndSolver
            ++ computationalMath
            ++ [
              python
            ]
            ++ lrExtras
            ++ [ environmentReport ];
          full = default ++ formalExtras ++ lrExtras;
        in
        {
          inherit
            default
            environmentReport
            formal
            full
            lr
            ;
        };
      packageEnvironment =
        pkgs: name: paths:
        pkgs.buildEnv {
          inherit name paths;
          ignoreCollisions = true;
        };
      developmentShell =
        pkgs: name: packages:
        pkgs.mkShell {
          inherit packages;
          NANOCODEX_MATH_ENV = name;
          PYTHONNOUSERSITE = "1";
          RUST_BACKTRACE = "1";
          shellHook = ''
            echo "nanocodex-erdos ${name} environment"
            echo "Run 'math-env-report' to capture tool paths and versions."
          '';
        };
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          tools = toolsets pkgs;
        in
        {
          default = packageEnvironment pkgs "nanocodex-erdos-tools" tools.default;
          formal = packageEnvironment pkgs "nanocodex-erdos-formal-tools" tools.formal;
          full = packageEnvironment pkgs "nanocodex-erdos-full-tools" tools.full;
          lr = packageEnvironment pkgs "nanocodex-erdos-lr-tools" tools.lr;
          env-report = tools.environmentReport;
        }
      );

      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          tools = toolsets pkgs;
        in
        {
          default = developmentShell pkgs "default" tools.default;
          formal = developmentShell pkgs "formal" tools.formal;
          full = developmentShell pkgs "full" tools.full;
          lr = developmentShell pkgs "lr" tools.lr;
        }
      );

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt);
    };
}
