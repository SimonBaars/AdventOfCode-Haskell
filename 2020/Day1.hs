import InputUtils (readInputInts)
import System.IO.Unsafe (unsafePerformIO)

input :: [Integer]
input = unsafePerformIO $ readInputInts 2020 1

part1 :: Integer
part1 = head [x*y | x <- input, y <- input, x+y == 2020]

part2 :: Integer
part2 = head [x*y*z | x <- input, y <- input, z <- input, x+y+z == 2020]
