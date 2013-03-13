set showtabline=2 " always show tab line to prevent resize bug.

" Automatically write files when focus is lost
if has("autocmd")
  :au FocusLost * silent! :wa " Dont complain about unnamed buffers
endif
