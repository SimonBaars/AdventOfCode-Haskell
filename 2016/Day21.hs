import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import Data.List (permutations)
import Data.Char (ord)

input :: [String]
input = unsafePerformIO $ readInputLines 2016 21

data Op = SwapPos Int Int | SwapLetter Char Char | RotateLeft Int | RotateRight Int
        | RotateBased Char | Reverse Int Int | Move Int Int deriving Show

parseOp :: String -> Op
parseOp str = case words str of
    ["swap", "position", x, "with", "position", y] -> SwapPos (read x) (read y)
    ["swap", "letter", [x], "with", "letter", [y]] -> SwapLetter x y
    ["rotate", "left", x, _] -> RotateLeft (read x)
    ["rotate", "right", x, _] -> RotateRight (read x)
    ["rotate", "based", "on", "position", "of", "letter", [x]] -> RotateBased x
    ["reverse", "positions", x, "through", y] -> Reverse (read x) (read y)
    ["move", "position", x, "to", "position", y] -> Move (read x) (read y)
    _ -> error $ "Invalid operation: " ++ str

applyOp :: String -> Op -> String
applyOp s (SwapPos x y) = 
    let arr = [(if i == x then s !! y else if i == y then s !! x else s !! i) | i <- [0..length s - 1]]
    in arr
applyOp s (SwapLetter x y) = map (\c -> if c == x then y else if c == y then x else c) s
applyOp s (RotateLeft n) = drop n' s ++ take n' s where n' = n `mod` length s
applyOp s (RotateRight n) = drop (length s - n') s ++ take (length s - n') s where n' = n `mod` length s
applyOp s (RotateBased x) = 
    let idx = head [i | (i, c) <- zip [0..] s, c == x]
        rot = 1 + idx + (if idx >= 4 then 1 else 0)
    in applyOp s (RotateRight rot)
applyOp s (Reverse x y) = take x s ++ reverse (take (y - x + 1) (drop x s)) ++ drop (y + 1) s
applyOp s (Move x y) = 
    let c = s !! x
        s' = take x s ++ drop (x + 1) s
    in take y s' ++ [c] ++ drop y s'

scramble :: String -> [Op] -> String
scramble = foldl applyOp

unscramble :: String -> [Op] -> String
unscramble target ops = head [s | s <- permutations target, scramble s ops == target]

ops :: [Op]
ops = map parseOp input

part1 :: String
part1 = scramble "abcdefgh" ops

part2 :: String
part2 = unscramble "fbgdceah" ops
