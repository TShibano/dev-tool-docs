#!/opt/homebrew/bin/fish
set dir $argv[1]
set filename $argv[2]
marp --theme ./style/manual.css --pdf --allow-local-files $dir/$filename.md
open $dir/$filename.pdf
