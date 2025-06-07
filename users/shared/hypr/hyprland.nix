{
    cursor = {
        no_hardware_cursors = true;
    };


    # Monitors
    monitor = [
        "HDMI-A-1,5120x1440@240,auto,1"
        #"eDP-1,highres,auto,1.5"
        #",highres,auto,1.5,mirror,eDP-1" # Uncomment this line for screen mirroring
    ];

    xwayland = {
        force_zero_scaling = true;
    };


    # Environment
    "$terminal" = "kitty";
    "$browser" = "zen";
    "$launcher" = "albert show";

    exec-once = [
        # Startup apps
        "[workspace 2 silent] spotify"
        "[workspace 1 silent] obsidian"
        #"[workspace 1 silent] kitty"
        #"[workspace 1 silent] $browser"

        # Start Albert
        "albert"
    ];

    windowrulev2 = [
        "float,class:(com.aaron.dev)"
        "float,class:(albert) title:(albert)"
        "noborder,class:(albert) title:(albert)"
        "suppressevent maximize, class:.*"
        "rounding 0,fullscreen:1"

        "float,class:(org.gnome.NautilusPreviewer)"
        "float,class:(Greeter)"

        "float,title:(Picture-in-Picture)"
        "size 800 450,title:(Picture-in-Picture)"
    ];

    # Look and Feel
    general = {
        gaps_in = 5;
        gaps_out = 10;

        border_size = 1;

        "col.active_border" = "rgb(45ffde)"; # TODO: Make this use some sort of config (color)
        "col.inactive_border" = "rgba(595959aa)"; # TODO: Make this use some sort of config (color)

        resize_on_border = true;
        allow_tearing = false;

        layout = "dwindle";
    };

    decoration = {
        rounding = 20;

        active_opacity = 1.0;
        inactive_opacity = 1.0;

        # drop_shadow = true;
        # shadow_range = 4;
        # shadow_render_power = 4;
        # "col.shadow" = "rgba(1a1a1aee)";

        blur = {
            enabled = true;
            size = 3;
            passes = 3;
            vibrancy = 0.1696;
        };
    };

    animations = {
        enabled = true;

        bezier = [
            "linear, 0, 0, 1, 1"
            "md3_standard, 0.2, 0, 0, 1"
            "md3_decel, 0.05, 0.7, 0.1, 1"
            "md3_accel, 0.3, 0, 0.8, 0.1"
            "overshot, 0.05, 0.9, 0.1, 1.5"
            "crazyshot, 0.1, 1.5, 0.76, 0.92"
            "hyprnostretch, 0.05, 0.9, 0.1, 1.0"
            "menu_decel, 0.1, 1, 0, 1"
            "menu_accel, 0.38, 0.04, 1, 0.07"
            "easeInOutCirc, 0.85, 0, 0.15, 1"
            "easeOutCirc, 0, 0.55, 0.45, 1"
            "easeOutExpo, 0.16, 1, 0.3, 1"
            "softAcDecel, 0.26, 0.26, 0.15, 1"
            "md2, 0.4, 0, 0.2, 1"
        ];

        animation = [
            "windows, 1, 3, md3_decel, popin 80%"
            "windowsIn, 1, 3, md3_decel, popin 80%"
            "windowsOut, 1, 3, md3_accel, popin 60%"
            "border, 1, 10, default"
            "fade, 1, 3, md3_decel"
            # "layers, 1, 2, md3_decel, slide"
            "layersIn, 1, 10, menu_decel, popin"
            "layersOut, 1, 1.6, menu_accel"
            "fadeLayersIn, 1, 2, menu_decel"
            "fadeLayersOut, 1, 4.5, menu_accel"
            "workspaces, 1, 5, menu_decel, slide"
            "workspaces, 1, 2.5, softAcDecel, slide"
            "workspaces, 1, 7, menu_decel, slidefade 15%"
            # "specialWorkspace, 1, 3, md3_decel, slidefadevert 15%"
            "specialWorkspace, 1, 3, md3_decel, slidevert"
        ];

    };

    dwindle = {
        pseudotile = true; # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = true; # You probably want this 
    };

    master = {
        new_status = "master";
    };

    misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
    };

    device = {
        name = "gxtp7386:00-27c6:0111-stylus";
        relative_input = false;
    };

    # Input
    input = {
        kb_layout = "ch";
        #kb_variant = "ch";
        
        follow_mouse = 1;
        sensitivity = 0; # 0 means no modification

        tablet = {
            relative_input = true;
        };

        touchpad = {
            natural_scroll = true;
        };
    };
    
    gestures = {
        workspace_swipe = true;
    };

    # TODO: Migrate all of this to xremap ):
    "$mainMod" = "SUPER"; # Sets "Windows" key as main modifier

    bind = [
        "$mainMod, T, exec, $terminal"
        "$mainMod, SPACE, exec, $launcher"
        "$mainMod, Q, killactive,"
        "$mainMod, M, exit,"
        "$mainMod, E, exec, $browser"
        "$mainMod, V, togglefloating,"
        "$mainMod, F, fullscreen"
        "$mainMod, B, layoutmsg, togglesplit"

        # Move focus with mainMod + arrow keys
        "$mainMod, H, movefocus, l"
        "$mainMod, L, movefocus, r"
        "$mainMod, K, movefocus, u"
        "$mainMod, J, movefocus, d"

        # Switch workspaces with mainMod + [0-9]
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"

        # Screenshot

        "$mainMod SHIFT, S, exec, slurp | grim -g - - | wl-copy" # p flag is actually really important!
        "$mainMod SHIFT, C, exec, hyprpicker --autocopy" # p flag is actually really important!


        # Example special workspace (scratchpad)
        # "$mainMod, S, togglespecialworkspace, magic"
        # "$mainMod SHIFT, S, movetoworkspace, special:magic"

        # Scroll through existing workspaces with mainMod + scroll
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
    ];

    # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more

    # Move/resize windows with mainMod + LMB/RMB and dragging
    bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
    ];

}
