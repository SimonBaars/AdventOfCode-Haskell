import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

input :: [String]
input = unsafePerformIO $ readInputLines 2015 21

data Character = Character { hp :: Int, damage :: Int, armor :: Int } deriving Show

boss :: Character
boss = Character 100 8 2  -- Example values

weapons = [(8,4,0), (10,5,0), (25,6,0), (40,7,0), (74,8,0)]
armors = [(0,0,0), (13,0,1), (31,0,2), (53,0,3), (75,0,4), (102,0,5)]
rings = [(0,0,0), (0,0,0), (25,1,0), (50,2,0), (100,3,0), (20,0,1), (40,0,2), (80,0,3)]

wins :: Character -> Character -> Bool
wins player b = hitsToKill player b <= hitsToKill b player
  where
    hitsToKill attacker defender = ceiling $ fromIntegral (hp defender) / fromIntegral (max 1 $ damage attacker - armor defender)

part1 :: Int
part1 = minimum [cost | (wcost, wd, _) <- weapons, (acost, _, aa) <- armors,
                        (r1cost, r1d, r1a) <- rings, (r2cost, r2d, r2a) <- rings,
                        let cost = wcost + acost + r1cost + r2cost,
                        let player = Character 100 (wd + r1d + r2d) (aa + r1a + r2a),
                        wins player boss]

part2 :: Int
part2 = maximum [cost | (wcost, wd, _) <- weapons, (acost, _, aa) <- armors,
                        (r1cost, r1d, r1a) <- rings, (r2cost, r2d, r2a) <- rings,
                        let cost = wcost + acost + r1cost + r2cost,
                        let player = Character 100 (wd + r1d + r2d) (aa + r1a + r2a),
                        not $ wins player boss]
