import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)
import Data.List (findIndex, maximumBy, sortBy)
import Data.Ord (comparing)
import qualified Data.Set as Set
import qualified Data.Map as Map

type Point = (Int, Int, Int)
type Scanner = [Point]

input :: [Scanner]
input = unsafePerformIO $ parseScanners <$> readInput 2021 19

parseScanners :: String -> [Scanner]
parseScanners s = map parseScanner $ splitOn "\n\n" s

splitOn :: String -> String -> [String]
splitOn sep str = go str
  where
    go [] = []
    go s' = case breakStr sep s' of
        (a, []) -> [a]
        (a, rest) -> a : go (drop (length sep) rest)

breakStr :: String -> String -> (String, String)
breakStr sep s = go [] s
  where
    go acc [] = (reverse acc, [])
    go acc str | take (length sep) str == sep = (reverse acc, str)
               | otherwise = go (head str : acc) (tail str)

parseScanner :: String -> Scanner
parseScanner s = [parsePoint l | l <- tail (lines s), not (null l)]
  where
    parsePoint l = let [x,y,z] = map read $ splitOn "," l in (x,y,z)

rotations :: [Point -> Point]
rotations = [ \(x,y,z) -> (x,y,z)
            , \(x,y,z) -> (x,-y,-z)
            , \(x,y,z) -> (x,z,-y)
            , \(x,y,z) -> (x,-z,y)
            , \(x,y,z) -> (-x,y,-z)
            , \(x,y,z) -> (-x,-y,z)
            , \(x,y,z) -> (-x,z,y)
            , \(x,y,z) -> (-x,-z,-y)
            , \(x,y,z) -> (y,x,-z)
            , \(x,y,z) -> (y,-x,z)
            , \(x,y,z) -> (y,z,x)
            , \(x,y,z) -> (y,-z,-x)
            , \(x,y,z) -> (-y,x,z)
            , \(x,y,z) -> (-y,-x,-z)
            , \(x,y,z) -> (-y,z,-x)
            , \(x,y,z) -> (-y,-z,x)
            , \(x,y,z) -> (z,y,-x)
            , \(x,y,z) -> (z,-y,x)
            , \(x,y,z) -> (z,x,y)
            , \(x,y,z) -> (z,-x,-y)
            , \(x,y,z) -> (-z,y,x)
            , \(x,y,z) -> (-z,-y,-x)
            , \(x,y,z) -> (-z,x,-y)
            , \(x,y,z) -> (-z,-x,y)
            ]

allRotations :: Scanner -> [Scanner]
allRotations scan = [map rot scan | rot <- rotations]

translate :: Point -> Scanner -> Scanner
translate (dx,dy,dz) = map (\(x,y,z) -> (x+dx,y+dy,z+dz))

overlap :: Scanner -> Scanner -> Maybe (Scanner, Point)
overlap ref scan = case candidates of
    [] -> Nothing
    (s:_) -> Just s
  where
    refSet = Set.fromList ref
    candidates = [(translated, trans) 
                 | rotated <- allRotations scan
                 , p1 <- ref
                 , p2 <- rotated
                 , let trans@(dx,dy,dz) = (fst3 p1 - fst3 p2, snd3 p1 - snd3 p2, trd3 p1 - trd3 p2)
                 , let translated = translate trans rotated
                 , length (filter (`Set.member` refSet) translated) >= 12
                 ]
    fst3 (x,_,_) = x
    snd3 (_,y,_) = y
    trd3 (_,_,z) = z

solve :: [Scanner] -> (Set.Set Point, [Point])
solve (first:rest) = go (Set.fromList first) rest [(0,0,0)]
  where
    go beacons [] scanners = (beacons, scanners)
    go beacons remaining scanners =
        case findMatch (Set.toList beacons) remaining of
            Nothing -> (beacons, scanners)
            Just (matched, scanner, remaining') ->
                go (Set.union beacons (Set.fromList matched)) remaining' (scanner:scanners)
    
    findMatch _ [] = Nothing
    findMatch ref (s:ss) = case overlap ref s of
        Just (matched, scanner) -> Just (matched, scanner, ss)
        Nothing -> case findMatch ref ss of
            Just (m, sc, ss') -> Just (m, sc, s:ss')
            Nothing -> Nothing

manhattan :: Point -> Point -> Int
manhattan (x1,y1,z1) (x2,y2,z2) = abs (x1-x2) + abs (y1-y2) + abs (z1-z2)

part1 :: Int
part1 = Set.size beacons
  where (beacons, _) = solve input

part2 :: Int
part2 = maximum [manhattan s1 s2 | s1 <- scanners, s2 <- scanners]
  where (_, scanners) = solve input
