module InputUtils
    ( readInput
    , readInputLines
    , readInputInts
    , fetchInputIfNeeded
    , inputPath
    ) where

import System.Directory (doesFileExist)
import System.Environment (lookupEnv)
import System.IO (hPutStrLn, stderr)
import Network.HTTP.Simple (httpBS, parseRequest, getResponseBody, addRequestHeader)
import qualified Data.ByteString.Char8 as BS

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

-- | Fetch input from Advent of Code if the file doesn't exist
-- Requires AOC_SESSION or AOC_COOKIE environment variable
fetchInputIfNeeded :: Int -> Int -> IO ()
fetchInputIfNeeded year day = do
    let path = inputPath year day
    exists <- doesFileExist path
    if exists
        then return ()
        else do
            hPutStrLn stderr $ "Input file not found: " ++ path
            hPutStrLn stderr "Attempting to fetch from adventofcode.com..."
            session <- lookupSession
            case session of
                Nothing -> do
                    hPutStrLn stderr "Error: AOC_SESSION or AOC_COOKIE environment variable not set"
                    hPutStrLn stderr "Please either:"
                    hPutStrLn stderr "  1. Set AOC_SESSION env var with your session cookie"
                    hPutStrLn stderr "  2. Manually download input to: " ++ path
                Just cookie -> fetchAndSaveInput year day cookie path

-- | Look up session cookie from environment
lookupSession :: IO (Maybe String)
lookupSession = do
    session <- lookupEnv "AOC_SESSION"
    case session of
        Just s -> return $ Just s
        Nothing -> lookupEnv "AOC_COOKIE"

-- | Fetch input from Advent of Code and save to file
fetchAndSaveInput :: Int -> Int -> String -> FilePath -> IO ()
fetchAndSaveInput year day session path = do
    let url = "https://adventofcode.com/" ++ show year ++ "/day/" ++ show day ++ "/input"
    request <- parseRequest url
    let requestWithCookie = addRequestHeader "Cookie" (BS.pack $ "session=" ++ session) request
    response <- httpBS requestWithCookie
    let content = BS.unpack $ getResponseBody response
    writeFile path content
    hPutStrLn stderr $ "Input saved to: " ++ path
