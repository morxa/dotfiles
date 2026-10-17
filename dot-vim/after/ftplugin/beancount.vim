" vim-beancount's indentexpr returns -1 ("keep indent") for a new line after a
" posting, which without autoindent means column 0.
setlocal autoindent
" Re-indent as soon as a ':' is typed, so a line that turns out to be a posting
" (after metadata) or metadata gets its proper indent.
setlocal indentkeys+=<:>
let b:undo_ftplugin .= ' | setlocal autoindent< indentkeys<'
