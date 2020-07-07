{-# LANGUAGE ParallelListComp #-}

module Lib
  ( getPosition
  , getCellX
  , getCellY
  , getTile
  , level
  , Cell
  , Level
  , isMovePossible
  , Tile
  ) where

import Data.List.Split
import GameData

side :: Integer -- a side of level
side = 36

splitRawLevel :: String -> [[[Char]]] -- split level-string on ""
splitRawLevel l = map (splitOn "") (lines l)

flatten :: [[a]] -> [a]
flatten = foldl (++) []

notEmpty :: [a] -> Bool
notEmpty x = length x > 0

purgedLevel :: [String]
purgedLevel = filter notEmpty $ flatten (splitRawLevel rawLevel)

getY :: Integer -> Integer -> Integer
getY i w = div i w

getX :: Integer -> Integer -> Integer
getX i w = mod i w

type Position = (Integer, Integer)

type Tile = String

type Cell = (Position, Tile)

type Level = [Cell]

level :: Level
level =
  [ ((getX (toInteger x) side, getY (toInteger x) side), y)
  | x <- [0 .. length purgedLevel]
  | y <- purgedLevel
  ]

isMovePossible :: Integer -> Integer-> String -> Level -> Bool
isMovePossible x y direction l
  | direction == "Up"    && not (((x, (y - 1)), "x") `elem` l) = True
  | direction == "Right" && not ((((x + 1), y), "x") `elem` l) = True
  | direction == "Down"  && not (((x, (y + 1)), "x") `elem` l) = True
  | direction == "Left"  && not ((((x - 1), y), "x") `elem` l) = True
  | otherwise = False

getPosition :: Cell -> Position
getPosition cell = fst cell

getCellX :: Position -> Integer
getCellX pos = toInteger(fst pos)

getCellY :: Position -> Integer
getCellY pos = toInteger(snd pos)

getTile :: Cell -> Tile
getTile cell = snd cell

