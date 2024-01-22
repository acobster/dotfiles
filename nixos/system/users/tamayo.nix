{ config, lib, pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tamayo = {
    isNormalUser = true;
    # go ahead, try it lol
    initialPassword = "pourover";
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    # TODO move this to home-manager?
    packages = with pkgs; [
      protonvpn-cli
      protonvpn-gui
    ];
  };
}
