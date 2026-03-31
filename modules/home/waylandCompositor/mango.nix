{...}: {
  wayland.windowManager.mango = {
    enable = true;
    settings = ''

      exec-once = noctalia-shell

      exec-once = wswitch --daemon

      # bind.conf

      bind = SUPER+SHIFT,r,reload_config
      bind = ALT,tab,spawn,wswitch next
      bind = SUPER,return,spawn,kitty
      bind = SUPER,x,killclient,

      # switch window focus
      bind=SUPER,Tab,focusstack,next
      bind=ALT,Left,focusdir,left
      bind=ALT,Right,focusdir,right
      bind=ALT,Up,focusdir,up
      bind=ALT,Down,focusdir,down

      # swap window
      bind=SUPER+SHIFT,Up,exchange_client,up
      bind=SUPER+SHIFT,Down,exchange_client,down
      bind=SUPER+SHIFT,Left,exchange_client,left
      bind=SUPER+SHIFT,Right,exchange_client,right

      # switch window status
      bind=SUPER,g,togglegloba
      #bind=ALT,Tab,toggleoverview,
      bind=ALT,f,togglefloating,
      bind=SUPER,f,togglemaximizescreen,
      bind=SUPER+ALT,f,togglefullscreen,
      #bind=ALT+SHIFT,f,togglefakefullscreen,
      bind=SUPER,c,minimized,
      bind=SUPER,o,toggleoverlay
      bind=SUPER,i,restore_minimize
      bind=SUPER+SHIFT,c,centerwin
      bind=ALT,z,toggle_scratchpad

      # scroller layout
      bind=ALT,e,set_proportion,1.0
      bind=ALT,x,switch_proportion_preset,

      # switch layout
      bind=SUPER,t,setlayout,tile
      bind=SUPER,v,setlayout,vertical_grid
      bind=SUPER+SHIFT,s,setlayout,scroller

      # tag switch
      bind=SUPER,Left,viewtoleft,0
      bind=CTRL,Left,viewtoleft_have_client,0
      bind=SUPER,Right,viewtoright,0
      bind=CTRL,Right,viewtoright_have_client,0
      bind=CTRL+SUPER,Left,tagtoleft,0
      bind=CTRL+SUPER,Right,tagtoright,0

      bind=SUPER,1,view,1,0
      bind=SUPER,2,view,2,0
      bind=SUPER,3,view,3,0
      bind=SUPER,4,view,4,0
      bind=SUPER,5,view,5,0
      bind=SUPER,6,view,6,0
      bind=SUPER,7,view,7,0
      bind=SUPER,8,view,8,0
      bind=SUPER,9,view,9,0

      # tag: move client to the tag and focus it
      # tagsilent: move client to the tag and not focus it
      # bind=Alt,1,tagsilent,1
      bind=Alt,1,tag,1,0
      bind=Alt,2,tag,2,0
      bind=Alt,3,tag,3,0
      bind=Alt,4,tag,4,0
      bind=Alt,5,tag,5,0
      bind=Alt,6,tag,6,0
      bind=Alt,7,tag,7,0
      bind=Alt,8,tag,8,0
      bind=Alt,9,tag,9,-1

      #toggleview
      bind=CTRL,1,toggleview,1
      bind=CTRL,2,toggleview,2
      bind=CTRL,3,toggleview,3
      bind=CTRL,4,toggleview,4
      bind=CTRL,5,toggleview,5
      bind=CTRL,6,toggleview,6
      bind=CTRL,7,toggleview,7
      bind=CTRL,8,toggleview,8
      bind=CTRL,9,toggleview,9

      # monitor switch
      # bind=alt+shift,Left,focusmon,left
      # bind=alt+shift,Right,focusmon,right
      # bind=SUPER+Alt,Left,tagmon,left
      # bind=SUPER+Alt,Right,tagmon,right

      # gaps
      bind=ALT+SHIFT,X,incgaps,1
      bind=ALT+SHIFT,Z,incgaps,-1
      bind=ALT+SHIFT,R,togglegaps

      # movewin
      bind=CTRL+SHIFT,Up,movewin,+0,-50
      bind=CTRL+SHIFT,Down,movewin,-0,+50
      bind=CTRL+SHIFT,Left,movewin,-50,+0
      bind=CTRL+SHIFT,Right,movewin,+50,+0

      # resizewin
      bind=CTRL+ALT,Up,resizewin,+0,-50
      bind=CTRL+ALT,Down,resizewin,+0,+50
      bind=CTRL+ALT,Left,resizewin,-50,+0
      bind=CTRL+ALT,Right,resizewin,+50,+0

      # Mouse Button Bindings
      # NONE mode key only work in ov mode
      mousebind=SUPER,btn_left,moveresize,curmove
      mousebind=SUPER,btn_middle,togglemaximizescreen,1
      mousebind=SUPER,btn_right,moveresize,curresize
      mousebind=NONE,btn_left,toggleview,1
      mousebind=NONE,btn_right,killclient,0

      # Axis Bindings
      axisbind=SUPER,UP,viewtoleft_have_client
      axisbind=SUPER,DOWN,viewtoright_have_client
      axisbind=ALT,DOWN,focusdir,right
      axisbind=ALT,UP,focusdir,left

      # Gesture Bindings
      # ---------

      #application
      bind=SUPER,e,spawn,nemo
      bind=CTRL,b,spawn,firefox
      bind=SUPER+ALT,c,spawn,codium
      # bind=CTRL+SHIFT,z,spawn,zeditor

      #Screenshot
      #bind=SUPER,s,spawn_shell,grim -g "$(slurp)" - | swappy -f -
      bind=none,Print,spawn,msnap gui
      bind=SUPER,Print,spawn_shell,msnap shot --region -a -F -o ~/Pictures/Screenshots -f screenshot-%Y-%m-%d-%H-%M-%S.png
      bind=SUPER,s,spawn_shell,msnap shot --region -a -c -F -o ~/Pictures/Screenshots -f screenshot-%Y-%m-%d-%H-%M-%S.png
      bind=ALT,s,spawn_shell,msnap cast --toggle --region -a -o ~/Videos/Screencasts/ -f recording-%Y-%m-%d-%H-%M-%S.mp4

      #noctalia-shell call

      bind=ALT,space,spawn,noctalia-shell ipc call launcher toggle
      bind=ALT,c,spawn,noctalia-shell ipc call launcher clipboard
      bind=SUPER,space,spawn,noctalia-shell ipc call sessionMenu toggle
      bind=CTRL,l,spawn,noctalia-shell ipc call lockScreen lock
      bind=SUPER+ALT,up,spawn,noctalia-shell ipc call volume increase
      bind=SUPER+ALT,down,spawn,noctalia-shell ipc call volume decrease
      bind=SUPER+ALT,m,spawn,noctalia-shell ipc call volume muteOutput
      bind=SUPER+CTRL,up,spawn,noctalia-shell ipc call brightness increase
      bind=SUPER+CTRL,down,spawn,noctalia-shell ipc call brightness decrease
      bind=SUPER+CTRL,n,spawn,noctalia-shell ipc call nightLight toggle
      bind=CTRL+ALT,p,spawn,noctalia-shell ipc call powerProfile toggleNoctaliaPerformance
      bind=SUPER,w,spawn,noctalia-shell ipc call wallpaper toggle

      # Animation.conf
      # Animation Configuration(support type:zoom,slide)
      # tag_animation_direction: 0-horizontal,1-vertical
      animations=1
      layer_animations=1
      animation_type_open=zoom
      animation_type_close=zoom
      animation_fade_in=1
      animation_fade_out=1
      tag_animation_direction=1
      zoom_initial_ratio=0.3
      zoom_end_ratio=0.8
      fadein_begin_opacity=0.5
      fadeout_begin_opacity=0.8
      animation_duration_move=500
      animation_duration_open=300
      animation_duration_tag=350
      animation_duration_close=400
      animation_duration_focus=0
      animation_curve_open=0.46,1.0,0.29,1
      animation_curve_move=0.46,1.0,0.29,1
      animation_curve_tag=0.46,1.0,0.29,1
      animation_curve_close=0.08,0.92,0,1
      animation_curve_focus=0.46,1.0,0.29,1

      #effect.conf
      # Appearance
      gappih=5
      gappiv=5
      gappoh=5
      gappov=5
      scratchpad_width_ratio=0.8
      scratchpad_height_ratio=0.9
      borderpx=2
      rootcolor=0x201b14ff
      bordercolor=0xA9B665ff
      focuscolor=0xE78A4Eff
      maximizescreencolor=0x928374ff
      urgentcolor=0xad401fff
      scratchpadcolor=0x516c93ff
      globalcolor=0xb153a7ff
      overlaycolor=0x14a57cff

      # Window effect
      blur=1
      blur_layer=0
      blur_optimized=1
      blur_params_num_passes = 2
      blur_params_radius = 5
      blur_params_noise = 0.02
      blur_params_brightness = 0.9
      blur_params_contrast = 0.9
      blur_params_saturation = 1.2

      shadows = 1
      layer_shadows = 0
      shadow_only_floating = 0
      shadows_size = 10
      shadows_blur = 15
      shadows_position_x = 0
      shadows_position_y = 0
      shadowscolor= 0x000000ff

      border_radius=6
      no_radius_when_single=0
      focused_opacity=1
      unfocused_opacity=1

      #layout.conf
      # Scroller Layout Setting
      scroller_structs=20
      scroller_default_proportion=0.8
      scroller_focus_center=0
      scroller_prefer_center=0
      edge_scroller_pointer_focus=1
      scroller_default_proportion_single=1.0
      scroller_proportion_preset=0.5,0.8,1.0

      # Master-Stack Layout Setting
      new_is_master=0
      default_mfact=0.55
      default_nmaster=1
      smartgaps=0

      # Overview Setting
      hotarea_size=10
      enable_hotarea=0
      ov_tab_mode=0
      overviewgappi=5
      overviewgappo=30

      # Misc
      no_border_when_single=0
      axis_bind_apply_timeout=100
      focus_on_activate=1
      inhibit_regardless_of_visibility=0
      sloppyfocus=1
      warpcursor=1
      focus_cross_monitor=0
      focus_cross_tag=0
      enable_floating_snap=0
      snap_distance=30
      drag_tile_to_tile=1

      #input.conf
      # keyboard
      repeat_rate=25
      repeat_delay=600
      numlockon=0
      xkb_rules_layout=us

      # Swap Esc and CapsLock
      xkb_rules_options=caps:escape
      xkb_rules_options=caps:escape_shifted_capslock

      # Trackpad
      # need relogin to make it apply
      disable_trackpad=0
      tap_to_click=1
      tap_and_drag=1
      drag_lock=1
      trackpad_natural_scrolling=0
      disable_while_typing=1
      left_handed=0
      middle_button_emulation=0
      swipe_min_threshold=1

      # mouse
      # need relogin to make it apply
      mouse_natural_scrolling=0

      # env.conf
      env = QT_QPA_PLATFORMTHEME,gtk3
      env = QT_QPA_PLATFORMTHEME_QT6,gtk3
      env = QT_QPA_PLATFORM,wayland;xcb

      # monitor
      monitorrule=name:^eDP-1$,width:1366,height:768,refresh:60,x:0,y:0

      # window rule
      windowrule=isfloating:1,width:600,height:300,appid:satty
      windowrule=isfloating:1,width:284,height:154,title:Picture-in-Picture
      windowrule=isfullscreen:1,appid:mpv
      windowrule=force_tearing:1,title:Terraria
      windowrule=force_tearing:1,title:tModLoader
      windowrule=force_tearing:1,title:The Long Dark
      windowrule=force_tearing:1,title:D1AL-ogue

      # layer rule
      layerrule = layer_name:msnap, noanim:1, noblur:1


    '';
    autostart_sh = ''
      set +e

      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=wlroots >/dev/null 2>&1
    '';
  };
}
