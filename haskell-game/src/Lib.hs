{-# LANGUAGE ParallelListComp #-}

module Lib
  ( getPos
  , getX
  , getY
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

import Data.List.Split
import GameData

-- a side of level
side :: Integer
side = 36

-- split level-string on ""
splitLevel :: String -> [[String]]
splitLevel l = map (splitOn "") (lines l)

-- flatten a list one level
flatten :: [[a]] -> [a]
flatten = foldl (++) []

-- used for filtering out empty items in "map" list
notEmpty :: [a] -> Bool
notEmpty x = not (null x)

-- splits "map" list to list of string containing tile
purgedLevel :: [String]
purgedLevel = filter notEmpty $ flatten $ splitLevel rawLevel

-- get y position on level in list
getListY :: Integer -> Integer -> Integer
getListY = div

-- get x position on level in list
getListX :: Integer -> Integer -> Integer
getListX = mod

type Position = (Integer, Integer)

type Tile = String

type Cell = (Position, Tile)

type Level = [Cell]

-- creates a level
level :: Level
level =
  [ ((getListX (toInteger x) side, getListY (toInteger x) side), y)
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
getX :: Position -> Integer
getX = toInteger . fst

-- get y from Position of a Cell
getY :: Position -> Integer
getY = toInteger . snd

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
getCams = map createCamProps . filter isCamera

-- get temp x diff of a camera
getCamDiff :: Camera -> Integer
getCamDiff = snd

-- move a camera x diff (if wall, restart)
camMove :: Camera -> Level -> Camera
camMove cam l
  | ((getX (fst cam) + getCamDiff cam + 1, getY $ fst cam), ".") `elem` l
  = ((getX $ fst cam, getY $ fst cam), getCamDiff cam + 1)
  | otherwise = ((getX $ fst cam, getY $ fst cam), 1)

-- is player hit by a camera?
isPlrHit :: Camera -> (Integer, Integer) -> Bool
isPlrHit cam (x, y) = (getX (fst cam) + snd cam, getY $ fst cam) == (x, y)

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

-- remove a cookie Cell from Level
removeCookie :: Cell -> Level -> Integer -> Integer -> Level
removeCookie oldCell l x y = filter (isNotSpecCell oldCell) l ++ [((x, y), ".")]

-- is player position at a cookie Cell?
isCookie :: Level -> Integer -> Integer -> Bool
isCookie l x y = ((x, y), "o") `elem` l

-- if on cookie Cell, inc score
checkScore :: Level -> Integer -> Integer -> Integer -> Integer
checkScore l x y score
  | isCookie l x y = score + 1
  | otherwise      = score

-- if on cookie cell, replace cell with floor
checkLevel :: Level -> Integer -> Integer -> Level
checkLevel l x y
  | isCookie l x y = removeCookie ((x, y), "o") l x y
  | otherwise      = l
