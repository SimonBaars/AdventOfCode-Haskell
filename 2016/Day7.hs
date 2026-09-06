
import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import Data.List (isInfixOf)

input :: [String]
input = unsafePerformIO $ readInputLines 2016 7

-- Alternating segments: even=outside, odd=inside (split on [ and ])
segments :: String -> [String]
segments = splitBracks
  where
    splitBracks s = case break (`elem` "[]") s of
      (a, []) -> [a]
      (a, _:rest) -> a : splitBracks rest

outsideInside :: String -> ([String],[String])
outsideInside s =
  let segs = segments s
  in ([segs !! i | i <- [0,2..length segs - 1]], [segs !! i | i <- [1,3..length segs - 1]])

hasABBA :: String -> Bool
hasABBA xs = any abba (windows4 xs)
  where
    windows4 (a:b:c:d:rest) = (a,b,c,d) : windows4 (b:c:d:rest)
    windows4 _ = []
    abba (a,b,c,d) = a /= b && a == d && b == c

supportsTLS :: String -> Bool
supportsTLS str =
  let (outs, inns) = outsideInside str
  in any hasABBA outs && not (any hasABBA inns)

getABAs :: String -> [(Char,Char)]
getABAs xs = [(a,b) | (a:b:c:_) <- tails3 xs, a == c, a /= b]
  where
    tails3 (a:b:c:rest) = (a:b:c:rest) : tails3 (b:c:rest)
    tails3 _ = []

supportsSSL :: String -> Bool
supportsSSL str =
  let (outs, inns) = outsideInside str
      abas = concatMap getABAs outs
  in or [ any (isInfixOf [b,a,b]) inns | (a,b) <- abas ]

part1 :: Int
part1 = length $ filter supportsTLS input

part2 :: Int
part2 = length $ filter supportsSSL input

testSplit :: String -> ([String],[String])
testSplit = outsideInside
