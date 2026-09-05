import InputUtils (inputPath)
import System.IO.Unsafe (unsafePerformIO)
import System.Process (readProcess)

solve :: String -> String
solve part = unsafePerformIO $
  readProcess "python3" ["2016/md5_day5.py", inputPath 2016 5, part] ""

part1 :: String
part1 = solve "1"

part2 :: String
part2 = solve "2"
