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
  , Camera
  , Cameras
  , isPlayerHit
  ) where

import Data.List.Split
import GameData

side :: Integer -- a side of level
side = 36

splitRawLevel :: String -> [[[Char]]] -- split level-string on ""
splitRawLevel l = map (splitOn "") (lines l)

flatten :: [[a]] -> [a]
flatten = foldl (++) []

notEmpty :: [a] -> Bool -- used for filtering out empty items in "map" list
notEmpty x = length x > 0

purgedLevel :: [String] -- splits "map" list to list of string containing tile
purgedLevel = filter notEmpty $ flatten (splitRawLevel rawLevel)

getY :: Integer -> Integer -> Integer -- get y position on level in list
getY i w = div i w

getX :: Integer -> Integer -> Integer -- get x position on level in list
getX i w = mod i w

type Position = (Integer, Integer)

type Tile = String

type Cell = (Position, Tile)

type Level = [Cell]

level :: Level -- creates a level 
level =
  [ ((getX (toInteger x) side, getY (toInteger x) side), y)
  | x <- [0 .. length purgedLevel]
  | y <- purgedLevel
  ]

isMovePossible :: Integer -> Integer -> String -> Level -> Bool -- can player move to cell
isMovePossible x y direction l
  | direction == "Up" && not (((x, (y - 1)), "x") `elem` l) = True
  | direction == "Right" && not ((((x + 1), y), "x") `elem` l) = True
  | direction == "Down" && not (((x, (y + 1)), "x") `elem` l) = True
  | direction == "Left" && not ((((x - 1), y), "x") `elem` l) = True
  | otherwise = False

getPosition :: Cell -> Position -- get Position of a Cell
getPosition cell = fst cell

getCellX :: Position -> Integer -- get x from Position of a Cell
getCellX pos = toInteger (fst pos)

getCellY :: Position -> Integer -- get y from Position of a Cell
getCellY pos = toInteger (snd pos)

getTile :: Cell -> Tile -- get tile from a Cell
getTile cell = snd cell


isCamera :: Cell -> Bool -- is cell a camera?
isCamera cell = (getTile cell) == "c"

createCameraProps :: Cell -> Camera -- creates a camera holding a Position and x diff
createCameraProps cell = ((getPosition cell), 1)

type Camera = (Position, Integer)

type Cameras = [Camera]

getCameras :: Level -> Cameras -- find cameras on level and create Cameras
getCameras l = map createCameraProps $ filter isCamera l

getCameraDiff :: Camera -> Integer -- get temp x diff of a camera
getCameraDiff camera = snd camera

isPlayerHit :: Camera -> Integer -> Integer -> Bool -- is player hit?
isPlayerHit cam x y =
  (((getCellX $ fst cam) + snd cam), getCellY $ fst cam) == (x, y)

camMove :: Camera -> Level -> Camera -- move a camera x diff (if wall, restart)
camMove camera l =
  if ( ( ((getCellX $ fst camera) + (getCameraDiff camera) + 1)
       , (getCellY $ fst camera))
     , ".") `elem`
     l
    then ( ((getCellX $ fst camera), (getCellY $ fst camera))
         , ((getCameraDiff camera) + 1))
    else (((getCellX $ fst camera), (getCellY $ fst camera)), 1)

moveCameras :: Cameras -> Level -> Cameras -- move cameras "shots"
moveCameras cs l = map (\c -> camMove c l) cs

cameras :: Cameras
cameras = getCameras level

isNotASpecificCell :: Cell -> Cell -> Bool -- used for filtering out a Cell from Level 
isNotASpecificCell cell1 cell2 = cell1 /= cell2

removeCherry :: Cell -> Level -> Integer -> Integer -> Level -- remove a cherry Cell from Level
removeCherry oldCell l x y = (filter (isNotASpecificCell oldCell) l) ++ [((x, y), ".")]

isCherry :: Integer -> Integer -> Level -> Bool -- is player position at a cherry Cell?
isCherry x y l = ((x, y), "o") `elem` l

checkScore :: Level -> Integer -> Integer -> Integer -> Integer -- if on cherry Cell, inc score
checkScore l x y score =
  if (isCherry x y l)
    then (score + 1)
    else score

checkLevel :: Level -> Integer -> Integer -> Level -- if on cherry cell, replace cell with floor
checkLevel l x y =
  if (isCherry x y l)
    then (removeCherry ((x, y), "o") l x y)
    else l
