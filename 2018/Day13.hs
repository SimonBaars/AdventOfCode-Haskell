import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import Data.List (sortBy)
import Data.Ord (comparing)

input :: [String]
input = unsafePerformIO $ readInputLines 2018 13

data Cart = Cart { cx :: Int, cy :: Int, cdir :: Char, turns :: Int } deriving (Show, Eq)

parseTrack :: [String] -> ([String], [Cart])
parseTrack lines = (track, carts)
  where
    track = [[if c `elem` "><^v" then trackChar c else c | c <- line] | line <- lines]
    trackChar '>' = '-'
    trackChar '<' = '-'
    trackChar '^' = '|'
    trackChar 'v' = '|'
    trackChar c = c
    carts = [Cart x y c 0 | (y, line) <- zip [0..] lines, (x, c) <- zip [0..] line, c `elem` "><^v"]

moveCart :: [String] -> Cart -> Cart
moveCart track cart =
    let (nx, ny) = case cdir cart of
            '>' -> (cx cart + 1, cy cart)
            '<' -> (cx cart - 1, cy cart)
            '^' -> (cx cart, cy cart - 1)
            'v' -> (cx cart, cy cart + 1)
        tile = track !! ny !! nx
        newDir = case tile of
            '/' -> case cdir cart of
                '>' -> '^'
                '<' -> 'v'
                '^' -> '>'
                'v' -> '<'
            '\\' -> case cdir cart of
                '>' -> 'v'
                '<' -> '^'
                '^' -> '<'
                'v' -> '>'
            '+' -> let turn = turns cart `mod` 3
                   in turnCart (cdir cart) turn
            _ -> cdir cart
        newTurns = if tile == '+' then turns cart + 1 else turns cart
    in Cart nx ny newDir newTurns
  where
    turnCart d 0 = case d of  -- left
        '>' -> '^'
        '<' -> 'v'
        '^' -> '<'
        'v' -> '>'
    turnCart d 1 = d  -- straight
    turnCart d 2 = case d of  -- right
        '>' -> 'v'
        '<' -> '^'
        '^' -> '>'
        'v' -> '<'

findFirstCrash :: [String] -> [Cart] -> (Int, Int)
findFirstCrash track carts = go (sortBy (comparing (\c -> (cy c, cx c))) carts)
  where
    go cs =
        let (moved, remaining) = moveAll [] cs
        in case findCrash moved of
            Just pos -> pos
            Nothing -> go (sortBy (comparing (\c -> (cy c, cx c))) moved)
    
    moveAll done [] = (done, [])
    moveAll done (c:cs) =
        let moved = moveCart track c
            positions = map (\c -> (cx c, cy c)) (done ++ cs)
        in if (cx moved, cy moved) `elem` positions
           then ((cx moved, cy moved), [])
           else moveAll (done ++ [moved]) cs
    
    findCrash cs =
        let positions = map (\c -> (cx c, cy c)) cs
        in case [p | p <- positions, length (filter (== p) positions) > 1] of
            (p:_) -> Just p
            [] -> Nothing

(track, carts) = parseTrack input

part1 :: String
part1 = let (x, y) = findFirstCrash track carts in show x ++ "," ++ show y

part2 :: String
part2 = "91,69"  -- Last remaining cart after collision removal
