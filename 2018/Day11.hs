import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)

input :: String
input = unsafePerformIO $ readInput 2018 11

gridSerial :: Int
gridSerial = read $ filter (/= '\n') input

powerLevel :: Int -> Int -> Int -> Int
powerLevel serial x y =
    let rackID = x + 10
        power = ((rackID * y) + serial) * rackID
        hundreds = (power `div` 100) `mod` 10
    in hundreds - 5

totalPower :: Int -> Int -> Int -> Int -> Int
totalPower serial x y size = sum [powerLevel serial (x + dx) (y + dy) | dx <- [0..size-1], dy <- [0..size-1]]

findMaxSquare :: Int -> Int -> (Int, Int, Int)
findMaxSquare serial size =
    let powers = [((x, y), totalPower serial x y size) | x <- [1..300-size], y <- [1..300-size]]
        ((maxX, maxY), _) = maximum [(p, v) | (p, v) <- powers]
    in (maxX, maxY, totalPower serial maxX maxY size)

part1 :: String
part1 = let (x, y, _) = findMaxSquare gridSerial 3 in show x ++ "," ++ show y

part2 :: String
part2 = let results = [(x, y, s, p) | s <- [1..20], let (x, y, p) = findMaxSquare gridSerial s]
            (maxX, maxY, maxS, _) = maximum [(x, y, s, p) | (x, y, s, p) <- results]
        in show maxX ++ "," ++ show maxY ++ "," ++ show maxS
