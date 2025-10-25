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
  version = "v0.7.4";

  src = fetchFromGitHub {
    owner = "Cartographer3D";
    repo = "cartographer3d-plugin";
    rev = version;
    hash = "sha256-BU8R6QHy5HByCApSb3ff5xveOPioT5L+vcsr7xFEue8=";
  };

  pyproject = true;

  build-system = [hatchling hatch-vcs git];
  propagatedBuildInputs = [numpy typing-extensions scipy];

  patchPhase = ''
    sed -i -e 's/numpy~=1.16/numpy~=2.3/g' pyproject.toml
  '';
}
