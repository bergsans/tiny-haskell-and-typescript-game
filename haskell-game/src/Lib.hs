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
  , isAnyCameraHittingPlayer
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
notEmpty x = length x > 0

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
  | direction == "Up" && not (((x, (y - 1)), "x") `elem` l) = True
  | direction == "Right" && not ((((x + 1), y), "x") `elem` l) = True
  | direction == "Down" && not (((x, (y + 1)), "x") `elem` l) = True
  | direction == "Left" && not ((((x - 1), y), "x") `elem` l) = True
  | otherwise = False

-- get Position of a Cell
getPosition :: Cell -> Position
getPosition = fst

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
createCameraProps :: Cell -> Camera
createCameraProps cell = (getPosition cell, 1)

type Camera = (Position, Integer)

type Cameras = [Camera]

-- find cameras on level and create Cameras
getCameras :: Level -> Cameras
getCameras l = map createCameraProps $ filter isCamera l

-- get temp x diff of a camera
getCameraDiff :: Camera -> Integer
getCameraDiff = snd

-- move a camera x diff (if wall, restart)
camMove :: Camera -> Level -> Camera
camMove camera l =
  if ( ( ((getCellX $ fst camera) + (getCameraDiff camera) + 1)
       , (getCellY $ fst camera))
     , ".") `elem`
     l
    then ( ((getCellX $ fst camera), (getCellY $ fst camera))
         , ((getCameraDiff camera) + 1))
    else (((getCellX $ fst camera), (getCellY $ fst camera)), 1)

-- is player hit by a camera?
isPlayerHit :: Camera -> Integer -> Integer -> Bool
isPlayerHit cam x y =
  (((getCellX $ fst cam) + snd cam), getCellY $ fst cam) == (x, y)

-- is any cam hitting plr?
isAnyCameraHittingPlayer :: Cameras -> Integer -> Integer -> Bool
isAnyCameraHittingPlayer cams x y = any (\c -> isPlayerHit c x y) cams

-- move cameras "shots"
moveCameras :: Cameras -> Level -> Cameras
moveCameras cs l = map (`camMove` l) cs

cameras :: Cameras
cameras = getCameras level

-- used for filtering out a Cell from Level
isNotASpecificCell :: Cell -> Cell -> Bool
isNotASpecificCell cell1 cell2 = cell1 /= cell2

-- remove a cherry Cell from Level
removeCherry :: Cell -> Level -> Integer -> Integer -> Level
removeCherry oldCell l x y =
  filter (isNotASpecificCell oldCell) l ++ [((x, y), ".")]

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
