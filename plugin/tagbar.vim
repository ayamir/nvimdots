let g:rust_use_custom_ctags_defs = 1  "ignore https://github.com/rust-lang/rust.vim/blob/master/ctags/rust.ctags
if !exists('g:tagbar_type_rust')
	let g:tagbar_type_rust = {
				\ 'ctagstype' : 'rust',
				\ 'kinds' : [ "https://github.com/universal-ctags/ctags/blob/master/parsers/rust.c#L50-L61",
				\'M:macro,Macro Definition',
				\'P:method,A method',
				\'c:implementation,implementation',
				\'e:enumerator,An enum variant',
				\'f:function,Function',
				\'g:enum,Enum',
				\'i:interface,trait interface',
				\'m:field,A struct field',
				\'n:module,module',
				\'s:struct,structural type',
				\'t:typedef,Type Alias',
				\'v:variable,Global variable',
				\ ]
				\ }
endif

