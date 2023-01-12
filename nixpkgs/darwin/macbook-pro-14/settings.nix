{ pkgs, ... }:
{
  system.defaults = {
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      AppleShowAllExtensions = true;
      "com.apple.keyboard.fnState" = true;
    };

    dock = {
      orientation = "left";
      tilesize = 48;
      autohide = true;
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

    alf.globalstate = 1;
    SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;

  };

  # Add ability to used TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;
}