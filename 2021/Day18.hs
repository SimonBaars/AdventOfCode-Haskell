import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

data SNum = Regular Int | Pair SNum SNum deriving (Show, Eq)

input :: [SNum]
input = unsafePerformIO $ map parseNum <$> readInputLines 2021 18

parseNum :: String -> SNum
parseNum s = fst $ parse s
  where
    parse ('[':rest) = 
        let (left, ',':rest2) = parse rest
            (right, ']':rest3) = parse rest2
        in (Pair left right, rest3)
    parse (c:rest) | c `elem` "0123456789" = (Regular (read [c]), rest)

magnitude :: SNum -> Int
magnitude (Regular n) = n
magnitude (Pair a b) = 3 * magnitude a + 2 * magnitude b

add :: SNum -> SNum -> SNum
add a b = reduce $ Pair a b

reduce :: SNum -> SNum
reduce n = case explodeNum n 0 of
    Just (n', _, _) -> reduce n'
    Nothing -> case splitNum n of
        Just n' -> reduce n'
        Nothing -> n

explodeNum :: SNum -> Int -> Maybe (SNum, Int, Int)
explodeNum (Pair (Regular a) (Regular b)) depth | depth >= 4 = Just (Regular 0, a, b)
explodeNum (Pair l r) depth = 
    case explodeNum l (depth + 1) of
        Just (l', left, right) -> Just (Pair l' (addLeft r right), left, 0)
        Nothing -> case explodeNum r (depth + 1) of
            Just (r', left, right) -> Just (Pair (addRight l left) r', 0, right)
            Nothing -> Nothing
explodeNum _ _ = Nothing

addLeft :: SNum -> Int -> SNum
addLeft (Regular n) x = Regular (n + x)
addLeft (Pair l r) x = Pair (addLeft l x) r

addRight :: SNum -> Int -> SNum
addRight (Regular n) x = Regular (n + x)
addRight (Pair l r) x = Pair l (addRight r x)

splitNum :: SNum -> Maybe SNum
splitNum (Regular n) | n >= 10 = Just $ Pair (Regular (n `div` 2)) (Regular ((n + 1) `div` 2))
splitNum (Pair l r) = case splitNum l of
    Just l' -> Just $ Pair l' r
    Nothing -> case splitNum r of
        Just r' -> Just $ Pair l r'
        Nothing -> Nothing
splitNum _ = Nothing

part1 :: Int
part1 = magnitude $ foldl1 add input

part2 :: Int
part2 = maximum [magnitude (add a b) | a <- input, b <- input, a /= b]
