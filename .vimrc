" Source vim files IFF they exist
" https://devel.tech/snippets/n/vIIMz8vZ/load-vim-source-files-only-if-they-exist
function! SourceIfExists(file)
  if filereadable(expand(a:file))
    exe 'source' a:file
  endif
endfunction

call SourceIfExists("~/dotfiles/vim/common.vim")
call SourceIfExists("~/dotfiles/vim/vim-plugins.vim")
call SourceIfExists("~/dotfiles/vim/syntastic.vim")
call SourceIfExists("~/dotfiles/vim/color.vim")
call SourceIfExists("~/dotfiles/vim/mappings.vim")

" Markdown config
let g:vim_markdown_folding_disabled = 1

call SourceIfExists("~/.vimrc.local")
