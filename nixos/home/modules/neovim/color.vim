" COLOR CONFIG

" Coloring for 80-char column
if (exists('+colorcolumn'))
  set colorcolumn=80
  highlight ColorColumn ctermbg=9
endif

" -- solarized personal conf
if has('gui_running')
  set background=light
else
  " Detect environment variable for solarized theme.
  " This is the same env variable that Zsh uses.
  let profile_theme = $GNOME_TERMINAL_SOLARIZED_THEME

  if profile_theme == 'light'
    set background=light
  else
    set background=dark
  endif
endif

try
  colorscheme solarized

  " transparent background
  " https://stackoverflow.com/questions/37712730/set-vim-background-transparent
  hi Normal guibg=NONE ctermbg=NONE
catch
endtry

" https://superuser.com/questions/895180/solarized-dark-gnome-terminal-vim-vim-airline
let &t_Co=256
