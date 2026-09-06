-- Day 7: No Space Left On Device
-- Part 1: Sum of sizes of directories with total size <= 100000
-- Part 2: Find smallest directory to delete to free up space

import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Map as M
import Data.List (isPrefixOf)

input :: [String]
input = unsafePerformIO $ readInputLines 2022 7

type Path = [String]
type FileSystem = M.Map Path Int

-- Build file system from commands
buildFS :: [String] -> FileSystem
buildFS cmds = snd $ foldl processLine ([], M.empty) cmds
  where
    processLine (path, fs) line
        | "$ cd /" `isPrefixOf` line = (["/"], fs)
        | "$ cd .." `isPrefixOf` line = (init path, fs)
        | "$ cd " `isPrefixOf` line = (path ++ [drop 5 line], fs)
        | "$ ls" `isPrefixOf` line = (path, fs)
        | "dir " `isPrefixOf` line = (path, fs)
        | otherwise = (path, addFile path (parseFile line) fs)
    
    parseFile line = read $ takeWhile (/= ' ') line :: Int
    
    addFile path size fs = foldl (\m p -> M.insertWith (+) p size m) fs (allPaths path)
    
    allPaths [] = []
    allPaths path = [take i path | i <- [1..length path]]

-- Calculate directory sizes
getDirSizes :: FileSystem -> [Int]
getDirSizes = M.elems

part1 :: Int
part1 = sum $ filter (<= 100000) $ getDirSizes $ buildFS input

part2 :: Int
part2 = minimum $ filter (>= needed) sizes
  where
    sizes = getDirSizes $ buildFS input
    totalUsed = maximum sizes
    totalSpace = 70000000
    needFree = 30000000
    currentFree = totalSpace - totalUsed
    needed = needFree - currentFree
