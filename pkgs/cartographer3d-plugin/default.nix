{
  lib,
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
  version = "v0.4.5";

  src = fetchFromGitHub {
    owner = "Cartographer3D";
    repo = "cartographer3d-plugin";
    rev = version;
    hash = "sha256-MJqz7P5a2e4sO2jFxcu8nhfhMiqA4TjoIQCQG0Z66tM=";
  };

  pyproject = true;

  build-system = [hatchling hatch-vcs git];
  propagatedBuildInputs = [numpy typing-extensions];

  patchPhase = ''
    sed -i -e 's/numpy~=1.16/numpy~=2.3/g' pyproject.toml
  '';
}
