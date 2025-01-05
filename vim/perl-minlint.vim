" perl-minlint - lint everytime you save perl script
" Version: 0.0.1
" Author: KOBAYASHI, Hiroaki <hkoba@cpan.org>
" Copyright (c) 2014 KOBAYASHI, Hiroaki
" License: Modified BSD License

autocmd BufWritePost *.pl,*.pm call HighlightPerlLintErrors()

function! HighlightPerlLintErrors()
    " 実行中のファイルをperlminlintでチェック
    let l:output = system('perlminlint ' . shellescape(expand('%')))

    " ハイライト用のリセット
    silent! call clearmatches()

    let l:regex = '\vline\s(\d+),'  " 行番号を取得する正規表現
    let l:highlighted = 0

    " 出力を行ごとに分解して処理
    let l:lines = split(l:output, "\n")
    for l:line in l:lines
        if l:line =~ l:regex
            " 行番号を抽出
            let l:line_number = substitute(l:line, '.*line\s\(\d\+\),.*', '\1', '')

            " 正しい形式の正規表現を構築
            if l:line_number != ''
                let l:pattern = '\%' . l:line_number . 'l.*'

                " エラー行をハイライト
                call matchadd('ErrorMsg', l:pattern)
                let l:highlighted = 1
            endif
        endif
    endfor

    " ハイライト後に画面を更新
    redraw
    echo l:output

endfunction
