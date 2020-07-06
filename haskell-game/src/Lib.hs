{-# LANGUAGE ParallelListComp #-}

module Lib
  ( getPosition
  , getCellX
  , getCellY
  , printable
  , getTile
  , level
  , Cell
  , Level
  ) where

import Data.List.Split
-- import RawLevel -- contains the level :: String

rawLevel :: String -- raw string representation of level
rawLevel = "\
\xxxxxxxwxxxxxxbbbbbbxxxxxxxxxxxxxbbb\n\
\xx..o.xxx....xxxbbbbxo.....xxxxxxxxx\n\
\x..............xxxxbx.........xxxxxx\n\
\x.................xxx..........xxxxx\n\
\xxxxxxxxx...........x.......xxxxxxxx\n\
\xxxxx............xxxxxx.o.......xxxx\n\
\wwx............xxxxxxx.............x\n\
\xxxxxxxxxxp......xx......xxx.......x\n\
\x.oxxxxxxxx...............xxx......x\n\
\x.....xxxxxxx............xxx...o...x\n\
\xxxx.....xxx.............xxx.......x\n\
\wwwx............o...q.............xx\n\
\wx..................x...........xxxw\n\
\xx.....xxxx.......xxx.........xxxwww\n\
\x.o....xxxxxxx.....x.....xxxxxxwwwww\n\
\x......xxxxxxx..........oxxxxxxxwwww\n\
\xxx....xxxx......x.......xxxxxxxxwww\n\
\wwx....xxxxo....xxx............oxxww\n\
\wxxxx............................xxx\n\
\xx...........xx..x..........q......x\n\
\xxx..o.....xxxxxxxxx........x.....xx\n\
\xp......xxxxxwwxxx........xxxx...xxx\n\
\x..........xxwxxxx.........xxx.....x\n\
\xxx........xxxxxxxxxx.......x......x\n\
\xxxxx........x..xxxxx.............xx\n\
\xxwxxxx...........................xw\n\
\wwwwwxx..o....................xxxxxw\n\
\wwwxxxxx............o.............xx\n\
\wwwwx.............................xx\n\
\xxxxxp....xxxx.............xxx...xxx\n\
\x.oxxxx.....x......xxxx.xxxxwxx..xww\n\
\xx...xx............xwwxxxwwwwx...xxx\n\
\wx....x............xxwwwwwxxxx.....x\n\
\wxx.................xxwwwwxo....x..x\n\
\wwxxxxx.....q......xxwwwwxx...xxxx.x\n\
\wwwxxxxxxxxxxxxxxxxxxwwwxxxxxxxwwxxx"

side :: Int -- a side of level
side = 36

splitRawLevel :: String -> [[[Char]]] -- split level-string on ""
splitRawLevel l = map (splitOn "") (lines l)

flatten :: [[a]] -> [a]
flatten = foldl (++) []

notEmpty :: [a] -> Bool
notEmpty x = length x > 0

purgedLevel :: [String]
purgedLevel = filter notEmpty $ flatten (splitRawLevel rawLevel)

getY :: Int -> Int -> Int
getY i w = div i w

getX :: Int -> Int -> Int
getX i w = mod i w

type Position = (Int, Int)

type Tile = String

type Cell = (Position, Tile)

type Level = [Cell]

level :: Level
level =
  [ ((getX x side, getY x side), y)
  | x <- [0 .. length purgedLevel]
  | y <- purgedLevel
  ]

getPosition :: Cell -> Position
getPosition cell = fst cell

getCellX :: Position -> Integer
getCellX pos = toInteger(fst pos)

getCellY :: Position -> Integer
getCellY pos = toInteger(snd pos)

getTile :: Cell -> Tile
getTile cell = snd cell

printable :: Tile -> String
printable tile
  | tile == "." = ".."
  | tile == "p" = "📷"
  | tile == "q" = "📷"
  | tile == "x" = "🌲"
  | tile == "o" = "🍪"
  | otherwise   = "  "

