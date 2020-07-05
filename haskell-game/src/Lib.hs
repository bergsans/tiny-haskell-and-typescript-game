{-# LANGUAGE ParallelListComp #-}

module Lib (updateScreen) where

import Data.List.Split

w = 6
h = 6

l = "\
\xxxxxx\n\
\x...ox\n\
\x....x\n\
\x....x\n\
\x....x\n\
\xxxxxx"

raw = map (splitOn "") (lines l)

flatten :: [[a]] -> [a]
flatten = foldl (++) []

notEmpty :: [a] -> Bool
notEmpty x = length x > 0

li :: [String]
li = filter notEmpty $ flatten raw

getY :: Int -> Int -> Int
getY i w = div i w

getX :: Int -> Int -> Int
getX i w = mod i w

type Position = (Int, Int)
type Tile = String
type Cell = (Position, Tile)

matrix :: [Cell]
matrix = [((getX x w, getY x w) , y) | x <- [0..length li] 
                                     | y <- li]

getPosition :: Cell -> Position
getPosition cell = fst cell

getCellX :: Position -> Int
getCellX pos = fst pos

getCellY :: Position -> Int
getCellY pos = snd pos

getTile :: Cell -> Tile
getTile cell = snd cell

printableTile tile | tile == "." = ".."
                   | tile == "x" = "🌲"
                   | otherwise = "🥡"

printTile cell 
                | getCellX (getPosition cell) == (w - 1) = putStr $ (printableTile $ getTile cell) ++ "\n"
                | getCellX (getPosition cell) == 2 && getCellY (getPosition cell) == 2 = putStr "👾" 
                | otherwise = putStr $ printableTile $ getTile cell

renderMap board = sequence_ [printTile c | c <- board]  

clearScreen = putStr "\ESC[2J"

updateScreen :: IO ()
updateScreen = do
                  Lib.clearScreen
                  Lib.renderMap matrix



