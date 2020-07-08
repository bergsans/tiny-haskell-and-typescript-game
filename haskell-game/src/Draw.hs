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

printable :: Tile -> String -- Replace a Tile w. a prettier representation
printable tile
  | tile == "." = "."
  | tile == "c" = "📷"
  | tile == "x" = "▒▒"
  -- | tile == "x" = "░░"
  | tile == "o" = "🍪"
  | otherwise   = " "

putTile :: Cell -> Update () -- Put a Tile at a screen position 
putTile cell = do
  moveCursor (2 + (getCellY $ getPosition cell)) (double $ getCellX $ getPosition cell)
  drawString (printable $ getTile cell)

renderMap :: Level -> Update () -- Put Level on screen
renderMap l = sequence_ [putTile cell | cell <- l]

drawShot :: Camera -> Update () -- Put a Camera "flash" at a screen position
drawShot c = do
  moveCursor (2 + (getCellY $ fst c)) (double $ ((getCellX $ fst c) + (snd c)))
  drawString camShot

renderCamerasShooting :: Cameras -> Update () -- Puts Cameras on Screen
renderCamerasShooting cs = sequence_ [drawShot c | c <- cs]

renderScore :: Integer -> Update() -- Puts score on Screen
renderScore score = do
  moveCursor 40 1
  drawString $ "Eaten cookies: " ++ (show score)

renderPlayer :: Integer -> Integer -> Update() -- Puts player on Screen
renderPlayer x y = do
  moveCursor (y + 2) (double x)
  drawString "👾"

nonNCursesClearScreen = putStr "\ESC[2J" -- Clears screen using ANSI (outside ncurses)
