{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "stern-${version}";
  version = "1.10.0";

  goPackagePath = "github.com/wercker/stern";

  src = fetchFromGitHub {
    owner = "wercker";
    repo = "stern";
    rev = "${version}";
    sha256 = "05wsif0pwh2v4rw4as36f1d9r149zzp2nyc0z4jwnj9nx58nfpll";
  };

  goDeps = ./deps.nix;

  # Only build shell completion if we're _not_ cross compiling,
  # because it requires executing the compiled stern binary.
  postInstall = lib.optionalString (stdenv.buildPlatform == stdenv.hostPlatform) ''
    mkdir -p $bin/share/bash-completion/completions
    $bin/bin/stern --completion bash > $bin/share/bash-completion/completions/stern
    mkdir -p $bin/share/zsh/site-functions
    $bin/bin/stern --completion zsh > $bin/share/zsh/site-functions/_stern
  '';

  meta = with lib; {
    description      = "Multi pod and container log tailing for Kubernetes";
    homepage         = "https://github.com/wercker/stern";
    license          = licenses.asl20;
    maintainers      = with maintainers; [ mbode ];
    platforms        = platforms.unix;
  };
}
