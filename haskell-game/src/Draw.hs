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

camShot = "💥"

printable :: Tile -> String
printable tile
  | tile == "." = "."
  | tile == "c" = "📷"
  | tile == "x" = "▒▒"
  -- | tile == "x" = "░░"
  | tile == "o" = "🍪"
  | otherwise   = " "

putTile :: Cell -> Update ()
putTile cell = do
  moveCursor (2 + (getCellY $ getPosition cell)) (double $ getCellX $ getPosition cell)
  drawString (printable $ getTile cell)

drawShot c = do
  moveCursor (2 + (getCellY $ fst c)) (double $ ((getCellX $ fst c) + (snd c)))
  drawString camShot

renderCamerasShooting cs = sequence_ [drawShot c | c <- cs]

renderScore :: Integer -> Update()
renderScore score = do
  moveCursor 40 1
  drawString $ "Eaten cookies: " ++ (show score)

renderMap :: Level -> Update ()
renderMap l = sequence_ [putTile cell | cell <- l]

renderPlayer :: Integer -> Integer -> Update()
renderPlayer x y = do
  moveCursor (y + 2) (double x)
  drawString "👾"

nonNCursesClearScreen = putStr "\ESC[2J"
