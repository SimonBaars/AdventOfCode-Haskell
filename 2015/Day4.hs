import InputUtils (inputPath)
import System.IO.Unsafe (unsafePerformIO)
import System.Process (readProcess)

search :: String -> Int
search prefix = read $ unsafePerformIO $
  readProcess "python3" ["2015/md5_search.py", inputPath 2015 4, prefix] ""

part1 :: Int
part1 = search "00000"

part2 :: Int
part2 = search "000000"
