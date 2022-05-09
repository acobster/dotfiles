"""""""""""""""""""
" CUSTOM MAPPINGS!
"""""""""""""""""""

" Conjure! 🔮
nmap <leader><Space> :ConjureEvalCurrentForm<Enter>
nmap <leader><Enter> :ConjureEvalBuf<Enter>
nmap <leader>cc :ConjureConnect<Enter>
nmap <leader>cw :ConjureEvalWord<Enter>
nmap <leader>cr :ConjureEvalReplaceForm<Enter>
nmap <leader>cll :ConjureLogSplit<Enter>
nmap <leader>clc :ConjureLogCloseVisible<Enter>
nmap <leader>clv :ConjureLogVSplit<Enter>
nmap <leader>clr :ConjureLogResetSoft<Enter>
nmap <leader>ma :ConjureEvalMark<Enter>

" File/Tab navigation
cnoremap %% <C-R>=expand('%:h').'/'<cr>
cnoremap N% tab new<Space>
cnoremap S% split<Space>
cnoremap V% vert new<Space>
cnoremap NN tab new<Space>
cnoremap VV vert new<Space>
nnoremap <c-l> :tabnext<CR>
nnoremap <c-h> :tabprevious<CR>

" Move current buffer one tab to the left
nmap <leader>z :tabprevious<cr>:vert<space>new<cr>,ww:tabnext<cr>,ww:q<cr>:tabprevious<cr>
" Move current buffer one tab to the right
nmap <leader>v :tabnext<cr>:vert<space>new<cr>,ww:tabprevious<cr>,ww:q<cr>:tabnext<cr>

" Configure split behavior
nnoremap <c-w>h :vertical resize -5<cr>
nnoremap <c-w>l :vertical resize +5<cr>
" k as in "move the line down"
nnoremap <c-w>k :resize +5<cr>
" j as in "move the line up"
nnoremap <c-w>j :resize -5<cr>
set splitbelow
set splitright

" Move tabs how I want, when I want
cnoremap <c-t><c-t> tabm<Space>0<cr>
cnoremap <c-t><c-h> tabm<Space>-<cr>
cnoremap <c-t><c-l> tabm<Space>+<cr>

" THE LOZENGE ◊
imap <c-l> ◊

" ,n redraws the screen and removes any search highlighting.
nmap <leader>n :nohlsearch<cr>

" Easy align interactive
vnoremap <silent> <Enter> :EasyAlign<cr>

" bash text completion
imap <c-b><c-i> if [[ X ]] ; then<cr><cr>fi<esc><<kkfXs

" Search config
nmap <leader>ff :Files<cr>
nmap <leader>ag :Ag<cr>

let g:fzf_action = {
  \ 'ctrl-k': 'vsplit',
  \ 'ctrl-l': 'tab split' }

let g:fzf_layout = { 'window': 'split enew' }

" Project path stuff
cmap ~vs ~/.vim/session/

" Assets - display assets from Ledger-CLI

command Assets r!date '+;; \%Y-\%m-\%d ALL ACCOUNTS BALANCED'; echo ';;'; ledger -f ~/ledger/ledger.dat balance assets --cleared | sed -s 's/^/;; /'


" Rename.vim  -  Rename a buffer within Vim and on the disk
"
" Copyright June 2007-2011 by Christian J. Robinson <heptite@gmail.com>
"
" Distributed under the terms of the Vim license.  See ":help license".
"
" Usage:
"
" :Rename[!] {newname}

command! -nargs=* -complete=file -bang Rename call Rename(<q-args>, '<bang>')

function! Rename(name, bang)
	let l:name    = a:name
	let l:oldfile = expand('%:p')

	if bufexists(fnamemodify(l:name, ':p'))
		if (a:bang ==# '!')
			silent exe bufnr(fnamemodify(l:name, ':p')) . 'bwipe!'
		else
			echohl ErrorMsg
			echomsg 'A buffer with that name already exists (use ! to override).'
			echohl None
			return 0
		endif
	endif

	let l:status = 1

	let v:errmsg = ''
	silent! exe 'saveas' . a:bang . ' ' . l:name

	if v:errmsg =~# '^$\|^E329'
		let l:lastbufnr = bufnr('$')

		if expand('%:p') !=# l:oldfile && filewritable(expand('%:p'))
			if fnamemodify(bufname(l:lastbufnr), ':p') ==# l:oldfile
				silent exe l:lastbufnr . 'bwipe!'
			else
				echohl ErrorMsg
				echomsg 'Could not wipe out the old buffer for some reason.'
				echohl None
				let l:status = 0
			endif

			if delete(l:oldfile) != 0
				echohl ErrorMsg
				echomsg 'Could not delete the old file: ' . l:oldfile
				echohl None
				let l:status = 0
			endif
		else
			echohl ErrorMsg
			echomsg 'Rename failed for some reason.'
			echohl None
			let l:status = 0
		endif
	else
		echoerr v:errmsg
		let l:status = 0
	endif

	return l:status
endfunction

" end Rename


command Bashargs r!snip bashargs
command Cssheader r!snip cssheader
command Php r!snip phpclass
command Wpcli r!snip wpcli


" 'start'/'end' replacements
nnoremap <leader>se 5send<esc>
nnoremap <leader>es 3sstart<esc>
" 'first'/'last' replacements
nnoremap <leader>fl 5slast<esc>
nnoremap <leader>lf 4sfirst<esc>
" 'create'/'update' replacements
nnoremap <leader>cu 3supd<esc>
nnoremap <leader>uc 3scre<esc>
" 'true'/'false' replacements
nnoremap <leader>tf 4sfalse<esc>
nnoremap <leader>ft 5strue<esc>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RUNNING TESTS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Start an editor command to set up the mapping for executing stuff in named
" pipe
" TODO figure out a snappier solution
cnoremap <c-P><c-P> nmap ,t :w\\|:silent !echo 'test_cmd' > test.pipe<c-v>u003Ccr>:redraw!<c-v>u003Ccr>
cnoremap <c-P><c-R> nmap ,r :w\\|:silent !echo 'test_cmd' > test.pipe<c-v>u003Ccr>:redraw!<c-v>u003Ccr>
cnoremap <c-P><c-E> nmap ,e :w\\|:silent !echo 'test_cmd' > test.pipe<c-v>u003Ccr>:redraw!<c-v>u003Ccr>
cnoremap <c-P><c-W> nmap ,w :w\\|:silent !echo 'test_cmd' > test.pipe<c-v>u003Ccr>:redraw!<c-v>u003Ccr>

cnoremap <c-P>a nmap ,a :w\\|:silent !echo 'ledger -f ~/ledger/ledger.dat balance assets' > test.pipe<c-v>u003Ccr>:redraw!<c-v>u003Ccr>
