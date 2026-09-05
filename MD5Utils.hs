-- | MD5 utility using system md5sum/openssl for hashing
module MD5Utils (md5) where

import System.Process (readProcess)
import Data.Char (isSpace)

-- | Calculate MD5 hash of a string using system tools
md5 :: String -> IO String
md5 input = do
    result <- readProcess "sh" ["-c", "echo -n \"" ++ escape input ++ "\" | md5sum 2>/dev/null || echo -n \"" ++ escape input ++ "\" | openssl md5 | cut -d' ' -f2"] ""
    return $ filter (not . isSpace) result
  where
    escape = concatMap escapeChar
    escapeChar '"' = "\\\""
    escapeChar '\\' = "\\\\"
    escapeChar '$' = "\\$"
    escapeChar '`' = "\\`"
    escapeChar c = [c]
