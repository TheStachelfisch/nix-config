{
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
  version = "v1.0.0";

  src = fetchFromGitHub {
    owner = "Cartographer3D";
    repo = "cartographer3d-plugin";
    rev = version;
    hash = "sha256-rQPDUChekGVIBYLtVtfpn/mChQG1oNHrF7HKX2RW3JY=";
  };

  pyproject = true;

  build-system = [hatchling hatch-vcs git];
  propagatedBuildInputs = [numpy typing-extensions scipy];

  patchPhase = ''
    sed -i -e 's/numpy~=1.16/numpy~=2.3/g' pyproject.toml
  '';
}
