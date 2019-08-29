## elm2nix

Currently the `elm.json` in Concourse source does not seem to get upated by the `update.sh` tool.  You must add missing concourse dependencies manually to the pinning file `elm-srcs.nix` by building concourse and adding the dependencies manually and correcting the sha's that nix would have calculated.  Future work on `elm2nix` may alleviate this step.
