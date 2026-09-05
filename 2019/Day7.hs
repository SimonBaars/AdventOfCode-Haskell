import InputUtils (readInput)
import Intcode
import System.IO.Unsafe (unsafePerformIO)
import Data.List (permutations)

input :: String
input = unsafePerformIO $ readInput 2019 7

program :: Program
program = parseProgram input

runAmplifier :: Program -> Int -> Int -> Int
runAmplifier prog phase inputSignal = head $ runProgram prog [phase, inputSignal]

runAmplifierChain :: Program -> [Int] -> Int
runAmplifierChain prog phases = foldl (runAmplifier prog) 0 phases

part1 :: Int
part1 = maximum [runAmplifierChain program phases | phases <- permutations [0..4]]

part2 :: Int
part2 = maximum [runFeedback program phases | phases <- permutations [5..9]]
  where
    runFeedback prog phases = go (map (initVM prog . (:[])) phases) 0
      where
        go vms signal =
            let results = scanl runAmp signal (zip vms [0..])
                runAmp sig (vm, _) = let vm' = runWithInput vm [sig]
                                         vm'' = runUntilOutput vm'
                                     in if null (output vm'') then sig else last (output vm'')
            in if all ((== Halted) . state) vms then last results else go vms (last results)
