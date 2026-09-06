import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)

input :: String
input = unsafePerformIO $ readInput 2017 16

type Programs = String

dance :: Programs -> String -> Programs
dance progs move
    | head move == 's' =
        let n = read (tail move) :: Int
        in drop (length progs - n) progs ++ take (length progs - n) progs
    | head move == 'x' =
        let (aStr, '/':bStr) = break (== '/') (tail move)
            a = read aStr :: Int
            b = read bStr :: Int
            pa = progs !! a
            pb = progs !! b
        in [if i == a then pb else if i == b then pa else c | (i, c) <- zip [0..] progs]
    | head move == 'p' =
        let (paStr, '/':pbStr) = break (== '/') (tail move)
            pa = head paStr
            pb = head pbStr
            Just a = lookup pa (zip progs [0..])
            Just b = lookup pb (zip progs [0..])
        in [if i == a then pb else if i == b then pa else c | (i, c) <- zip [0..] progs]
    | otherwise = progs

danceAll :: Programs -> [String] -> Programs
danceAll = foldl dance

moves :: [String]
moves = words $ map (\c -> if c == ',' then ' ' else c) $ filter (/= '\n') input

cycleLen :: Int
cycleLen = go (danceAll "abcdefghijklmnop" moves) 1
  where
    start = "abcdefghijklmnop"
    go current count
      | current == start = count
      | otherwise = go (danceAll current moves) (count + 1)

part1 :: String
part1 = danceAll "abcdefghijklmnop" moves

part2 :: String
part2 = iterate (`danceAll` moves) "abcdefghijklmnop" !! (1000000000 `mod` cycleLen)
