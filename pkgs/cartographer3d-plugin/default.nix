{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  hatchling,
  hatch-vcs,
  git,
  numpy,
  scipy,
  typing-extensions
}:
buildPythonPackage rec {
  pname = "cartographer3d-plugin";
  version = "v0.7.3";

  src = fetchFromGitHub {
    owner = "Cartographer3D";
    repo = "cartographer3d-plugin";
    rev = version;
    hash = "sha256-Rn/hmbCGOGHF1eNMVH/UxejqpLm+EgW6w/7f/HnK7Mk=";
  };

  pyproject = true;

  build-system = [hatchling hatch-vcs git];
  propagatedBuildInputs = [numpy typing-extensions scipy];

  patchPhase = ''
    sed -i -e 's/numpy~=1.16/numpy~=2.3/g' pyproject.toml
  '';
}
