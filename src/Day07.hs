module Day07 (part1, part2) where

import Control.Arrow (second)
import Control.Monad.State
import qualified Data.Map as Map

data Cmd = CdRoot | CdUp | Cd String | Ls | File Int String | Dir String

parseLine :: String -> Cmd
parseLine s
  | s == "$ cd /" = CdRoot
  | s == "$ cd .." = CdUp
  | take 5 s == "$ cd " = Cd (drop 5 s)
  | s == "$ ls" = Ls
  | take 4 s == "dir " = Dir (drop 4 s)
  | otherwise =
      case words s of
        [sz, name] -> File (read sz) name
        _ -> error "Day07: bad line"

type FS = Map.Map [String] Int -- full file path -> size

type St = ([String], FS)

process :: [Cmd] -> FS
process cmds = snd $ execState (mapM_ step cmds) ([], Map.empty)
  where
    step :: Cmd -> State St ()
    step CdRoot = modify $ \(_, fs) -> ([], fs)
    step CdUp = modify $ \(p, fs) -> (up p, fs)
      where
        up [] = []
        up xs = init xs
    step (Cd name) = modify $ \(p, fs) -> (p ++ [name], fs)
    step Ls = pure ()
    step (Dir _) = pure ()
    step (File sz name) = do
      p <- gets fst
      let full = p ++ [name]
      modify $ second $ Map.insert full sz
      where
        second f (a, b) = (a, f b)

dirSizes :: FS -> Map.Map [String] Int
dirSizes fs =
  Map.fromListWith (+) $
    concat
      [ [ (take i (init full), sz)
          | i <- [0 .. length (init full)]
        ]
        | (full, sz) <- Map.toList fs
      ]

part1 :: String -> Int
part1 s =
  let fs = process $ map parseLine $ lines s
      ds = dirSizes fs
   in sum [sz | (_, sz) <- Map.toList ds, sz <= 100000]

part2 :: String -> Int
part2 s =
  let fs = process $ map parseLine $ lines s
      ds = dirSizes fs
      used = Map.findWithDefault 0 [] ds
      need = 30000000 - (70000000 - used)
      candidates = [sz | (_, sz) <- Map.toList ds, sz >= need]
   in minimum candidates
