-- | Utility module for loading Advent of Code puzzle inputs
-- Uses only standard library imports (no external dependencies)
module InputUtils
    ( readInput
    , readInputLines
    , readInputInts
    , inputPath
    ) where

import System.Directory (doesFileExist, createDirectoryIfMissing)
import System.Environment (lookupEnv)
import System.Process (readProcess)

-- | Construct the path to an input file for a given year and day
inputPath :: Int -> Int -> FilePath
inputPath year day = "inputs/" ++ show year ++ "/day" ++ show day ++ ".txt"

-- | Fetch input from Advent of Code website
fetchInput :: Int -> Int -> IO (Maybe String)
fetchInput year day = do
    sessionCookie <- lookupEnv "AOC_SESSION"
    case sessionCookie of
        Nothing -> return Nothing
        Just cookie -> do
            let url = "https://adventofcode.com/" ++ show year ++ "/day/" ++ show day ++ "/input"
            let curlCmd = "curl"
            let curlArgs = ["-s", "-H", "Cookie: session=" ++ cookie, url]
            result <- readProcess curlCmd curlArgs ""
            return $ Just result

-- | Read input file as a single string (trimming trailing newline)
-- Automatically fetches from AoC if file doesn't exist and AOC_SESSION is set
readInput :: Int -> Int -> IO String
readInput year day = do
    let path = inputPath year day
    exists <- doesFileExist path
    if exists
        then do
            content <- readFile path
            return $ stripTrailingNewline content
        else do
            -- Try to fetch from AoC
            maybeContent <- fetchInput year day
            case maybeContent of
                Just content -> do
                    -- Save to file for future use
                    let dir = "inputs/" ++ show year
                    createDirectoryIfMissing True dir
                    writeFile path content
                    return $ stripTrailingNewline content
                Nothing -> error $ "Input file not found: " ++ path ++ " (and AOC_SESSION not set)"

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
