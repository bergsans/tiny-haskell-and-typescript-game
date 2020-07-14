module Draw (
    renderPlayer
  , renderMap
  , renderScore
  , nonNCursesClearScreen
  , renderCamShot
) where

import           GameData
import           Lib
import           UI.NCurses

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
  moveCursor (getY (getPos cell) + 2) (double $ getX $ getPos cell)
  drawString (printable $ getTile cell)

renderMap :: Level -> Update () -- Put Level on screen
renderMap l = sequence_ [putTile cell | cell <- l]

-- Put a Camera "flash" at a screen position
drawShot :: Camera -> Update ()
drawShot c = do
  moveCursor (getY $ fst c) (double (getX (fst c) + snd c))
  drawString camShot

-- Puts Cameras on Screen
renderCamShot :: Cameras -> Update ()
renderCamShot cs = sequence_ [drawShot c | c <- cs]

-- Puts score on Screen
renderScore :: Integer -> Update()
renderScore score = do
  moveCursor 40 1
  drawString $ "Eaten cookies: " ++ show score

-- Puts player on Screen
renderPlayer :: Integer -> Integer -> Update()
renderPlayer x y = do
  moveCursor (y + 2) (double x)
  drawString "👾"

-- Clears screen using ANSI (outside ncurses)
nonNCursesClearScreen = putStr "\ESC[2J"
