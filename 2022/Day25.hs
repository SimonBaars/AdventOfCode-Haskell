-- Day 25: Full of Hot Air
-- SNAFU number system conversion
import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

input :: [String]
input = unsafePerformIO $ readInputLines 2022 25

-- SNAFU to decimal
snafuToDecimal :: String -> Integer
snafuToDecimal = foldl (\acc c -> acc * 5 + digitValue c) 0
  where
    digitValue '2' = 2
    digitValue '1' = 1
    digitValue '0' = 0
    digitValue '-' = -1
    digitValue '=' = -2

-- Decimal to SNAFU
decimalToSnafu :: Integer -> String
decimalToSnafu 0 = ""
decimalToSnafu n = decimalToSnafu ((n + 2) `div` 5) ++ [digit]
  where
    digit = "=-012" !! fromInteger ((n + 2) `mod` 5)

part1 :: String
part1 = decimalToSnafu $ sum $ map snafuToDecimal input

part2 :: String
part2 = "Merry Christmas!"
