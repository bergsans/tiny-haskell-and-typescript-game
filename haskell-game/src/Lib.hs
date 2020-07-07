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
  , checkLevel
  , checkScore
  , cameras
  , moveCameras
  , getCameraDiff
  , Cameras
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

isCamera :: Cell -> Bool
isCamera cell = (getTile cell) == "c"

createCameraProps cell = ((getPosition cell), 1)

type Camera = (Position, Integer)

type Cameras = [Camera]

getCameras :: Level -> Cameras
getCameras l = map createCameraProps $ filter isCamera l

getCameraDiff :: Camera -> Integer
getCameraDiff camera = snd camera

camMove :: Camera -> Level -> Camera
camMove camera l =
  if ((((getCellX $ fst camera) + (getCameraDiff camera) + 1), (getCellY $ fst camera)), ".") `elem` l
    then (((getCellX $ fst camera), (getCellY $ fst camera)), ((getCameraDiff camera) + 1))
    else (((getCellX $ fst camera), (getCellY $ fst camera)), 1)

moveCameras cs l = map (\c -> camMove c l) cs

cameras :: Cameras
cameras = getCameras level

level :: Level
level =
  [ ((getX (toInteger x) side, getY (toInteger x) side), y)
  | x <- [0 .. length purgedLevel]
  | y <- purgedLevel
  ]

isMovePossible :: Integer -> Integer -> String -> Level -> Bool
isMovePossible x y direction l
  | direction == "Up" && not (((x, (y - 1)), "x") `elem` l) = True
  | direction == "Right" && not ((((x + 1), y), "x") `elem` l) = True
  | direction == "Down" && not (((x, (y + 1)), "x") `elem` l) = True
  | direction == "Left" && not ((((x - 1), y), "x") `elem` l) = True
  | otherwise = False

getPosition :: Cell -> Position
getPosition cell = fst cell

getCellX :: Position -> Integer
getCellX pos = toInteger (fst pos)

getCellY :: Position -> Integer
getCellY pos = toInteger (snd pos)

getTile :: Cell -> Tile
getTile cell = snd cell

isNotCell :: Cell -> Cell -> Bool
isNotCell cell1 cell2 = cell1 /= cell2

removeCherry :: Cell -> Level -> Integer -> Integer -> Level
removeCherry oldCell l x y = (filter (isNotCell oldCell) l) ++ [((x, y), ".")]

isCherry :: Integer -> Integer -> Level -> Bool
isCherry x y l = ((x, y), "o") `elem` l

checkScore :: Level -> Integer -> Integer -> Integer -> Integer
checkScore l x y score =
  if (isCherry x y l)
    then (score + 1)
    else score

checkLevel :: Level -> Integer -> Integer -> Level
checkLevel l x y =
  if (isCherry x y l)
    then (removeCherry ((x, y), "o") l x y)
    else l
