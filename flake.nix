{
  description = "A Nix-flake-based development environment";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  outputs =
    inputs:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forEachSupportedSystem =
        f:
        inputs.nixpkgs.lib.genAttrs supportedSystems (
          system: f { pkgs = import inputs.nixpkgs { inherit system; }; }
        );
    in
    {
      devShells = forEachSupportedSystem (
        { pkgs }:
        {
          default = pkgs.mkShell {
            # The Nix packages provided in the environment.
            packages = with pkgs; [
              azure-cli # azure cli
              opentofu # infrastructure as code
              typos # check misspelling
              git-cliff # generate changelog
              trivy # find vulnerabilities and misconfigurations
              just # just a command runner
            ];
          };
        }
      );
    };
}
