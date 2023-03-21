# nin-english.vim
[English README](README_en.md)

![](sample.gif)

英語を書けないクソ雑魚日本人である僕のための英語プラグインです。
これはEJDictという辞書を使う事を前提にしています。  
だけど、同じ形式の辞書なら何でも良いと思います。

このプラグインは以下の機能を提供します。
- Ddcによる非同期自動補完
- 英和辞典
- 辞書のアップデート
- カスタム辞書
- なんちゃってシンタックスハイライト

あと、英語も併記しますね。  
理由は辞書さえ用意できれば他の言語でも問題なく利用可能だからです。
ただし、英語である必要はあります。

# 依存関係
- git
- deno
- denops

Denopsとdenoはインストールされていないといけません。  
もちろん、vim-tinyのような制限付きvimでは動きません。  

Gitは辞書をダウンロードするために必要です。


# インストール
Vimplugの場合はこんな感じかと。

```
Plug 'uesseu/nin-english.vim'
```

Deinならこうです。
```
call dein#add('uesseu/nin-english.vim')
```

その上で、'g:nin_english#dict_dir'を設定する必要があります。  
この変数は辞書のパスを指し示します。  
この変数は自由でいいです。インストールの時にこのディレクトリに入れます。  

```vim
let g:nin_english#dict_dir = '/home/[user]/.local/share/EJDict'
```

# 辞書のインストール
nin-englishをインストールするだけでは駄目です。  
こいつはEJDict辞書なしには動くことが出来ません。
下記のコマンドでこのリポジトリの辞書をダウンロードできます。
https://github.com/kujirahand/EJDict

```vim
call InstallEJDict()
```

EJDictという素晴らしい辞書のおかげで動きます！
この辞書はパブリックドメインです。
もし、手動で辞書をインストールしたければここからも出来るとは思います。

https://kujirahand.com/web-tools/EJDictFreeDL.php

けれども、このプラグインはgit経由を前提としています。

# 設定例
一旦設定例を示します。
```vim
" ddcへの登録
call ddc#custom#patch_global('sources', ['vim-lsp', 'around', 'ninenglish'])

" 辞書のパスの設定
let g:nin_english#dict_dir = '/home/[user]/.local/share/EJDict'
call ddc#custom#patch_global('sourceParams', #{
  \   ninenglish: #{dict_fname: 'g:nin_english#dict_dir'}})

" ddc全体の設定
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

" Hoverの設定
nnoremap <buffer> K :call NinCloseFloat()<CR>:call EnglishSearch()<CR>

" なんちゃってシンタックスハイライト
call NinEnglishHilight()
```


# 自動補完
もしddcが入っているならば下記のように設定すれば自動で補完されます。
けれども、この設定は少し複雑です。
下記の例ではvim-lspとaroundも一緒に入れた例です。  
g:nin_english#dict_pathをこの中に入れ込んで下さい。

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

# 単語の検索
カーソル上の単語を検索したいことはあるかも知れません。
この単語がカーソル上の単語を検索してくれます。
```vim
call EnglishSearch()
```
ただし、この関数はフロートウィンドウを閉じません。  
閉じるためには'NinCloseFloat'という関数を呼ぶといいです。  
だから、例えば'K'に単語検索の機能を割り当てたければ下記のようにします。  
```vim
nnoremap <buffer> K :call NinCloseFloat()<CR>:call EnglishSearch()<CR>
```

# カスタム辞書
辞書に色々追加することが出来ます。
例えば'a'という名前の辞書を作りたいならばこうします。
```vim
call EnglishCustomDictEdit('a')
```
書式はこんな感じです。

```
<word><tab><line1>/<line2>/<line3>/...
```
例えばこうです。

```
example	例/見本/見せしめ
```

もし、カスタム辞書のリストを表示したければ、下記のようにします。
If you want to show list of custom dictionaries, call bellow.
```vim
call	EnglishCustomDictList()
```

もし、'a'という名前のカスタム辞書を削除したければ下記のようにします。
If you want to delete a custom dictionary named 'a', call bellow.
```vim
call EnglishCustomDictDelete('a')
```

ちなみに、カスタム辞書は辞書ディレクトリの中の
'src'の中に'custom-'という頭文字付きで保存されます。

# なんちゃってシンタックスハイライト
英語のような自然言語にシンタックスハイライトを入れるのは容易ではありません。
遅くなりますし、プログラムを書くのもダルいです。
だから、なんちゃってシンタックスハイライトをつけました。
要らないかも？下記のコマンドでつけられます。

```vim
call NinEnglishHilight()
```

# EJDictの書式
辞書の書式はカスタム辞書を編集する時には必要です。  
EJDictはTSVの様な書式であって、下記のような感じです。
```
[word][tab][mean1/mean2/mean3/...]
```

もしかすると、これは互換性のある辞書があれば  
外人にも有用かも知れないです。  
まぁ、僕は糞JAPオスな上にエンジニアですらないから分かりません。  

# ライセンス
この大したこと無いソフト自体はMITライセンスにしておきます。
EJDictは内蔵していませんし、ライセンスも違うと思います。
