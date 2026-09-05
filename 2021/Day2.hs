import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

input :: [(String, Int)]
input = unsafePerformIO $ map parseLine <$> readInputLines 2021 2
  where
    parseLine line = (cmd, read val)
      where [cmd, val] = words line

part1 :: Int
part1 = h * d
  where
    (h, d) = foldl move (0, 0) input
    move (horiz, depth) ("forward", x) = (horiz + x, depth)
    move (horiz, depth) ("down", x) = (horiz, depth + x)
    move (horiz, depth) ("up", x) = (horiz, depth - x)

part2 :: Int
part2 = h * d
  where
    (h, d, _) = foldl move (0, 0, 0) input
    move (horiz, depth, aim) ("forward", x) = (horiz + x, depth + aim * x, aim)
    move (horiz, depth, aim) ("down", x) = (horiz, depth, aim + x)
    move (horiz, depth, aim) ("up", x) = (horiz, depth, aim - x)
