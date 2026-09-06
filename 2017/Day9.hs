import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)

input :: String
input = unsafePerformIO $ readInput 2017 9

processStream :: String -> (Int, Int)
processStream = go 0 0 1 False
  where
    go score garbage _ _ [] = (score, garbage)
    go score garbage level inGarbage ('!':_:rest) = go score garbage level inGarbage rest
    go score garbage level True ('>':rest) = go score garbage level False rest
    go score garbage level True (_:rest) = go score (garbage + 1) level True rest
    go score garbage level False ('<':rest) = go score garbage level True rest
    go score garbage level False ('{':rest) = go (score + level) garbage (level + 1) False rest
    go score garbage level False ('}':rest) = go score garbage (level - 1) False rest
    go score garbage level False (_:rest) = go score garbage level False rest

(totalScore, garbageCount) = processStream input

part1 :: Int
part1 = totalScore

part2 :: Int
part2 = garbageCount
