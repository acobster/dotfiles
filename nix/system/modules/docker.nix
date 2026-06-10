{ pkgs, ... }:

{
  # environment.systemPackages = with pkgs; [
  #   docker_29
  # ];

  virtualisation.docker = {
    package = pkgs.docker_29;
    enable = true;
    storageDriver = "btrfs";
  };
}
