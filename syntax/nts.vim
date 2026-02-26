"" runtime! syntax/markdown.vim

syntax match decimal /\<\d\+\>/
highlight decimal guifg=#44aaff

syntax match hexadecimal /\<0x[0-9a-fA-F]\+\>/
highlight hexadecimal guifg=#9955ff

syntax match binary /\<0b[01]\+\>/
highlight binary guifg=#2277ff

syntax match ntsBackslash /\\\k\+/
highlight ntsBackslash guifg=#ff7777 gui=italic

syntax match preproc /#.[^ ]\+/
highlight preproc guifg=#aa77ff

syntax match ntsHeading /^---- .* ----$/
highlight ntsHeading guifg=#88bb88 gui=bold

syntax match keyword /@[^ ]\+/
highlight keyword guifg=#ffaa22

syntax match triplebang /^!!!.*/
highlight triplebang guifg=#ff0000 gui=bold

syntax match term /'[^ ]\+/
highlight term gui=bold

