import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import Data.Char (isAlpha)

input :: [String]
input = unsafePerformIO $ readInputLines 2017 19

followPath :: [String] -> (String, Int)
followPath grid = go (startX, 0) (0, 1) "" 0
  where
    startX = head [x | (x, c) <- zip [0..] (head grid), c == '|']
    get (x, y) = if y >= 0 && y < length grid && x >= 0 && x < length (grid !! y) then grid !! y !! x else ' '
    
    go (x, y) (dx, dy) letters steps
        | get (x, y) == ' ' = (letters, steps)
        | isAlpha (get (x, y)) = go (x + dx, y + dy) (dx, dy) (letters ++ [get (x, y)]) (steps + 1)
        | get (x, y) == '+' =
            let newDirs = [d | d <- [(1, 0), (-1, 0), (0, 1), (0, -1)], d /= (-dx, -dy), get (x + fst d, y + snd d) /= ' ']
            in go (x + fst (head newDirs), y + snd (head newDirs)) (head newDirs) letters (steps + 1)
        | otherwise = go (x + dx, y + dy) (dx, dy) letters (steps + 1)

(foundLetters, totalSteps) = followPath input

part1 :: String
part1 = foundLetters

part2 :: Int
part2 = totalSteps
