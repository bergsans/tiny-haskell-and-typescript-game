module GameData (
    rawLevel
  , monsterWantsCookiesLogo
) where

rawLevel :: String -- raw string representation of level
rawLevel = "\
\xxxxxxxwxxxxxxbbbbbbxxxxxxxxxxxxxbbb\n\
\xx....xxx....xxxbbbbxo.....xxxxxxxxx\n\
\x..............xxxxbx.........xxxxxx\n\
\x.................xxx..........xxxxx\n\
\xxxxxxxxx...........x.......xxxxxxxx\n\
\xxxxx............xxxxxx.o.......xxxx\n\
\wwx............xxxxxxx.............x\n\
\xxxxxxxxxxc......xx......xxx.......x\n\
\x.oxxxxxxxx...............xxx......x\n\
\x.....xxxxxxx............xxx...o...x\n\
\xxxx.....xxx.............xxx.......x\n\
\wwwx................c.............xx\n\
\wxxx................x...........xxxw\n\
\xx.....xxxx.......xxx.........xxxwww\n\
\x.o....xxxxxxx.....x.....xxxxxxwwwww\n\
\x......xxxxxxxc.........oxxxxxxxwwww\n\
\xxx....xxxx......x.......xxxxxxxxwww\n\
\wwx....xxxxo....xxx............oxxww\n\
\wxxxx............................xxx\n\
\xx...........xx..x..........c......x\n\
\xxx..o.....xxxxxxxxx........x.....xx\n\
\xx......xxxxxwwxxx........xxxx...xxx\n\
\x..........xxwxxxx.........xxx.....x\n\
\xxx........xxxxxxxxxx.......x......x\n\
\xxxxx........x..xxxxx.............xx\n\
\xxwxxxx...........................xw\n\
\wwwwwxx..o....................xxxxxw\n\
\wwwxxxxx............o.............xx\n\
\wwwwx.............................xx\n\
\xxxxxc....xxxx.............xxx...xxx\n\
\x.oxxxx.....x......xxxx.xxxxwxx..xww\n\
\xx...xx............xwwxxxwwwwx...xxx\n\
\wx....x............xxwwwwwxxxx.....x\n\
\wxx.................xxwwwwxo....x..x\n\
\wwxxxxx............xxwwwwxx...xxxx.x\n\
\wwwxxxxxxxxxxxxxxxxxxwwwxxxxxxxwwxxx"

monsterWantsCookiesLogo = "\
\   ███    ███  ██████  ███    ██ ███████ ████████ ███████ ██████  \n\
\   ████  ████ ██    ██ ████   ██ ██         ██    ██      ██   ██ \n\
\   ██ ████ ██ ██    ██ ██ ██  ██ ███████    ██    █████   ██████  \n\
\   ██  ██  ██ ██    ██ ██  ██ ██      ██    ██    ██      ██   ██ \n\
\   ██      ██  ██████  ██   ████ ███████    ██    ███████ ██   ██ \n\
\                                                                  \n\
\                                                                  \n\
\   ██     ██  █████  ███    ██ ████████ ███████                   \n\
\   ██     ██ ██   ██ ████   ██    ██    ██                        \n\
\   ██  █  ██ ███████ ██ ██  ██    ██    ███████                   \n\
\   ██ ███ ██ ██   ██ ██  ██ ██    ██         ██                   \n\
\    ███ ███  ██   ██ ██   ████    ██    ███████                   \n\
\                                                                  \n\
\                                                                  \n\
\    ██████  ██████   ██████  ██   ██ ██ ███████ ███████           \n\
\   ██      ██    ██ ██    ██ ██  ██  ██ ██      ██                \n\
\   ██      ██    ██ ██    ██ █████   ██ █████   ███████           \n\
\   ██      ██    ██ ██    ██ ██  ██  ██ ██           ██           \n\
\    ██████  ██████   ██████  ██   ██ ██ ███████ ███████           \n\
\   \n\
\   \n\
\   - A Tiny Haskell Game (learning project).\n\
\     By Claes-Magnus Berg <claes-magnus@herebeseaswines.net>"
                                                               
