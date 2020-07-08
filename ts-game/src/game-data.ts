export function getLevel() {
  const rawLevel = ` 
xxxxxxxwxxxxxxbbbbbbxxxxxxxxxxxxxbbb
xx....xxx....xxxbbbbxo.....xxxxxxxxx
x..............xxxxbx.........xxxxxx
x.................xxx..........xxxxx
xxxxxxxxx...........x.......xxxxxxxx
xxxxx............xxxxxx.o.......xxxx
wwx............xxxxxxx.............x
xxxxxxxxxxc......xx......xxx.......x
x.oxxxxxxxx...............xxx......x
x.....xxxxxxx............xxx...o...x
xxxx.....xxx.............xxx.......x
wwwx................c.............xx
wxxx................x...........xxxw
xx.....xxxx.......xxx.........xxxwww
x.o....xxxxxxx.....x.....xxxxxxwwwww
x......xxxxxxxc.........oxxxxxxxwwww
xxx....xxxx......x.......xxxxxxxxwww
wwx....xxxxo....xxx............oxxww
wxxxx............................xxx
xx...........xx..x..........c......x
xxx..o.....xxxxxxxxx........x.....xx
xx......xxxxxwwxxx........xxxx...xxx
x..........xxwxxxx.........xxx.....x
xxx........xxxxxxxxxx.......x......x
xxxxx........x..xxxxx.............xx
xxwxxxx...........................xw
wwwwwxx..o....................xxxxxw
wwwxxxxx............o.............xx
wwwwx.............................xx
xxxxxc....xxxx.............xxx...xxx
x.oxxxx.....x......xxxx.xxxxwxx..xww
xx...xx............xwwxxxwwwwx...xxx
wx....x............xxwwwwwxxxx.....x
wxx.................xxwwwwxo....x..x
wwxxxxx............xxwwwwxx...xxxx.x
wwwxxxxxxxxxxxxxxxxxxwwwxxxxxxxwwxxx`
  return rawLevel
    .trim()
    .split('\n')
    .map((row) => row.split(''));
}
