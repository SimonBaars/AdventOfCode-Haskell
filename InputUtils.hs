-- | Utility module for loading Advent of Code puzzle inputs
-- Uses only standard library imports (no external dependencies)
module InputUtils
    ( readInput
    , readInputLines
    , readInputInts
    , inputPath
    ) where

-- | Construct the path to an input file for a given year and day
inputPath :: Int -> Int -> FilePath
inputPath year day = "inputs/" ++ show year ++ "/day" ++ show day ++ ".txt"

-- | Read input file as a single string (trimming trailing newline)
readInput :: Int -> Int -> IO String
readInput year day = do
    let path = inputPath year day
    content <- readFile path
    return $ stripTrailingNewline content

-- | Read input file as list of lines
readInputLines :: Int -> Int -> IO [String]
readInputLines year day = lines <$> readInput year day

-- | Read input file as list of integers (one per line)
readInputInts :: Int -> Int -> IO [Integer]
readInputInts year day = map read <$> readInputLines year day

-- | Strip trailing newline from string
stripTrailingNewline :: String -> String
stripTrailingNewline s
    | not (null s) && last s == '\n' = init s
    | otherwise = s
