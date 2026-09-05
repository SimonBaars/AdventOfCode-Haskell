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

-- Part 2: Reverse search to find minimum steps to make molecule
-- Use greedy approach: repeatedly apply replacements in reverse (longest first)
part2 :: Int
part2 = fabricate mol reps 0
  where
    (reps, mol) = parseInput input
    
    fabricate "e" _ steps = steps
    fabricate m rs steps = fabricate (applyOneReverse m rs) rs (steps + 1)
    
    applyOneReverse :: String -> [(String, String)] -> String
    applyOneReverse m rs = case [(i, from) | (from, to) <- rs, i <- findAll to m, i >= 0] of
        [] -> m
        matches -> let (pos, repl) = head $ reverse matches  -- Take rightmost/longest match
                      toMatch = head [to | (from, to) <- rs, from == repl]
                  in take pos m ++ repl ++ drop (pos + length toMatch) m
    
    findAll :: String -> String -> [Int]
    findAll pat str = [i | i <- [0..length str - length pat], take (length pat) (drop i str) == pat]
