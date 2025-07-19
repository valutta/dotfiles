if status is-interactive
    # Commands to run in interactive sessions can go here
end

function fish_vi_cursor;
    switch $fish_bind_mode
        case default
            echo -ne '\e[2 q'  # Block cursor
        case insert
            echo -ne '\e[2 q'  # Beam cursor
        case replace_one
            echo -ne '\e[2 q'  # Underline cursor
        case visual
            echo -ne '\e[2 q'  # Block cursor
    end
end

function fish_prompt
   #if test (id -u) -eq 0
   #		set_color white
   #    printf " " $USER
   #		set_color white
   #    printf "root"
   #		set_color white
   #    printf "@" $USER
   #else
   #		set_color white
   #    printf " " $USER
   #		set_color white
   #    printf "%s" $USER
   #		set_color white
   #    printf "@" $USER
   #end
   #
   set_color '#e26c7c'
   printf ">"
   #set_color white
   #printf " " (hostname -s)


    set_color '#98d3ee'
	fish_default_key_bindings
    echo -n "<>  "
end

alias vim='nvim'
alias nano='nvim'
alias doas='doas '
alias fuck='doas'
alias q='exit'
alias lg='lazygit'
alias reboot='doas reboot'
alias poweroff='doas poweroff'
alias pkg-install='doas nixos-rebuild switch'
alias confnix='doas nvim /etc/nixos/configuration.nix/'
alias fixmysound="rm -rf /run/user/1000/pipewire* && rm -rf /run/user/1000/pulse* && rm -rf ~/.local/state/pipewire && systemctl --user daemon-reexec && systemctl --user start pipewire wireplumber"
set -x MANPAGER "nvim +Man!"
set -x NPM_CONFIG_PREFIX $HOME/.local
set -x PATH $HOME/go/bin $HOME/.local/bin $NPM_CONFIG_PREFIX/bin $PATH
set -gx PATH $HOME/bin $PATH


#cd ~
function fish_greeting; end
export PATH="$HOME/.cargo/bin:$PATH"
