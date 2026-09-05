import InputUtils (readInput)
import MD5Utils (md5Pure)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Sequence as Seq
import Data.Sequence ((|>))

input :: String
input = unsafePerformIO $ readInput 2016 17

passcode :: String
passcode = filter (/= '\n') input

type Pos = (Int, Int)

isOpen :: Char -> Bool
isOpen c = c `elem` "bcdef"

getOpenDoors :: String -> String -> [Char]
getOpenDoors pass path =
    let hash = md5Pure (pass ++ path)
        doors = zip "UDLR" (take 4 hash)
    in [d | (d, h) <- doors, isOpen h]

move :: Pos -> Char -> Maybe Pos
move (x, y) 'U' | y > 0 = Just (x, y - 1)
move (x, y) 'D' | y < 3 = Just (x, y + 1)
move (x, y) 'L' | x > 0 = Just (x - 1, y)
move (x, y) 'R' | x < 3 = Just (x + 1, y)
move _ _ = Nothing

findPaths :: String -> (Maybe String, Int)
findPaths pass = go (Seq.singleton ((0, 0), "")) Nothing 0
  where
    target = (3, 3)
    go queue shortest longest
        | Seq.null queue = (shortest, longest)
        | otherwise =
            let ((pos, path), rest) = case Seq.viewl queue of
                    (x Seq.:< xs) -> (x, xs)
                    Seq.EmptyL -> error "Empty queue"
            in if pos == target
               then let shortest' = case shortest of
                            Nothing -> Just path
                            Just p -> if length path < length p then Just path else shortest
                        longest' = max longest (length path)
                    in go rest shortest' longest'  -- do not expand past vault
               else
                    let openDoors = getOpenDoors pass path
                        neighbors = [(newPos, path ++ [dir]) | dir <- openDoors, Just newPos <- [move pos dir]]
                        newQueue = foldl (|>) rest neighbors
                    in go newQueue shortest longest

(shortest, longestPath) = findPaths passcode

part1 :: String
part1 = case shortest of Just p -> p; Nothing -> ""

part2 :: Int
part2 = longestPath
