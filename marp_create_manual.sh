#!/opt/homebrew/bin/fish
set dir $argv[1]
set filename $argv[2]
marp --input-dir $dir --theme ./style/manual.css --pdf --allow-local-files
open $dir/$filename.pdf
