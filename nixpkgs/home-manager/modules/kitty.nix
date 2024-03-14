{ config, pkgs, lib, libs, ... }:
{
  programs.kitty = {
    enable = true;
    theme = "Tokyo Night";

    font = {
      name = "FiraCode Nerd Font Mono";
      size = 16;
    };

    settings = {
      kitty_mod = "ctrl+shift";

      enabled_layouts = "splits:split_axis=horizontal";

      shell_integration = "enabled";
      confirm_os_window_close = 0;

      sync_to_monitor = "yes";

      macos_quit_when_last_window_closed = "no";
      macos_show_window_title_in = "window";

      tab_bar_style = "powerline";
    };

    keybindings = {
      "kitty_mod+a>equal" = "change_font_size all +2.0";
      "kitty_mod+a>plus" = "change_font_size all +2.0";
      "kitty_mod+a>kp_add" = "change_font_size all +2.0";

      "kitty_mod+a>minus" = "change_font_size all -2.0";
      "kitty_mod+a>kp_subtract" = "change_font_size all -2.0";

      "kitty_mod+a>backspace" = "change_font_size all 0";

      # Tabs (like browser)
      "ctrl+a>n" = "next_tab";
      "ctrl+a>p" = "previous_tab";
      "ctrl+a>c" = "new_tab";
      # "kitty_mod+x" = "close_tab";

      # splits
      "ctrl+a>\\" = "launch --location=vsplit --cwd=current";
      "ctrl+a>-" = "launch --location=hsplit --cwd=current";
      "ctrl+a>x" = "close_window";

      # resize
      # "ctrl+shift+r" = "start_resizing_window";

      # # navigation
      "ctrl+a>left" = "neighboring_window left";
      "ctrl+a>down" = "neighboring_window down";
      "ctrl+a>up" = "neighboring_window up";
      "ctrl+a>right" = "neighboring_window right";
    };
  };
}
