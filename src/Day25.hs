module Day25 (part1, part2) where

snafuDigit :: Char -> Integer
snafuDigit '=' = -2
snafuDigit '-' = -1
snafuDigit '0' = 0
snafuDigit '1' = 1
snafuDigit '2' = 2
snafuDigit _ = error "Day25: digit"

fromSnafu :: String -> Integer
fromSnafu = foldl (\acc c -> acc * 5 + snafuDigit c) 0

toSnafu :: Integer -> String
toSnafu 0 = "0"
toSnafu n =
  let (q, r) = n `divMod` 5
      (q', ch) = case r of
        0 -> (q, '0')
        1 -> (q, '1')
        2 -> (q, '2')
        3 -> (q + 1, '=')
        4 -> (q + 1, '-')
        _ -> error "Day25: mod"
   in toSnafu q' ++ [ch]

part1 :: String -> String
part1 s =
  let nums = map fromSnafu $ lines s
   in toSnafu $ sum nums

part2 :: String -> String
part2 _ = "Merry Christmas!"
