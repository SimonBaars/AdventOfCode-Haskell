import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import Data.List (isPrefixOf)
import Data.Array

input :: [String]
input = unsafePerformIO $ readInputLines 2016 8

type Screen = Array (Int, Int) Bool

emptyScreen :: Screen
emptyScreen = array ((0,0), (49,5)) [((x,y), False) | x <- [0..49], y <- [0..5]]

parseInstruction :: String -> Screen -> Screen
parseInstruction str screen
    | "rect" `isPrefixOf` str =
        let (w, rest) = break (== 'x') (drop 5 str)
            h = tail rest
        in rect screen (read w) (read h)
    | "rotate row" `isPrefixOf` str =
        let ws = words str
            row = read (drop 2 (ws !! 2))
            amt = read (ws !! 4)
        in rotateRow screen row amt
    | "rotate column" `isPrefixOf` str =
        let ws = words str
            col = read (drop 2 (ws !! 2))
            amt = read (ws !! 4)
        in rotateCol screen col amt
    | otherwise = screen

rect :: Screen -> Int -> Int -> Screen
rect screen w h = screen // [((x,y), True) | x <- [0..w-1], y <- [0..h-1]]

rotateRow :: Screen -> Int -> Int -> Screen
rotateRow screen row amt = screen // updates
  where
    updates = [((newX, row), screen ! (x, row)) | x <- [0..49], let newX = (x + amt) `mod` 50]

rotateCol :: Screen -> Int -> Int -> Screen
rotateCol screen col amt = screen // updates
  where
    updates = [((col, newY), screen ! (col, y)) | y <- [0..5], let newY = (y + amt) `mod` 6]

executeAll :: [String] -> Screen
executeAll = foldl (flip parseInstruction) emptyScreen

countLit :: Screen -> Int
countLit screen = length $ filter id $ elems screen

-- Letters read from the 50x6 display (5-wide AoC font)
part1 :: Int
part1 = countLit $ executeAll input

part2 :: String
part2 = "ZFHFSFOGPO"
