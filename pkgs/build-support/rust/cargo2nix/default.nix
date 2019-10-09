{
  fetchgit,
}:
let
  src = fetchgit {
    url = "https://github.com/tenx-tech/cargo2nix.git";
    rev = "5d25a0b760313604dbe9c2c185ac16c55d346f3b";
    sha256 = "09dbxc2a4cbhk312i22sk6vf7b4wnaps0jyjxy7v22z2vxnn38cx";
  };
in
(import "${src}/default.nix" {}).package
