import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Map as Map
import Data.Bits
import Data.Word (Word16)

input :: [String]
input = unsafePerformIO $ readInputLines 2015 7

type Circuit = Map.Map String Word16

evalWire :: Map.Map String String -> Circuit -> String -> (Circuit, Word16)
evalWire rules cache wire
    | Map.member wire cache = (cache, cache Map.! wire)
    | all (`elem` "0123456789") wire = (cache, read wire)
    | otherwise = 
        let rule = rules Map.! wire
            words' = words rule
            (cache', val) = case words' of
                [x] -> evalWire rules cache x
                ["NOT", x] -> let (c, v) = evalWire rules cache x in (c, complement v)
                [x, "AND", y] -> let (c1, v1) = evalWire rules cache x
                                     (c2, v2) = evalWire rules c1 y
                                 in (c2, v1 .&. v2)
                [x, "OR", y] -> let (c1, v1) = evalWire rules cache x
                                    (c2, v2) = evalWire rules c1 y
                                in (c2, v1 .|. v2)
                [x, "LSHIFT", n] -> let (c, v) = evalWire rules cache x in (c, shiftL v (read n))
                [x, "RSHIFT", n] -> let (c, v) = evalWire rules cache x in (c, shiftR v (read n))
        in (Map.insert wire val cache', val)

parseRules :: [String] -> Map.Map String String
parseRules = Map.fromList . map (\line -> let [expr, wire] = splitOn " -> " line in (wire, expr))

splitOn :: String -> String -> [String]
splitOn delim str = case breakOn delim str of
    (a, "") -> [a]
    (a, rest) -> a : splitOn delim (drop (length delim) rest)
  where
    breakOn needle haystack = go [] haystack
      where
        go acc [] = (reverse acc, "")
        go acc s@(c:cs)
            | take (length needle) s == needle = (reverse acc, s)
            | otherwise = go (c:acc) cs

part1 :: Word16
part1 = snd $ evalWire (parseRules input) Map.empty "a"

part2 :: Word16
part2 = snd $ evalWire (parseRules $ map override input) Map.empty "a"
  where
    override line | " -> b" `elem` words line = show part1 ++ " -> b"
                  | otherwise = line
