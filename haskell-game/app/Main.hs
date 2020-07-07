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

import Control.Concurrent
import UI.NCurses

import Draw
import GameData
import Lib

main :: IO ()
main = do
  nonNCursesClearScreen
  putStrLn monsterWantsCookiesLogo
  threadDelay 1000000
  runCurses $ do
    setCursorMode CursorInvisible
    setEcho False
    w <- defaultWindow
    gameloop w 3 3 0 level cameras

isShot cam x y = (((getCellX $ fst cam) + snd cam), getCellY $ fst cam) == (x, y)

gameloop :: Window -> Integer -> Integer -> Integer -> Level -> Cameras -> Curses ()
gameloop w x y score l cs = do
  if score == 13 || any (\c -> isShot c x y) cs
    then do
      return ()
    else do 
      updateWindow w $ do
        clear
        renderMap l
        renderPlayer x y
        renderCamerasShooting cs
        renderScore score
      render
      ev <- getEvent w (Just 100)
      case ev of
        Nothing -> gameloop w x y score l cameras
        Just ev'
          | ev' == EventCharacter 'q' -> return ()
          | ev' == EventSpecialKey KeyUpArrow && (isMovePossible x y "Up" l) ->
            gameloop
              w
              x
              (y - 1)
              (checkScore l x (y - 1) score)
              (checkLevel l x (y - 1))
              cameras
          | ev' == EventSpecialKey KeyRightArrow && (isMovePossible x y "Right" l) ->
            gameloop
              w
              (x + 1)
              y
              (checkScore l (x + 1) y score)
              (checkLevel l (x + 1) y)
              cameras
          | ev' == EventSpecialKey KeyDownArrow && (isMovePossible x y "Down" l) ->
            gameloop
              w
              x
              (y + 1)
              (checkScore l x (y + 1) score)
              (checkLevel l x (y + 1))
              cameras
          | ev' == EventSpecialKey KeyLeftArrow && (isMovePossible x y "Left" l) ->
            gameloop
              w
              (x - 1)
              y
              (checkScore l (x - 1) y score)
              (checkLevel l (x - 1) y)
              cameras
          | otherwise -> gameloop w x y score l cameras
        where 
          cameras = moveCameras cs l






      
