--                                                                                                                                       
--                                ,,                                                                                                     
--       db          MMP""MM""YMM db                            .g8"""bgd                                                                
--      ;MM:         P'   MM   `7                             .dP'     `M                                                                
--     ,V^MM.             MM    `7MM `7MMpMMMb.`7M'   `MF'    dM'       `  ,6"Yb. `7MMpMMMb.pMMMb.  .gP"Ya                               
--    ,M  `MM             MM      MM   MM    MM  VA   ,V      MM          8)   MM   MM    MM    MM ,M'   Yb                              
--    AbmmmqMA            MM      MM   MM    MM   VA ,V       MM.    `7MMF',pm9MM   MM    MM    MM 8M""""""                              
--   A'     VML           MM      MM   MM    MM    VVV        `Mb.     MM 8M   MM   MM    MM    MM YM.    ,                              
-- .AMA.   .AMMA.       .JMML.  .JMML.JMML  JMML.  ,V           `"bmmmdPY `Moo9^Yo.JMML  JMML  JMML.`Mbmmd'                              
--                                                ,V                                                                                     
--                                             OOb"                                                                                      
--                                                                                                                                       
--                                                           ,,   ,,                                           ,,                        
--          `7MMF'  `7MMF'                `7MM             `7MM `7MM                                           db                        
--            MM      MM                    MM               MM   MM                                                                     
--            MM      MM   ,6"Yb.  ,pP"Ybd  MM  ,MP'.gP"Ya   MM   MM      `7M'   `MF'.gP"Ya `7Mb,od8 ,pP"Ybd `7MM  ,pW"Wq.`7MMpMMMb.     
--            MMmmmmmmMM  8)   MM  8I   `"  MM ;Y  ,M'   Yb  MM   MM        VA   ,V ,M'   Yb  MM' "' 8I   `"   MM 6W'   `Wb MM    MM     
-- mmmmm      MM      MM   ,pm9MM  `YMMMa.  MM;Mm  8M""""""  MM   MM         VA ,V  8M""""""  MM     `YMMMa.   MM 8M     M8 MM    MM     
--            MM      MM  8M   MM  L.   I8  MM `Mb.YM.    ,  MM   MM          VVV   YM.    ,  MM     L.   I8   MM YA.   ,A9 MM    MM  ,, 
--          .JMML.  .JMML.`Moo9^Yo.M9mmmP'.JMML. YA.`Mbmmd'.JMML.JMML.         W     `Mbmmd'.JMML.   M9mmmP' .JMML.`Ybmd9'.JMML  JMML.db 
--                                                                                                                                       
--                                                                                                                                       
--      By Claes-Magnus Berg <claes-magnus@herebeseaswines.net>
--
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------

{-# LANGUAGE ParallelListComp #-}

module Lib (updateScreen) where

import Data.List.Split
import RawLevel  -- contains the level :: String

side = 36 -- a side of level

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

level :: [Cell]
level = [((getX x side, getY x side) , y) | x <- [0..length purgedLevel] 
                                           | y <- purgedLevel]

getPosition :: Cell -> Position
getPosition cell = fst cell

getCellX :: Position -> Int
getCellX pos = fst pos

getCellY :: Position -> Int
getCellY pos = snd pos

getTile :: Cell -> Tile
getTile cell = snd cell

flash = "💥"

printable tile | tile == "." = ".."
                   | tile == "p" = "📷"
                   | tile == "q" = "📸"
                   | tile == "x" = "🌲"
                   | tile == "o" = "🥡"
                   | otherwise   = "  "

putTile cell | getCellX (getPosition cell) == (side - 1) = (printable $ getTile cell) ++ "\n"
             | getCellX (getPosition cell) == 2 && getCellY (getPosition cell) == 2 = "👾" 
             | otherwise = printable $ getTile cell


-- replace with ncurses method for print
renderMap l = sequence_ [putStr $ putTile cell | cell <- l]  

-- replace with ncurses method for clear
clearScreen = putStr "\ESC[2J"

updateScreen :: IO ()
updateScreen = do
            clearScreen
            renderMap level



