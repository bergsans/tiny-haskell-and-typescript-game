{-# LANGUAGE ParallelListComp #-}

module Lib
  ( getPos
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
  , moveCams
  , getCamDiff
  , Camera
  , Cameras
  , isAnyCamAtPlr
  ) where

import           Data.List.Split
import           GameData

-- a side of level
side :: Integer
side = 36

-- split level-string on ""
splitRawLevel :: String -> [[String]]
splitRawLevel l = map (splitOn "") (lines l)

-- flatten a list one level
flatten :: [[a]] -> [a]
flatten = foldl (++) []

-- used for filtering out empty items in "map" list
notEmpty :: [a] -> Bool
notEmpty x = not (null x)

-- splits "map" list to list of string containing tile
purgedLevel :: [String]
purgedLevel = filter notEmpty $ flatten $ splitRawLevel rawLevel

-- get y position on level in list
getY :: Integer -> Integer -> Integer
getY = div

-- get x position on level in list
getX :: Integer -> Integer -> Integer
getX = mod

type Position = (Integer, Integer)

type Tile = String

type Cell = (Position, Tile)

type Level = [Cell]

-- creates a level
level :: Level
level =
  [ ((getX (toInteger x) side, getY (toInteger x) side), y)
  | x <- [0 .. length purgedLevel]
  | y <- purgedLevel
  ]

-- can player move to cell
isMovePossible :: Integer -> Integer -> String -> Level -> Bool
isMovePossible x y direction l
  | direction == "Up"    && notElem ((x, y - 1), "x") l = True
  | direction == "Right" && notElem ((x + 1, y), "x") l = True
  | direction == "Down"  && notElem ((x, y + 1), "x") l = True
  | direction == "Left"  && notElem ((x - 1, y), "x") l = True
  | otherwise = False

-- get Position of a Cell
getPos :: Cell -> Position
getPos = fst

-- get x from Position of a Cell
getCellX :: Position -> Integer
getCellX pos = toInteger $ fst pos

-- get y from Position of a Cell
getCellY :: Position -> Integer
getCellY pos = toInteger $ snd pos

-- get tile from a Cell
getTile :: Cell -> Tile
getTile = snd

-- is cell a camera?
isCamera :: Cell -> Bool
isCamera cell = getTile cell == "c"

-- creates a camera holding a Position and x diff
createCamProps :: Cell -> Camera
createCamProps cell = (getPos cell, 1)

type Camera = (Position, Integer)

type Cameras = [Camera]

-- find cameras on level and create Cameras
getCams :: Level -> Cameras
getCams l = map createCamProps $ filter isCamera l

-- get temp x diff of a camera
getCamDiff :: Camera -> Integer
getCamDiff = snd

-- move a camera x diff (if wall, restart)
camMove :: Camera -> Level -> Camera
camMove cam l =
  if ((getCellX (fst cam) + getCamDiff cam + 1, getCellY $ fst cam)
     , ".") `elem` l
    then ( (getCellX $ fst cam, getCellY $ fst cam)
         , getCamDiff cam + 1)
    else ((getCellX $ fst cam, getCellY $ fst cam), 1)

-- is player hit by a camera?
isPlrHit :: Camera -> (Integer, Integer) -> Bool
isPlrHit cam (x, y) =
  (getCellX (fst cam) + snd cam, getCellY $ fst cam) == (x, y)

-- is any cam hitting plr?
isAnyCamAtPlr :: Cameras -> Integer -> Integer -> Bool
isAnyCamAtPlr cams x y = any (`isPlrHit` (x, y)) cams

-- move cameras "shots"
moveCams :: Cameras -> Level -> Cameras
moveCams cs l = map (`camMove` l) cs

cameras :: Cameras
cameras = getCams level

-- used for filtering out a Cell from Level
isNotSpecCell :: Cell -> Cell -> Bool
isNotSpecCell c1 c2 = c1 /= c2

-- remove a cherry Cell from Level
removeCherry :: Cell -> Level -> Integer -> Integer -> Level
removeCherry oldCell l x y =
  filter (isNotSpecCell oldCell) l ++ [((x, y), ".")]

-- is player position at a cherry Cell?
isCherry :: Integer -> Integer -> Level -> Bool
isCherry x y l = ((x, y), "o") `elem` l

-- if on cherry Cell, inc score
checkScore :: Level -> Integer -> Integer -> Integer -> Integer
checkScore l x y score =
  if isCherry x y l
    then score + 1
    else score

-- if on cherry cell, replace cell with floor
checkLevel :: Level -> Integer -> Integer -> Level
checkLevel l x y =
  if isCherry x y l
    then removeCherry ((x, y), "o") l x y
    else l
