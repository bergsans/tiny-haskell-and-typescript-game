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

printable :: Tile -> String -- replace a tile with prettier version
printable tile
  | tile == "." = "."
  | tile == "c" = "📷"
  | tile == "x" = "▒▒"
  -- | tile == "x" = "░░"
  | tile == "o" = "🍪"
  | otherwise   = " "

putTile :: Cell -> Update () -- put a tile at a position 
putTile cell = do
  moveCursor (2 + (getCellY $ getPosition cell)) (double $ getCellX $ getPosition cell)
  drawString (printable $ getTile cell)

renderMap :: Level -> Update () -- puts Level on Screen
renderMap l = sequence_ [putTile cell | cell <- l]

drawShot :: Camera -> Update () -- put a Camera "flash" at a position
drawShot c = do
  moveCursor (2 + (getCellY $ fst c)) (double $ ((getCellX $ fst c) + (snd c)))
  drawString camShot

renderCamerasShooting :: Cameras -> Update () -- puts Cameras on Screen
renderCamerasShooting cs = sequence_ [drawShot c | c <- cs]

renderScore :: Integer -> Update() -- puts score on Screen
renderScore score = do
  moveCursor 40 1
  drawString $ "Eaten cookies: " ++ (show score)

renderPlayer :: Integer -> Integer -> Update() -- puts player on Screen
renderPlayer x y = do
  moveCursor (y + 2) (double x)
  drawString "👾"

nonNCursesClearScreen = putStr "\ESC[2J" -- clear screen using ANSI (outside ncurses)
