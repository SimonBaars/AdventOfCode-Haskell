-- | Fetch puzzle input from adventofcode.com and cache under @.cache/aoc/@.
--
-- Set @AOC_SESSION@ to the value of your browser session cookie (without
-- @session=@). On a cache miss the input is downloaded; afterwards the local
-- file is reused so nothing sensitive needs to be committed.
module AOC.Input (getInput, getInputLines, year) where

import Control.Exception (try)
import qualified Data.ByteString.Char8 as B
import qualified Data.ByteString.Lazy.Char8 as BL8
import Network.HTTP.Client
import Network.HTTP.Client.TLS
import Network.HTTP.Types.Header (hCookie)
import System.Directory (createDirectoryIfMissing)
import System.Environment (lookupEnv)
import System.FilePath ((</>))
import System.IO.Error (isDoesNotExistError)

year :: Int
year = 2022

cacheDir :: FilePath
cacheDir = ".cache" </> "aoc" </> show year

cachePath :: Int -> FilePath
cachePath day = cacheDir </> "day" ++ pad day ++ ".txt"
  where
    pad d | d < 10 = '0' : show d
          | otherwise = show d

fetchInput :: Int -> IO String
fetchInput day = do
  sess <- lookupEnv "AOC_SESSION"
  case sess of
    Nothing ->
      fail $
        "Missing AOC_SESSION: set it to your adventofcode.com session cookie "
          ++ "to download input, or populate "
          ++ cachePath day
          ++ " manually."
    Just session -> do
      mgr <- newManager tlsManagerSettings
      initReq <- parseRequest $ "https://adventofcode.com/" ++ show year ++ "/day/" ++ show day ++ "/input"
      let req =
            initReq
              { requestHeaders = [(hCookie, B.pack $ "session=" ++ session)]
              }
      resp <- httpLbs req mgr
      pure $ BL8.unpack $ responseBody resp

getInput :: Int -> IO String
getInput day = do
  let cacheFile = cachePath day
  cached <- try (readFile cacheFile) :: IO (Either IOError String)
  case cached of
    Right s -> pure s
    Left e
      | isDoesNotExistError e -> do
          createDirectoryIfMissing True cacheDir
          s <- fetchInput day
          writeFile cacheFile s
          pure s
      | otherwise -> ioError e

-- | Split on newlines (same as @lines@ on the raw input).
getInputLines :: Int -> IO [String]
getInputLines day = lines <$> getInput day
