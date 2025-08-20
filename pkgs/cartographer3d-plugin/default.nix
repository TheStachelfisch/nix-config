{
  fetchFromGitHub,
  buildPythonPackage,
  hatchling,
  hatch-vcs,
  git,
  numpy,
  typing-extensions
}:
buildPythonPackage rec {
  pname = "cartographer3d-plugin";
  version = "v0.3.5";

  src = fetchFromGitHub {
    owner = "Cartographer3D";
    repo = "cartographer3d-plugin";
    rev = version;
    # rev: "6b250f4fbb9125a7c8a7454d8bc91734f6150fef";
    hash = "sha256-7AV9wsW62QbLEkvTnD4GOMGMayGSAH3mKsVMVI4rCT4=";
  };

  pyproject = true;

  build-system = [hatchling hatch-vcs git];
  propagatedBuildInputs = [numpy typing-extensions];

  patchPhase = ''
    sed -i -e 's/numpy~=1.16/numpy~=2.3/g' pyproject.toml
  '';
}
