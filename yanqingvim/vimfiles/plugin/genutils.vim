if exists('loaded_genutils')
  finish
endif
if v:version < 700
  echomsg 'genutils: You need at least Vim 7.0'
  finish
endif

let loaded_genutils = 205
