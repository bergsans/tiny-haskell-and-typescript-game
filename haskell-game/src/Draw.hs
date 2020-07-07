module Draw (
    renderPlayer
  , renderMap
  , renderScore
  , nonNCursesClearScreen
) where

import UI.NCurses
import Lib
import GameData

double :: Integer -> Integer
double x = x + x

printable :: Tile -> String
printable tile
  | tile == "." = "."
  | tile == "p" = "c"
  | tile == "q" = "c"
  | tile == "x" = "░░"
  | tile == "o" = "🍪"
  | otherwise   = " "

putTile :: Cell -> Update ()
putTile cell = do
  moveCursor (getCellY $ getPosition cell) (double $ getCellX $ getPosition cell)
  drawString (printable $ getTile cell)

renderScore :: Integer -> Update()
renderScore score = do
  moveCursor 38 1
  drawString $ "Eaten cookies: " ++ (show score)

renderMap :: Level -> Update ()
renderMap l = sequence_ [putTile cell | cell <- l]

renderPlayer :: Integer -> Integer -> Update()
renderPlayer x y = do
  moveCursor y (double x)
  drawString "👾"

nonNCursesClearScreen = putStr "\ESC[2J"
