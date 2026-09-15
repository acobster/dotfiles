{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "ledger-lsp";
  version = "master-2026-09-15";

  src = fetchFromGitHub {
    owner = "bsilvereagle";
    repo = "ledger-lsp";
    rev = "91691be3546bea2b73eeeafe9afca7d5a73f60df";
    hash = "sha256-8SHSN/AMxI+I4vbukw9p4+2wcpKEe49z8+poDxUuOc8=";
  };

  cargoHash = "sha256-vdRjdQVa2JuRa1cOJiqa6Lmul+SkuqHbmZwy3OOQHnI=";

  meta = with lib; {
    description = "Language Server Protocol for ledger-cli";
    homepage = "https://github.com/bsilvereagle/ledger-lsp";
    license = licenses.mit;
  };
}
