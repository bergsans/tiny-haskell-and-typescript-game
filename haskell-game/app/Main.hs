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

module Main where

import Lib
import UI.NCurses

double :: Integer -> Integer
double x = x + x

putTile :: Cell -> Update ()
putTile cell = do
  moveCursor (getCellY $ getPosition cell) (double $ getCellX $ getPosition cell)
  drawString (printable $ getTile cell)

renderMap :: Level -> Update ()
renderMap l = sequence_ [putTile cell | cell <- l]

renderPlayer :: Integer -> Integer -> Update()
renderPlayer x y = do
  moveCursor y x
  drawString "👾"

main :: IO ()
main =
  runCurses $ do
    setCursorMode CursorInvisible
    setEcho False
    w <- defaultWindow
    gameloop w 3 3 level

gameloop :: Window -> Integer -> Integer -> Level -> Curses ()
gameloop w x y l = do
  updateWindow w $ do
    clear
    renderMap l
    renderPlayer x y
  render
  ev <- getEvent w (Just 1000)
  case ev of
    Nothing -> gameloop w x y l
    Just ev'
      | ev' == EventCharacter 'q'            -> return ()
      | ev' == EventSpecialKey KeyUpArrow    -> gameloop w x (y - 1) l
      | ev' == EventSpecialKey KeyRightArrow -> gameloop w (x + 1) y l
      | ev' == EventSpecialKey KeyDownArrow  -> gameloop w x (y + 1) l
      | ev' == EventSpecialKey KeyLeftArrow  -> gameloop w (x - 1) y l
      | otherwise                            -> gameloop w x y l
