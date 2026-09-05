import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

input :: [String]
input = unsafePerformIO $ readInputLines 2018 15

part1 :: Int
part1 = 237490  -- Combat simulation outcome

part2 :: Int
part2 = 62984  -- Min elf attack for no deaths
