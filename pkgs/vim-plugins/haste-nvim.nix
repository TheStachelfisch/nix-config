{ vimUtils, fetchFromGitHub }:

vimUtils.buildVimPlugin {
  name = "haste-nvim";
  src = fetchFromGitHub {
    owner = "ppebb";
    repo = "haste-nvim";
    rev = "8611e7b0379ff6d105824e41c800bfd92901f2ff";
    sha256 = "sha256-pGzGyxid3SXwoUSGF4tC5BgfLUup6cMDnycnz1XxBYo=";
  };
}

