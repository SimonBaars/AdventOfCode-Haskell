import InputUtils (inputPath)
import System.IO.Unsafe (unsafePerformIO)
import System.Process (readProcess)

solve :: String -> Int
solve part = read $ unsafePerformIO $
  readProcess "python3" ["2016/md5_day14.py", inputPath 2016 14, part] ""

part1 :: Int
part1 = solve "1"

part2 :: Int
part2 = solve "2"
