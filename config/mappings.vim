" Key-mappings
" ===
" Settings:
" - g:disable_mappings - Set true to disable this file entirely.
" - g:enable_universal_quit_mapping - Toggle 'q' for :quit mapping.

if get(g:, 'disable_mappings')
	finish
endif

" Elite-mode {{{
" ----------
" Disable arrow movement, resize windows instead.
nnoremap <Up>    <cmd>resize +8<CR>
nnoremap <Down>  <cmd>resize -8<CR>
nnoremap <Left>  <cmd>vertical resize +8<CR>
nnoremap <Right> <cmd>vertical resize -8<CR>
" With this function you can reuse the same terminal in neovim.
" You can toggle the terminal and also send a command to the same terminal.

let s:monkey_terminal_window = -1
let s:monkey_terminal_buffer = -1
let s:monkey_terminal_job_id = -1
let s:monkey_terminal_window_size = -1

function! MonkeyTerminalOpen()
  " Check if buffer exists, if not create a window and a buffer
  if !bufexists(s:monkey_terminal_buffer)
    " Creates a window call monkey_terminal
    new monkey_terminal
    " Moves the window to the bottom
    wincmd J
    resize 15
    let s:monkey_terminal_job_id = termopen($SHELL, { 'detach': 1 })

     " Change the name of the buffer to "Terminal 1"
     silent file Terminal\ 1
     " Gets the id of the terminal window
     let s:monkey_terminal_window = win_getid()
     let s:monkey_terminal_buffer = bufnr('%')

    " The buffer of the terminal won't appear in the list of the buffers
    " when calling :buffers command
    set nobuflisted
  else
    if !win_gotoid(s:monkey_terminal_window)
    sp
    " Moves to the window below the current one
    wincmd J
    execute "resize " . s:monkey_terminal_window_size
    buffer Terminal\ 1
     " Gets the id of the terminal window
     let s:monkey_terminal_window = win_getid()
    endif
  endif
endfunction

function! MonkeyTerminalToggle()
  if win_gotoid(s:monkey_terminal_window)
    call MonkeyTerminalClose()
  else
    call MonkeyTerminalOpen()
  endif
endfunction

function! MonkeyTerminalClose()
  if win_gotoid(s:monkey_terminal_window)
    let s:monkey_terminal_window_size = winheight(s:monkey_terminal_window)
    " close the current window
    hide
  endif
endfunction

function! MonkeyTerminalExec(cmd)
  if !win_gotoid(s:monkey_terminal_window)
    call MonkeyTerminalOpen()
  endif

  " clear current input
  call jobsend(s:monkey_terminal_job_id, "clear\n")

  " run cmd
  call jobsend(s:monkey_terminal_job_id, a:cmd . "\n")
  normal! G
  wincmd p
endfunction

" With this maps you can now toggle the terminal
nnoremap <A-T> :call MonkeyTerminalToggle()<cr>i
tnoremap <A-T> <C-\><C-n>:call MonkeyTerminalToggle()<cr>i
nnoremap <silent> <A-t> :silent !i3term<CR>

" inoremap <A-t> <Esc>:bot new<CR>:term<CR>i
" tnoremap <A-t> <C-\><C-n>:vsplit<CR>:term<CR>i
"
" Terminal go back to normal mode
"tnoremap <Esc> <C-\><C-n>
"tnoremap <C-k> <C-\><C-n>
"tnoremap :q! <C-\><C-n>:q!<CR>


autocmd BufWinEnter,WinEnter term://* startinsert
autocmd BufLeave term://* stopinsert
" Terminal mappings
if exists(':tnoremap')
	if has('nvim')
		" Windows
		tnoremap <C-h> <C-\><C-n><C-W>h
		tnoremap <C-k> <C-\><C-n><C-W>k
		tnoremap <C-l> <C-\><C-n><C-W>l
		tnoremap <C-j> <C-\><C-n><C-W>j
		tnoremap <F8> <C-\><C-n>
		tnoremap <C-w> <C-\><C-n>:bwipeout!<CR>
		" Tabs
		tnoremap <A-h> <C-\><C-n>:tabprevious<CR>
		tnoremap <A-j> <C-\><C-n><C-W>j
		tnoremap <A-k> <C-\><C-n><C-W>k
		tnoremap <A-l> <C-\><C-n>:tabnext<CR>
	else
		tnoremap <C-k> <C-w><C-k>
		tnoremap <C-h> <C-w><C-h>
		tnoremap <C-l> <C-w><C-l>
		tnoremap <C-w> <C-w><C-w>
		tnoremap <C-j> <C-w>
	endif
endif


" }}}
" Navigation {{{
" ----------

""""""""""""""""""""""""""""""""""""""""""""
" Personal maps
""""""""""""""""""""""""""""""""""""""""""""
nnoremap <A-r> :source $MYVIMRC<CR>

"" Open URLs
function! HandleURL()
  let s:uri = matchstr(getline("."), '[a-z]*:\/\/[^ >,;]*[^\)]')
  echo s:uri
  if s:uri != ""
    silent exec "!open '".s:uri."'"
  else
    echo "No URI found in line."
  endif
endfunction
map <leader>u :call HandleURL()<cr>

""""""""""""""""""""""""""""""""""""""""""""
" Quickly open configs in a new tab
""""""""""""""""""""""""""""""""""""""""""""
nnoremap <Leader>cm	:tabnew ~/.config/nvim/config/mappings.vim<CR>:lcd %:p:h<CR>
nnoremap <Leader>cf	:tabnew ~/.config/fish/config.fish<CR>:lcd %:p:h<CR>
nnoremap <Leader>ci	:tabnew ~/.config/i3/config<CR>:lcd %:p:h<CR>
nnoremap <Leader>ct	:tabnew ~/.config/wezterm/wezterm.lua<CR>:lcd %:p:h<CR>
nnoremap <Leader>cv	:tabnew ~/.config/nvim/README.md<CR>:lcd %:p:h<CR>

" Double leader key for toggling visual-line mode
nmap <Leader><Leader> V
xmap <Leader><Leader> <Esc>

" Toggle fold
nnoremap <CR> za

" Focus the current fold by closing all others
nnoremap <S-Return> zMzv

" The plugin rhysd/accelerated-jk moves through display-lines in normal mode,
" these mappings will move through display-lines in visual mode too.
xnoremap j gj
xnoremap k gk

" Easier line-wise movement
nnoremap gh g^
nnoremap gl g$

" Location/quickfix list movement
nmap ]q <cmd>cnext<CR>
nmap [q <cmd>cprev<CR>
nmap ]a <cmd>lnext<CR>
nmap [a <cmd>lprev<CR>

" Whitespace jump (see plugin/whitespace.vim)
nnoremap ]w <cmd>WhitespaceNext<CR>
nnoremap [w <cmd>WhitespacePrev<CR>

" Navigation in command line
cnoremap <C-h> <Home>
cnoremap <C-l> <End>
cnoremap <C-f> <Right>
cnoremap <C-b> <Left>

" }}}
" Scroll {{{
" ------

" Scroll step sideways
nnoremap zl z4l
nnoremap zh z4h

" Resize tab windows after top/bottom window movement
" nnoremap <C-w>K <C-w>K<C-w>=
" nnoremap <C-w>J <C-w>J<C-w>=

" Improve scroll, credits: https://github.com/Shougo
" noremap <expr> <C-f> max([winheight(0) - 2, 1])
"	\ ."\<C-d>".(line('w$') >= line('$') ? "L" : "M")
" noremap <expr> <C-b> max([winheight(0) - 2, 1])
"	\ ."\<C-u>".(line('w0') <= 1 ? "H" : "M")
" nnoremap <expr> zz (winline() == (winheight(0)+1) / 2) ?
"	\ 'zt' : (winline() == 1) ? 'zb' : 'zz'
" noremap <expr> <C-e> (line("w$") >= line('$') ? "j" : "3\<C-e>")
" noremap <expr> <C-y> (line("w0") <= 1         ? "k" : "3\<C-y>")

" }}}
" Clipboard {{{
" ---------

" Yank from cursor position to end-of-line
nnoremap Y y$

" Yank buffer's relative/absolute path to clipboard
nnoremap <Leader>y :let @+=expand("%:~:.")<CR>:echo 'Yanked relative path'<CR>
nnoremap <Leader>Y :let @+=expand("%:p")<CR>:echo 'Yanked absolute path'<CR>

" Cut & paste without pushing to register
" xnoremap p  "0p
" nnoremap x "_x

" Paste in visual-mode without pushing to register
xnoremap p :call <SID>visual_paste('p')<CR>
xnoremap P :call <SID>visual_paste('P')<CR>

" }}}
" Edit {{{
" ----

" Macros
if get(g:, 'enable_universal_quit_mapping', 1)
	nnoremap Q q
	nnoremap gQ @q
endif

" Start new line from any cursor position in insert-mode
inoremap <S-Return> <C-o>o

" Deletes selection and start insert mode
" xnoremap <BS> "_xi

" Re-select blocks after indenting in visual/select mode
xnoremap < <gv
xnoremap > >gv|

" Use tab for indenting in visual/select mode
xnoremap <Tab> >gv|
xnoremap <S-Tab> <gv

" Indent and jump to first non-blank character linewise
" nmap >>  >>_
" nmap <<  <<_

" Drag current line/s vertically and auto-indent
nnoremap <A-k> <cmd>move-2<CR>==
nnoremap <A-j> <cmd>move+<CR>==
xnoremap <A-k> :move'<-2<CR>gv=gv
xnoremap <A-j> :move'>+<CR>gv=gv

" Duplicate lines without affecting PRIMARY and CLIPBOARD selections.
nnoremap <Leader>d m`""Y""P``
xnoremap <Leader>d ""Y""Pgv

" Change current word in a repeatable manner
nnoremap <Leader>cn *``cgn
nnoremap <Leader>cN *``cgN

" Change selected word in a repeatable manner
xnoremap <expr> <Leader>cw "y/\\V\<C-r>=escape(@\", '/')\<CR>\<CR>" . "``cgn"
xnoremap <expr> <Leader>cW "y/\\V\<C-r>=escape(@\", '/')\<CR>\<CR>" . "``cgN"

" Duplicate paragraph
nnoremap <Leader>cp yap<S-}>p

" Remove spaces at the end of lines
nnoremap <Leader>cs <cmd>keeppatterns %substitute/\s\+$//e<CR>

" }}}
" Search & Replace {{{
" ----------------

" Use backspace key for matching parens
nmap <BS> %
xmap <BS> %

" Repeat latest f, t, F or T
nnoremap \ ;

" Select last paste
nnoremap <expr> gpp '`['.strpart(getregtype(), 0, 1).'`]'

" Quick substitute within selected area
xnoremap sg :s//gc<Left><Left><Left>

" C-r: Easier search and replace visual/select mode
xnoremap <C-r> :<C-u>%s/\V<C-R>=<SID>get_selection()<CR>//gc<Left><Left><Left>

" Returns visually selected text
function! s:get_selection() abort "{{{
	try
		let a_save = @a
		silent! normal! gv"ay
		return substitute(escape(@a, '\/'), '\n', '\\n', 'g')
	finally
		let @a = a_save
	endtry
endfunction "}}}

" }}}
" Command & History {{{
" -----------------

" Start an external command with a single bang
nnoremap ! :!

" Put vim command output into buffer
nnoremap g! :put=execute('')<Left><Left>

" Allow misspellings
cnoreabbrev qw wq
cnoreabbrev Wq wq
cnoreabbrev WQ wq
cnoreabbrev Qa qa
cnoreabbrev Bd bd
cnoreabbrev bD bd

" Switch history search pairs, matching my bash shell
cnoremap <expr> <C-p>  pumvisible() ? "\<C-p>" : "\<Up>"
cnoremap <expr> <C-n>  pumvisible() ? "\<C-n>" : "\<Down>"
cnoremap <Up>   <C-p>
cnoremap <Down> <C-n>

" }}}
" File operations {{{
" ---------------

" Switch (window) to the directory of the current opened buffer
nmap <A-c> :lcd %:p:h<CR>:pwd<CR>

" Open file under the cursor in a vsplit
nnoremap gf <cmd>vertical wincmd f<CR>

" Fast saving from all modes
nnoremap <Leader>w <cmd>write<CR>
nnoremap <C-s> <cmd>write<CR>
xnoremap <C-s> <cmd>write<CR>
cnoremap <C-s> <cmd>write<CR>

" }}}
" Editor UI {{{
" ---------

" Toggle editor's visual effects
nmap <Leader>ts <cmd>setlocal spell!<CR>
nmap <Leader>tn <cmd>setlocal nonumber!<CR>
nmap <Leader>tl <cmd>setlocal nolist!<CR>
nmap <Leader>th <cmd>nohlsearch<CR>

" Smart wrap toggle (breakindent and colorcolumn toggle as-well)
nmap <Leader>tw <cmd>execute('setlocal wrap! breakindent! colorcolumn=' .
	\ (&colorcolumn == '' ? &textwidth : ''))<CR>

" Tabs: Many ways to navigate them
nnoremap g1 <cmd>tabfirst<CR>
nnoremap g5 <cmd>tabprevious<CR>
nnoremap g9 <cmd>tablast<CR>

nnoremap <A-w>     <cmd>tabclose<CR>
nnoremap <A-l>     <cmd>tabnext<CR>
nnoremap <A-h>     <cmd>tabprevious<CR>
nnoremap <A-m>     <cmd>MarkdownPreview<CR>

" Moving tabs
nnoremap <A-{> <cmd>-tabmove<CR>
nnoremap <A-}> <cmd>+tabmove<CR>

" Show syntax highlight groups for character under cursor
nmap <Leader>tt <cmd>echo 'hi<' . synIDattr(synID(line('.'), col('.'), 1), 'name')
	\ . '> trans<' . synIDattr(synID(line('.'), col('.'), 0), 'name') . '> lo<'
	\ . synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name') . '>'<CR>

" }}}
" Custom Tools {{{
" ------------


" Append mode-line to current buffer
nnoremap <Leader>ml <cmd>call <SID>append_modeline()<CR>

" Source line and selection in vim
xnoremap <Leader>S y:execute @@<CR>:echo 'Sourced selection.'<CR>
nnoremap <Leader>S ^vg_y:execute @@<CR>:echo 'Sourced line.'<CR>

" Context-aware action-menu, neovim only (see plugin/actionmenu.vim)
if has('nvim')
	nmap <LocalLeader>c <cmd>ActionMenu<CR>
endif

" Jump entire buffers in jumplist
nnoremap g<C-i> <cmd>call <SID>jump_buffer(-1)<CR>
nnoremap g<C-o> <cmd>call <SID>jump_buffer(1)<CR>


" }}}
" Windows, buffers and tabs {{{
" -------------------------

" Ultimatus Quitos
if get(g:, 'enable_universal_quit_mapping', 1)
	autocmd user_events BufWinEnter,VimEnter *
		\  if ! maparg('q', 'n')
		\|   nnoremap <buffer> q <cmd>quit<CR>
		\| endif
endif

" Switch with adjacent window
nnoremap <C-x> <C-w>x

" Window-control prefix
nnoremap  [Window]   <Nop>
nmap      s [Window]

nnoremap <C-w>			<cmd>close<CR>
nnoremap <F4>				<cmd>quit<CR>
nnoremap [Window]b  <cmd>buffer#<CR>
nnoremap [Window]d  <cmd>bdelete<CR>
nnoremap [Window]v  <cmd>split<CR>
nnoremap [Window]g  <cmd>vsplit<CR>
nnoremap [Window]t  <cmd>tabnew<CR>
nnoremap [Window]o  <cmd>only<CR>
nnoremap [Window]q  <cmd>quit<CR>
nnoremap [Window]x  <cmd>call <SID>window_empty_buffer()<CR>
nnoremap [Window]z  <cmd>call <SID>zoom()<CR>

" Split current buffer, go to previous window and previous buffer
nnoremap [Window]sv <cmd>split<CR>:wincmd p<CR>:e#<CR>
nnoremap [Window]sg <cmd>vsplit<CR>:wincmd p<CR>:e#<CR>

" Background dark/light toggle
nmap [Window]h <cmd>call <SID>toggle_background()<CR>

" }}}
" Helper functions {{{
" -------------------------

function! s:visual_paste(direction) range abort "{{{
	let registers = {}
	for name in ['"', '0']
		let registers[name] = {'type': getregtype(name), 'value': getreg(name)}
	endfor

	execute 'normal!' 'gv' . a:direction

	for [name, register] in items(registers)
		call setreg(name, register.value, register.type)
	endfor
endfunction "}}}

" Append modeline after last line in buffer
" See: http://vim.wikia.com/wiki/Modeline_magic
function! s:append_modeline() "{{{
	let l:modeline = printf(' vim: set ts=%d sw=%d tw=%d %set :',
				\ &tabstop, &shiftwidth, &textwidth, &expandtab ? '' : 'no')
	let l:modeline = substitute(&commentstring, '%s', l:modeline, '')
	call append(line('$'), l:modeline)
endfunction "}}}

" direction - 1=forward, -1=backward
" Credits: https://superuser.com/a/1455940/252171
function! s:jump_buffer(direction)
	let [ jumplist, curjump ] = getjumplist()
	let jumpcmdstr = a:direction > 0 ? '<C-o>' : '<C-i>'
	let jumpcmdchr = a:direction > 0 ? "\<C-o>" : "\<C-i>"
	let searchrange = a:direction > 0
		\ ? range(curjump - 1, 0, -1)
		\ : range(curjump + 1, len(jumplist))

	for i in searchrange
		let l:nr = jumplist[i]['bufnr']
		if l:nr != bufnr('%') && bufname(l:nr) !~? '^\a\+://'
			let n = abs((i - curjump) * a:direction)
			echo 'Executing' jumpcmdstr n . ' times'
			execute 'normal! ' . n . jumpcmdchr
			break
		endif
	endfor
endfunction

function! s:toggle_background() "{{{
	if ! exists('g:colors_name')
		echomsg 'No colorscheme set'
		return
	endif
	let l:scheme = g:colors_name

	if l:scheme =~# 'dark' || l:scheme =~# 'light'
		" Rotate between different theme backgrounds
		execute 'colorscheme' (l:scheme =~# 'dark'
					\ ? substitute(l:scheme, 'dark', 'light', '')
					\ : substitute(l:scheme, 'light', 'dark', ''))
	else
		execute 'set background='.(&background ==# 'dark' ? 'light' : 'dark')
		if ! exists('g:colors_name')
			execute 'colorscheme' l:scheme
			echomsg 'The colorscheme `'.l:scheme
				\ .'` doesn''t have background variants!'
		else
			echo 'Set colorscheme to '.&background.' mode'
		endif
	endif
endfunction "}}}

function! s:window_empty_buffer() "{{{
	let l:current = bufnr('%')
	if ! getbufvar(l:current, '&modified')
		enew
		silent! execute 'bdelete ' . l:current
	endif
endfunction "}}}

" Simple zoom toggle
function! s:zoom() "{{{
	if exists('t:zoomed')
		unlet t:zoomed
		wincmd =
	else
		let t:zoomed = { 'nr': bufnr('%') }
		vertical resize
		resize
		normal! ze
	endif
endfunction "}}}

" }}}

" vim: set foldmethod=marker ts=2 sw=2 tw=80 noet :
