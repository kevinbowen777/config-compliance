 #/bin/bash
 
 find -name "2*" -type d -mtime 14 | sed 's!^\./!!' | xargs -n 1 -I DIRNAME  zip -m -r archive/DIRNAME.zip DIRNAME
 
