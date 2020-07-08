export type Level = string[][]

export function getLevel(): Level {
  const rawLevel: string = ` 
xxxxxxxbxxxxxxbbbbbbxxxxxxxxxxxxxbbb
xx....xxx....xxxbbbbxo.....xxxxxxxxx
x..............xxxxbx.........xxxxxx
x.................xxx..........xxxxx
xxxxxxxxx...........x.......xxxxxxxx
xxxxx............xxxxxx.o.......xxxx
bbx............xxxxxxx.............x
xxxxxxxxxxc......xx......xxx.......x
x.oxxxxxxxx...............xxx......x
x.....xxxxxxx............xxx...o...x
xxxx.....xxx.............xxx.......x
bbbx................c.............xx
bxxx................x...........xxxb
xx.....xxxx.......xxx.........xxxbbb
x.o....xxxxxxx.....x.....xxxxxxbbbbb
x......xxxxxxxc.........oxxxxxxxbbbb
xxx....xxxx......x.......xxxxxxxxbbb
bbx....xxxxo....xxx............oxxbb
bxxxx............................xxx
xx...........xx..x..........c......x
xxx..o.....xxxxxxxxx........x.....xx
xx......xxxxxbbxxx........xxxx...xxx
x..........xxbxxxx.........xxx.....x
xxx........xxxxxxxxxx.......x......x
xxxxx........x..xxxxx.............xx
xxbxxxx...........................xb
bbbbbxx..o....................xxxxxb
bbbxxxxx............o.............xx
bbbbx.............................xx
xxxxxc....xxxx.............xxx...xxx
x.oxxxx.....x......xxxx.xxxxbxx..xbb
xx...xx............xbbxxxbbbbx...xxx
bx....x............xxbbbbbxxxx.....x
bxx.................xxbbbbxo....x..x
bbxxxxx............xxbbbbxx...xxxx.x
bbbxxxxxxxxxxxxxxxxxxbbbxxxxxxxbbxxx`
  return rawLevel
    .trim()
    .split('\n')
    .map((row) => row.split(''));
}
