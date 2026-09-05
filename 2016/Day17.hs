import InputUtils (readInput)
import MD5Utils (md5)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Sequence as Seq
import Data.Sequence ((<|), (|>))

input :: String
input = unsafePerformIO $ readInput 2016 17

passcode :: String
passcode = filter (/= '\n') input

type Pos = (Int, Int)
type State = (Pos, String)

isOpen :: Char -> Bool
isOpen c = c `elem` "bcdef"

getOpenDoors :: String -> String -> [Char]
getOpenDoors pass path =
    let hash = unsafePerformIO $ md5 (pass ++ path)
        doors = zip "UDLR" hash
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
        | pos == target = go rest shortest (max longest (length path))
        | otherwise =
            let openDoors = getOpenDoors pass path
                neighbors = [(newPos, path ++ [dir]) | dir <- openDoors, Just newPos <- [move pos dir]]
                newQueue = foldl (|>) rest neighbors
            in go newQueue (if pos == target && (shortest == Nothing || length path < length (case shortest of Just p -> p; Nothing -> replicate 999 'x')) then Just path else shortest) longest
      where
        ((pos, path), rest) = case Seq.viewl queue of
            (x Seq.:< xs) -> (x, xs)
            Seq.EmptyL -> error "Empty queue"

(shortest, longest) = findPaths passcode

part1 :: String
part1 = case shortest of Just p -> p; Nothing -> ""

part2 :: Int
part2 = longest
