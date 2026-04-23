{ pkgs, ... }:
{
  system.defaults = {
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      AppleShowAllExtensions = true;
      # "com.apple.keyboard.fnState" = true;
      AppleFontSmoothing = 0;
    };

    dock = {
      orientation = "left";
      tilesize = 48;
      autohide = false;
      mru-spaces = false;  
      minimize-to-application = true;
      show-recents = false;
    };

    finder = {
      AppleShowAllExtensions = true;
      FXDefaultSearchScope = "SCcf";
      FXPreferredViewStyle = "Nlsv";
      ShowPathbar = true;
      QuitMenuItem = true;
    };



    loginwindow.GuestEnabled = false;

    SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;

  };

  system.primaryUser = "pbandurski";

  networking.applicationFirewall.enable = true;
  networking.applicationFirewall.blockAllIncoming = true;

  # Add ability to used TouchID for sudo authentication
  security.pam.services.sudo_local.touchIdAuth = true;
}