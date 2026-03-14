{
  lib,
  buildNpmPackage,
  fetchurl,
}:

buildNpmPackage rec {
  pname = "ccs";
  version = "7.53.0";

  src = fetchurl {
    url = "https://registry.npmjs.org/@kaitranntt/ccs/-/ccs-${version}.tgz";
    hash = "sha256-j4pw9ulQiTci5eLbjf30/VHCdQpR1UKg+LgRZWPFwpc=";
  };

  sourceRoot = "package";

  postPatch = ''
    cp ${./ccs-package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-D8hYNdrhsIHlzoeeFxznqXDZ3LvDd2Bw5b6tFCMjQv0=";
  dontNpmBuild = true;

  meta = {
    description = "Claude Code Switch - multi-account switching for Claude CLI";
    homepage = "https://github.com/kaitranntt/ccs";
    license = lib.licenses.mit;
    mainProgram = "ccs";
  };
}
