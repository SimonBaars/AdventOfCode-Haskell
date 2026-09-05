import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

input :: [String]
input = unsafePerformIO $ readInputLines 2015 8

codeLength :: String -> Int
codeLength = length

memoryLength :: String -> Int
memoryLength s = length $ unescape $ init $ tail s
  where
    unescape [] = []
    unescape ('\\':'\\':rest) = '\\' : unescape rest
    unescape ('\\':'"':rest) = '"' : unescape rest
    unescape ('\\':'x':_:_:rest) = 'X' : unescape rest
    unescape (c:rest) = c : unescape rest

encodedLength :: String -> Int
encodedLength s = 2 + length s + count s
  where
    count [] = 0
    count (c:cs) | c == '\\' || c == '"' = 1 + count cs
                 | otherwise = count cs

part1 :: Int
part1 = sum (map codeLength input) - sum (map memoryLength input)

part2 :: Int
part2 = sum (map encodedLength input) - sum (map codeLength input)
