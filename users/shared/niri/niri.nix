{ config, ... }:
{
  # Requires the sodiboo/niri-flake home-manager module (niri.homeModules.config)
  programs.niri.settings = {

    # ---------------------------------------------------------------------
    # Monitors
    # ---------------------------------------------------------------------
    outputs."HDMI-A-1" = {
      mode = {
        width = 5120;
        height = 1440;
        refresh = 240.0;
      };
      scale = 1.0;
      position = { x = 0; y = 0; };
    };
    # eDP-1 / mirroring block was commented out in the source, so omitted here too.

    # ---------------------------------------------------------------------
    # Input
    # ---------------------------------------------------------------------
    input = {
      keyboard = {
        xkb.layout = "ch";
        numlock = true; # numlock_by_default
      };

      touchpad.natural-scroll = true;

      # follow_mouse = 1 -> focus follows mouse into windows
      focus-follows-mouse.enable = true;

      # Hyprland's `device { name = "...stylus"; relative_input = false; }` has no
      # per-device equivalent in niri — there's just one global `input.tablet` block.
      # tablet.map-to-output = "HDMI-A-1"; # uncomment/adjust if you want it pinned to a screen
    };

    # cursor.no_hardware_cursors has no niri equivalent (niri manages cursor
    # rendering itself; there's no software/hardware cursor toggle).

    # xwayland.force_zero_scaling has no equivalent - niri talks to Xwayland
    # through xwayland-satellite automatically, no scaling knob to set here.

    # ---------------------------------------------------------------------
    # Startup apps
    # ---------------------------------------------------------------------
    spawn-at-startup = [
      { command = [ "spotify" ]; }
      { command = [ "obsidian" ]; }
      { command = [ "nwg-drawer" "-ovl" "-nofs" "-r" ]; } # Albert-style launcher daemon
      { command = [ "swayosd-server" ]; }
      # hyprpaper doesn't apply to niri; use swaybg / swww / a niri-native wallpaper tool instead:
      # { command = [ "swaybg" "-i" "/path/to/wallpaper" ]; }
    ];

    # ---------------------------------------------------------------------
    # Look and feel
    # ---------------------------------------------------------------------
    layout = {
      # gaps_in 5 -> gap between windows. gaps_out 10 -> approximated with an
      # extra 5px strut on each side (5 gap + 5 strut = 10 outer).
      gaps = 5;
      struts = { left = 5; right = 5; top = 5; bottom = 5; };

      # decoration.rounding = 20 -> corner radius window rule, see window-rules below.
      # No general blur equivalent - niri only supports blurring the wallpaper
      # visible *behind* transparent/floating windows (window-rule `blur`),
      # not blurring layers/panels like Hyprland's compositor-wide blur.

      # Optional stylistic substitute for the disabled drop_shadow block in the source:
      # shadow.enable = true;
    };

    # Animations: niri has its own animation system (spring/easing curves per
    # named slot: window-open, window-close, workspace-switch, etc.) rather
    # than Hyprland's bezier-curve + animation-rule list, so the specific
    # curves (md3_decel, overshot, crazyshot...) don't carry over 1:1.
    # Animations are on by default; customize individual slots if you want, e.g.:
    # animations.window-movement.spring = { damping-ratio = 1.0; stiffness = 800; epsilon = 0.0001; };

    # ---------------------------------------------------------------------
    # Window rules
    # ---------------------------------------------------------------------
    window-rules = [
      # float,class:(com.aaron.dev)
      { matches = [ { app-id = "^com\\.aaron\\.dev$"; } ]; open-floating = true; }

      # float + noborder, class:(albert) title:(albert)

      # float, class:(org.gnome.NautilusPreviewer)
      { matches = [ { app-id = "^org\\.gnome\\.NautilusPreviewer$"; } ]; open-floating = true; }

      # float + fixed size, title:(Picture-in-Picture)
      {
        matches = [ { title = "^Picture-in-Picture$"; } ];
        open-floating = true;
        default-column-width = { fixed = 800; };
        # niri doesn't have a separate fixed-height rule outside of
        # default-column-width; use `niri msg action set-window-height`
        # or resize manually if 450px height matters to you.
      }

      # decoration.rounding = 20 (roughly - Hyprland unsets rounding for fullscreen,
      # niri doesn't have an is-fullscreen match condition, so this applies always)
      { geometry-corner-radius = 20.0; clip-to-geometry = true; }

      # No equivalent for: pinned-window bordercolor/bordersize (niri floating
      # windows aren't "pinned" across workspaces the way Hyprland's are), and
      # no equivalent for `suppressevent maximize` (not a concept in niri).
    ];

    # Hyprland's layerrule (anyrun/nwg-drawer slide animations) has no direct
    # niri equivalent — niri's layer-rule block controls things like
    # block-out-from and place-within-backdrop, not custom open/close
    # animations per layer-shell surface.

    # ---------------------------------------------------------------------
    # Keybinds
    # ---------------------------------------------------------------------
    binds = with config.lib.niri.actions; {
      "Mod+T".action = spawn "kitty";
      "Mod+Space".action = spawn "nwg-drawer" "--open";
      "Mod+Q".action = close-window;
      "Mod+Shift+M".action = quit;
      "Mod+E".action = spawn "zen-beta";
      "Mod+V".action = toggle-window-floating;
      "Mod+F".action = fullscreen-window;

      # togglesplit doesn't exist in niri's scrolling-column model; the
      # closest available action is toggling tabbed display for a column.
      "Mod+B".action = toggle-column-tabbed-display;

      # mainMod+Z pin -> no equivalent, omitted.

      # Resizing (Shift+HJKL)
      "Mod+Shift+H".action = set-column-width "-30";
      "Mod+Shift+L".action = set-column-width "+30";
      "Mod+Shift+K".action = set-window-height "-30";
      "Mod+Shift+J".action = set-window-height "+30";

      # Moving windows/columns (Ctrl+HJKL)
      "Mod+Ctrl+H".action = move-column-left;
      "Mod+Ctrl+L".action = move-column-right;
      "Mod+Ctrl+K".action = move-window-up;
      "Mod+Ctrl+J".action = move-window-down;

      # Focus (HJKL) - H/L move between columns, J/K move within a column
      "Mod+H".action = focus-column-left;
      "Mod+L".action = focus-column-right;
      "Mod+K".action = focus-window-up;
      "Mod+J".action = focus-window-down;

      # Workspaces 1-10 (niri workspaces are indexed like Hyprland's here)
      "Mod+1".action = focus-workspace 1;
      "Mod+2".action = focus-workspace 2;
      "Mod+3".action = focus-workspace 3;
      "Mod+4".action = focus-workspace 4;
      "Mod+5".action = focus-workspace 5;
      "Mod+6".action = focus-workspace 6;
      "Mod+7".action = focus-workspace 7;
      "Mod+8".action = focus-workspace 8;
      "Mod+9".action = focus-workspace 9;
      "Mod+0".action = focus-workspace 10;

      # workspace e+1 -> next existing workspace; niri's closest analog is
      # scrolling to the next workspace down (workspaces stack vertically).
      "Mod+Tab".action = focus-workspace-down;

      "Mod+Shift+1".action.move-column-to-workspace = [1];
      "Mod+Shift+2".action.move-column-to-workspace = [2];
      "Mod+Shift+3".action.move-column-to-workspace = [3];
      "Mod+Shift+4".action.move-column-to-workspace = [4];
      "Mod+Shift+5".action.move-column-to-workspace = [5];
      "Mod+Shift+6".action.move-column-to-workspace = [6];
      "Mod+Shift+7".action.move-column-to-workspace = [7];
      "Mod+Shift+8".action.move-column-to-workspace = [8];
      "Mod+Shift+9".action.move-column-to-workspace = [9];
      "Mod+Shift+0".action.move-column-to-workspace = [10];

      # Screenshot / recording / picker / lock
      "Mod+Shift+S".action.screenshot = {}; # niri's built-in interactive screenshot
      "Mod+Ctrl+S".action = spawn "kooha";
      "Mod+Shift+C".action = spawn "hyprpicker" "--autocopy"; # keep if it still works under XWayland, or swap for a Wayland-native picker
      "Mod+Shift+Q".action = spawn "swaylock";

      # Workspace scroll
      "Mod+WheelScrollDown".action = focus-workspace-down;
      "Mod+WheelScrollUp".action = focus-workspace-up;

      "Mod+Period".action = spawn "emote";

      # Media (note: source had a typo, "spotfy" - fixed here to "spotify")
      "Mod+Right".action = spawn "playerctl" "-p" "spotify" "next";
      "Mod+Left".action = spawn "playerctl" "-p" "spotify" "previous";
      "Mod+Down".action = spawn "playerctl" "-p" "spotify" "play-pause";

      "XF86AudioRaiseVolume".action = spawn "swayosd-client" "--output-volume" "raise";
      "XF86AudioLowerVolume".action = spawn "swayosd-client" "--output-volume" "lower";
      "XF86AudioMute".action = spawn "swayosd-client" "--output-volume" "mute-toggle";
    };

    # bindm (Mod + LMB/RMB drag to move/resize floating windows) needs no
    # explicit config in niri — Mod+click-drag on a floating window already
    # moves it, and Mod+right-click-drag already resizes it, by default.
  };
}
