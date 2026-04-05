module Day05 (part1, part2) where

type Stacks = [[Char]]

parseStacks :: String -> (Stacks, String)
parseStacks raw =
  let ls = lines raw
      (stackLines, rest) = break (all (`elem` " \t")) ls
      numsLine = last stackLines
      colCount = read @Int $ last $ words numsLine
      body = init stackLines
      cols =
        [ filter (`elem` ['A' .. 'Z']) $
            map (!! i) body
          | i <- [1, 5 .. 4 * colCount - 3]
        ]
      movesPart = drop 1 rest -- skip blank
   in (cols, unlines movesPart)

parseMove :: String -> (Int, Int, Int)
parseMove s =
  case words s of
    ["move", a, "from", b, "to", c] -> (read a, read b, read c)
    _ -> error "Day05: bad move"

apply9000 :: Stacks -> (Int, Int, Int) -> Stacks
apply9000 stacks (n, from, to) =
  let f = from - 1
      t = to - 1
      (chunk, rest) = splitAt n (stacks !! f)
      newFrom = rest
      newTo = reverse chunk ++ (stacks !! t)
   in update2 f newFrom t newTo stacks

apply9001 :: Stacks -> (Int, Int, Int) -> Stacks
apply9001 stacks (n, from, to) =
  let f = from - 1
      t = to - 1
      (chunk, rest) = splitAt n (stacks !! f)
      newFrom = rest
      newT = chunk ++ (stacks !! t)
   in update2 f newFrom t newT stacks

update2 :: Int -> [a] -> Int -> [a] -> [[a]] -> [[a]]
update2 i vi j vj xs =
  [ if | k == i -> vi
       | k == j -> vj
       | otherwise -> x
    | (k, x) <- zip [0 ..] xs
  ]

run :: (Stacks -> (Int, Int, Int) -> Stacks) -> String -> String
run f s =
  let (stacks0, movesRaw) = parseStacks s
      moves = map parseMove $ filter (not . null) $ lines movesRaw
      stacks = foldl f stacks0 moves
   in map head stacks

part1 :: String -> String
part1 = run apply9000

part2 :: String -> String
part2 = run apply9001
