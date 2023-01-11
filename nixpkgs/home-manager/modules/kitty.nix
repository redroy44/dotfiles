{ config, pkgs, lib, libs, ... }:
{
  programs.kitty = {
    enable = true;
    theme = "One Dark";

    font = {
      name = "FiraCode Nerd Font Mono";
      size = 12;
    };

    settings = {
      kitty_mod = "ctrl+a";

      enabled_layouts = "splits:split_axis=horizontal";

      shell_integration = "enabled";
      confirm_os_window_close = 0;

      macos_quit_when_last_window_closed = "no";
      macos_show_window_title_in = "window";
    };

    keybindings = {
      "kitty_mod>equal" = "change_font_size all +2.0";
      "kitty_mod>plus" = "change_font_size all +2.0";
      "kitty_mod>kp_add" = "change_font_size all +2.0";

      "kitty_mod>minus" = "change_font_size all -2.0";
      "kitty_mod>kp_subtract" = "change_font_size all -2.0";

      "kitty_mod>backspace" = "change_font_size all 0";

      # Tabs (like browser)
      "kitty_mod>n" = "next_tab";
      "kitty_mod>p" = "previous_tab";
      "kitty_mod>c" = "new_tab";
      # "kitty_mod+x" = "close_tab";

      # splits
      "kitty_mod>|" = "launch --location=vsplit --cwd=current";
      "kitty_mod>-" = "launch --location=hsplit --cwd=current";
      "kitty_mod>x" = "close_window";

      # resize
      # "ctrl+shift+r" = "start_resizing_window";

      # # navigation
      "ctrl+left" = "neighboring_window left";
      "ctrl+down" = "neighboring_window down";
      "ctrl+up" = "neighboring_window up";
      "ctrl+right" = "neighboring_window right";
    };
  };
}
