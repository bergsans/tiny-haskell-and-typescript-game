module Draw (
    renderPlayer
  , renderMap
  , renderScore
  , nonNCursesClearScreen
  , renderCamerasShooting
) where

import UI.NCurses
import Lib
import GameData

double :: Integer -> Integer
double x = x + x

camShot :: String
camShot = "💥"

-- Replace a Tile w. a prettier representation
printable :: Tile -> String
printable tile
  | tile == "." = "."
  | tile == "c" = "📷"
  | tile == "x" = "▒▒"
  | tile == "o" = "🍪"
  | otherwise   = " "

-- Put a Tile at a screen position 
putTile :: Cell -> Update ()
putTile cell = do
  moveCursor (2 + (getCellY $ getPosition cell)) (double $ getCellX $ getPosition cell)
  drawString (printable $ getTile cell)

renderMap :: Level -> Update () -- Put Level on screen
renderMap l = sequence_ [putTile cell | cell <- l]

-- Put a Camera "flash" at a screen position
drawShot :: Camera -> Update ()
drawShot c = do
  moveCursor (2 + (getCellY $ fst c)) (double $ ((getCellX $ fst c) + (snd c)))
  drawString camShot

-- Puts Cameras on Screen
renderCamerasShooting :: Cameras -> Update ()
renderCamerasShooting cs = sequence_ [drawShot c | c <- cs]

-- Puts score on Screen
renderScore :: Integer -> Update()
renderScore score = do
  moveCursor 40 1
  drawString $ "Eaten cookies: " ++ (show score)

-- Puts player on Screen
renderPlayer :: Integer -> Integer -> Update()
renderPlayer x y = do
  moveCursor (y + 2) (double x)
  drawString "👾"

-- Clears screen using ANSI (outside ncurses)
nonNCursesClearScreen = putStr "\ESC[2J" 
