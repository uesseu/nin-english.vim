# jpn-eng.vim
![](sample.gif)

A vim plugin for Japanese person, who has to write English ('A`).  
It is based on EJDict, wonderful english-japanese dictionary.  

This plugin offers
- Ddc based asynchronous completion.
- English to Japanese Dictionary.
- Installing and Updating Dictionary.
- Syntax highlight of English(It may be useful only for me.)

# Speed
The speed of search is relatively good.  
Because these functions are made by deno.  
Especially, speed of deno is good.  

# Dependency
- git
- deno
- denops

Denops plugin must be installed.  
(Of cource, it must not be vim-tiny.)  

Git is needed only for downloading dictionary.

# Install
for vimplug

```
Plug 'uesseu/nin-english-vim'
```

for dein
```
call dein#add('uesseu/nin-english-vim')
```

And then, you should set 'g:nin_english#dict_dir'.  
It should be path of dictionary.  

```vim
let g:nin_english#dict_dir = '/home/[user]/.local/share/EJDict'
let g:nin_english#dict_fname = 'dict.txt'
```

# Install dictionary
After you install nin-english.vim, EJDict is needed to run.  
This command download and construct dictionary from this repo.  
https://github.com/kujirahand/EJDict

```vim
call InstallEJDict()
```

Thanks to EJDict! It is public domain!  

If you want to install dictionary manually,
this dictionary can be downloaded from here.  

https://kujirahand.com/web-tools/EJDictFreeDL.php

However, this plugin does not use the dictionary of the url.

# Example
This is part of example.

```vim
" Registration of plugin to ddc.
call ddc#custom#patch_global('sources', ['vim-lsp', 'around', 'ninenglish'])

" Setting of path
let g:nin_english#dict_dir = '/home/[user]/.local/share/EJDict'
call ddc#custom#patch_global('sourceParams', #{
  \   ninenglish: #{dict_fname: 'g:nin_english#dict_dir'}})

" Whole setting of ddc
call ddc#custom#patch_global('sourceOptions', #{
  \   _: #{
  \     matchers: ['matcher_fuzzy'],
  \     sorters: ['sorter_fuzzy'],
  \     converters: ['converter_fuzzy']
  \   },
  \   around: #{ mark: 'Around'},
  \   ninenglish: #{ mark: 'English'},
  \   vim-lsp: #{
  \     mark: 'LSP',
  \     forceCompletionPattern: '\w+|\.\w*|:\w*|->\w*' },
  \ })

" Key binding of hover.
nnoremap <buffer> K :call NinCloseFloat()<CR>:call EnglishSearch()<CR>

" Pseudo syntax hilight
call NinEnglishHilight()
```
# Auto Completion
If you use ddc, ddc completes automatically.  
Ddc completes automatically and quickly.  
However, configuration may be difficult a little.  
This example involves vim-lsp and around plugin.  
Please insert g:nin_english#dict_path into sourceParams.

```vim
call ddc#custom#patch_global('sources', ['vim-lsp', 'around', 'ninenglish'])
call ddc#custom#patch_global('sourceOptions', #{
  \   _: #{
  \     matchers: ['matcher_fuzzy'],
  \     sorters: ['sorter_fuzzy'],
  \     converters: ['converter_fuzzy']
  \   },
  \   around: #{ mark: 'Around'},
  \   ninenglish: #{ mark: 'English'},
  \   vim-lsp: #{
  \     mark: 'LSP',
  \     forceCompletionPattern: '\w+|\.\w*|:\w*|->\w*' },
  \ })
call ddc#custom#patch_global('sourceParams', #{
  \   ninenglish: #{dict_fname: 'g:nin_english#dict_dir'}})
```

# Search words
I did not set the key bind of hover.  
This function searches the word on cursor.

```vim
call EnglishSearch()
```

However, this function does not close float window.  
And so, closing function, named 'NinCloseHoverFloat' is needed.  
this command makes 'K' hover like function.  
```vim
nnoremap <buffer> K :call NinCloseHoverFloat()<CR>:call EnglishSearch()<CR>
```

# Custom dictionary
If you want to make custom dictionary named 'a', call bellow.
```vim
call EnglishCustomDictEdit('a')
```

The format is like this.

```
<word><tab><line1>/<line2>/<line3>/...
```
For example...

```
example	例/見本/見せしめ
```

If you want to show list of custom dictionaries, call bellow.
```vim
call EnglishCustomDictList()
```

If you want to delete a custom dictionary named 'a', call bellow.
```vim
call EnglishCustomDictDelete('a')
```

The custom dictionaries are placed in 'scr' directory.
And named like this 'custom-<name>'.

# Pseudo syntax hilight
Running syntax hilight of such language as English is not easy.  
It must be slow and not easy to write program.  
And so, I made pseudo syntax hilight.  
This can be run by this command.

```vim
call NinEnglishHilight()
```
# EJDict format
The dictionary must be TSV format.
EJDict is TSV format like below.

```
[word][tab][mean1/mean2/mean3/...]
```

Perhaps, it may be useful for people in other country,
if there is compatible dictionary.
But I am not sure.  
I am just a Japanese monkey, furthermore am not engineer.

# License
License of this software, which is not great, is MIT.  
However, license of EJDict is not MIT.
