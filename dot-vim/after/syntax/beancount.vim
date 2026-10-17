" vim-beancount links beanLink to Comment, and YouCompleteMe doesn't complete
" inside comments (g:ycm_complete_in_comments), so after typing '^' the link
" completions were never refiltered. Use a group that isn't a comment.
highlight link beanLink Special
