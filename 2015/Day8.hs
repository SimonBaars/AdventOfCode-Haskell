import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

input :: [String]
input = unsafePerformIO $ readInputLines 2015 8

memLen :: String -> Int
memLen = go . init . tail
  where
    go [] = 0
    go ('\\':'\\':xs) = 1 + go xs
    go ('\\':'"':xs) = 1 + go xs
    go ('\\':'x':_:_:xs) = 1 + go xs
    go (_:xs) = 1 + go xs

encLen :: String -> Int
encLen s = 2 + sum (map esc s)
  where
    esc '"' = 2
    esc '\\' = 2
    esc _ = 1

part1 :: Int
part1 = sum [length s - memLen s | s <- input]

part2 :: Int
part2 = sum [encLen s - length s | s <- input]
