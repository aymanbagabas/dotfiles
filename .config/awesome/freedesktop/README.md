About
=====

This project aims to add support for freedesktop.org compliant desktop entries
and menu.

Installation
============

`git clone https://github.com/mony960/awesome-freedesktop.git freedesktop` in your ~/.config/awesome/ directory.

Main features
=============

  * a freedesktop.org-compliant (or almost) applications menu
  * a freedesktop.org-compliant (or almost) desktop
  * a (yet limited) icon lookup function.

Icon themes
===========

Gtk icon theme will be selected

Usage example
=============

You can use the freedesktop module in your awesome configuration
(~/.config/awesome/rc.lua) like the example below. If you are a Debian user,
you can also uncomment the two lines that insert the Debian menu together with
the rest of the items.

    local freedesktop = require('freedesktop') -- put this in the top of your configuration
    
    -- applications menu
    freedesktop.utils.terminal = terminal -- default: "xterm"
    -- require("debian.menu") -- if you are using debian
    
    menu_items = freedesktop.menu.new()
    myawesomemenu = {
       { "manual", terminal .. " -e man awesome", freedesktop.utils.lookup_icon({ icon = 'help' }) },
       { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua", freedesktop.utils.lookup_icon({ icon = 'package_settings' }) },
       { "restart", awesome.restart, freedesktop.utils.lookup_icon({ icon = 'gtk-refresh' }) },
       { "quit", awesome.quit, freedesktop.utils.lookup_icon({ icon = 'gtk-quit' }) }
    }
    table.insert(menu_items, { "awesome", myawesomemenu, beautiful.awesome_icon })
    table.insert(menu_items, { "open terminal", terminal, freedesktop.utils.lookup_icon({icon = 'terminal'}) })
    -- table.insert(menu_items, { "Debian", debian.menu.Debian_menu.Debian, freedesktop.utils.lookup_icon({ icon = 'debian-logo' }) })
    
    mymainmenu = awful.menu({ items = menu_items })
    
    mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon, menu = mymainmenu })


    -- desktop icons

    -- freedesktop.desktop.config.computer = false -- to disabble computer icon
    -- freedesktop.desktop.config.home = false -- to disabble home icon
    -- freedesktop.desktop.config.network = false -- to disabble network icon
    -- freedesktop.desktop.config.trash = false -- to disabble trash icon

    for s = 1, screen.count() do
          freedesktop.desktop.add_desktop_icons({screen = s, showlabels = true,
          open_with = 'thunar' }) -- replace thunar with xdg-open if you installed `xdg-utils/xdg-utils-mimeo` or with your best file opener
    end

NOTE: install `thunar` & `xdg-utils-mimeo` from AUR -- if you want !

License
=======

Copyright © 2009-2011 Antonio Terceiro <terceiro@softwarelivre.org>

This code is licensed under the same terms as Awesome itself.
