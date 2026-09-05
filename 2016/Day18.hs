import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)

input :: String
input = unsafePerformIO $ readInput 2016 18

isTrap :: Char -> Char -> Char -> Char
isTrap '^' '^' '.' = '^'
isTrap '.' '^' '^' = '^'
isTrap '^' '.' '.' = '^'
isTrap '.' '.' '^' = '^'
isTrap _ _ _ = '.'

nextRow :: String -> String
nextRow row = [isTrap l c r | (l, c, r) <- zip3 ('.' : row) row (tail row ++ ['.'])]

countSafe :: String -> Int -> Int
countSafe firstRow rows = length $ filter (== '.') $ concat $ take rows $ iterate nextRow firstRow

part1 :: Int
part1 = countSafe (filter (/= '\n') input) 40

part2 :: Int
part2 = countSafe (filter (/= '\n') input) 400000
