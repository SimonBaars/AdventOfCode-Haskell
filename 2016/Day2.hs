import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import Data.Maybe (fromMaybe)

input :: [String]
input = unsafePerformIO $ readInputLines 2016 2

type Pos = (Int, Int)

keypad1 :: Pos -> Char
keypad1 (0, 0) = '1'
keypad1 (1, 0) = '2'
keypad1 (2, 0) = '3'
keypad1 (0, 1) = '4'
keypad1 (1, 1) = '5'
keypad1 (2, 1) = '6'
keypad1 (0, 2) = '7'
keypad1 (1, 2) = '8'
keypad1 (2, 2) = '9'

move1 :: Pos -> Char -> Pos
move1 (x, y) 'U' = (x, max 0 (y - 1))
move1 (x, y) 'D' = (x, min 2 (y + 1))
move1 (x, y) 'L' = (max 0 (x - 1), y)
move1 (x, y) 'R' = (min 2 (x + 1), y)
move1 pos _ = pos

keypad2 :: Pos -> Maybe Char
keypad2 (2, 0) = Just '1'
keypad2 (1, 1) = Just '2'
keypad2 (2, 1) = Just '3'
keypad2 (3, 1) = Just '4'
keypad2 (0, 2) = Just '5'
keypad2 (1, 2) = Just '6'
keypad2 (2, 2) = Just '7'
keypad2 (3, 2) = Just '8'
keypad2 (4, 2) = Just '9'
keypad2 (1, 3) = Just 'A'
keypad2 (2, 3) = Just 'B'
keypad2 (3, 3) = Just 'C'
keypad2 (2, 4) = Just 'D'
keypad2 _ = Nothing

move2 :: Pos -> Char -> Pos
move2 pos dir = 
    let newPos = case dir of
            'U' -> (fst pos, snd pos - 1)
            'D' -> (fst pos, snd pos + 1)
            'L' -> (fst pos - 1, snd pos)
            'R' -> (fst pos + 1, snd pos)
            _   -> pos
    in if keypad2 newPos /= Nothing then newPos else pos

part1 :: String
part1 = concatMap (\pos -> [keypad1 pos]) positions
  where positions = tail $ scanl processLine (1, 1) input
        processLine pos line = foldl move1 pos line

part2 :: String
part2 = concatMap (\pos -> maybe "" (\c -> [c]) (keypad2 pos)) positions
  where positions = tail $ scanl processLine (0, 2) input
        processLine pos line = foldl move2 pos line
