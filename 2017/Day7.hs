import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Map as Map
import Data.List (maximumBy)
import Data.Ord (comparing)

input :: [String]
input = unsafePerformIO $ readInputLines 2017 7

type Program = (String, Int, [String])

parseProgram :: String -> Program
parseProgram str = case words $ filter (/= ',') str of
    (name:weight:rest) -> 
        let w = read $ filter (`elem` "0123456789") weight
            children = drop 1 rest
        in (name, w, children)
    _ -> error $ "Invalid program: " ++ str

findRoot :: [Program] -> String
findRoot progs = head [name | (name, _, _) <- progs, name `notElem` allChildren]
  where allChildren = concatMap (\(_, _, cs) -> cs) progs

calcWeight :: Map.Map String (Int, [String]) -> String -> Int
calcWeight weights name = 
    let (w, children) = weights Map.! name
    in w + sum [calcWeight weights child | child <- children]

findUnbalanced :: Map.Map String (Int, [String]) -> String -> Int
findUnbalanced weights root = go root
  where
    go name =
        let (w, children) = weights Map.! name
            childWeights = [(child, calcWeight weights child) | child <- children]
        in if null children || length (map snd childWeights) == length (filter (== snd (head childWeights)) (map snd childWeights))
           then 0
           else let unbalanced = head [c | c <- childWeights, length (filter (== snd c) (map snd childWeights)) == 1]
                    target = head [snd c | c <- childWeights, snd c /= snd unbalanced]
                    diff = target - snd unbalanced
                    result = go (fst unbalanced)
                in if result == 0 then fst (weights Map.! fst unbalanced) + diff else result

programs :: [Program]
programs = map parseProgram input

weights :: Map.Map String (Int, [String])
weights = Map.fromList [(name, (w, cs)) | (name, w, cs) <- programs]

part1 :: String
part1 = findRoot programs

part2 :: Int
part2 = findUnbalanced weights part1
