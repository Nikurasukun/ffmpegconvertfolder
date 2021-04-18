# FCF
(FFmpeg Convert Folder)
## What is this?
FCF is a little Bash-Script to convert the media files an entire folder using FFmpeg. Not more and not less.
## How to use it?
You can eather use it in portable mode, move the script to the folder you want to convert and launch it there with:
```bash
./convert.sh -i {input format} -o {output format} -q {audio quality}
```
But you can also move the script to a folder like `~/.scripts` and use an alias like `fcf.`

Currently the script only supports audio conversion, but I will add video support in the near future.