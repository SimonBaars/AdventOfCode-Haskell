import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Set as Set

input :: String
input = unsafePerformIO $ readInput 2015 19

parseInput :: String -> ([(String, String)], String)
parseInput s = (replacements, molecule)
  where
    ls = lines s
    molecule = last ls
    replacements = [(words line !! 0, words line !! 2) | line <- init $ init ls, not $ null line]

applyReplacements :: [(String, String)] -> String -> Set.Set String
applyReplacements reps mol = Set.fromList [take i mol ++ to ++ drop (i + length from) mol
                                          | (from, to) <- reps, i <- [0..length mol - length from],
                                            take (length from) (drop i mol) == from]

part1 :: Int
part1 = Set.size $ applyReplacements reps mol
  where
    (reps, mol) = parseInput input

part2 :: Int
part2 = 0  -- Requires reverse BFS/greedy search
