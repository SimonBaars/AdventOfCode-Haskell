-- | Pure Haskell MD5 (no external process). Returns lowercase hex digest.
module MD5Utils (md5, md5Pure) where

import Data.Bits
import Data.Char (intToDigit, ord)
import Data.Word (Word32, Word8)
import Data.List (foldl')

-- | IO wrapper kept for API compatibility with existing call sites
md5 :: String -> IO String
md5 = return . md5Pure

md5Pure :: String -> String
md5Pure = toHex . md5Bytes . map (fromIntegral . ord)

toHex :: [Word8] -> String
toHex = concatMap (\b -> [intToDigit (fromIntegral (b `shiftR` 4)), intToDigit (fromIntegral (b .&. 15))])

-- Convert little-endian Word32 list (4 words = 16 bytes digest) to bytes
md5Bytes :: [Word8] -> [Word8]
md5Bytes msg = concatMap wordToBytes [a,b,c,d]
  where
    (a,b,c,d) = md5Digest msg

wordToBytes :: Word32 -> [Word8]
wordToBytes w = [fromIntegral (w `shiftR` (8*i)) | i <- [0..3]]

md5Digest :: [Word8] -> (Word32, Word32, Word32, Word32)
md5Digest msg = foldl' processChunk (0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476) chunks
  where
    bitLen = fromIntegral (length msg * 8) :: Word32
    bitLen64 = fromIntegral (length msg * 8) :: Integer
    padded = msg ++ [0x80] ++ replicate padZeroes 0 ++ lenBytes
    padZeroes = (56 - (length msg + 1) `mod` 64) `mod` 64
    lenBytes = [fromIntegral ((bitLen64 `shiftR` (8*i)) .&. 0xff) | i <- [0..7]]
    chunks = chunk64 padded

chunk64 :: [Word8] -> [[Word8]]
chunk64 [] = []
chunk64 xs = take 64 xs : chunk64 (drop 64 xs)

processChunk :: (Word32, Word32, Word32, Word32) -> [Word8] -> (Word32, Word32, Word32, Word32)
processChunk (a0,b0,c0,d0) chunk = (a0+a, b0+b, c0+c, d0+d)
  where
    w = wordsFromChunk chunk
    (a,b,c,d) = go 0 a0 b0 c0 d0
    go i a b c d
      | i >= 64 = (a,b,c,d)
      | otherwise =
          let (f, g) = fg i b c d
              f' = f + a + k i + (w !! g)
              a' = d
              d' = c
              c' = b
              b' = b + rotateL f' (r i)
          in go (i+1) a' b' c' d'

wordsFromChunk :: [Word8] -> [Word32]
wordsFromChunk bs = [ wordAt i | i <- [0,4..60] ]
  where
    wordAt i = fromIntegral (bs!!i)
             + (fromIntegral (bs!!(i+1)) `shiftL` 8)
             + (fromIntegral (bs!!(i+2)) `shiftL` 16)
             + (fromIntegral (bs!!(i+3)) `shiftL` 24)

fg :: Int -> Word32 -> Word32 -> Word32 -> (Word32, Int)
fg i b c d
  | i < 16 = ((b .&. c) .|. ((complement b) .&. d), i)
  | i < 32 = ((d .&. b) .|. ((complement d) .&. c), (5*i + 1) `mod` 16)
  | i < 48 = (b `xor` c `xor` d, (3*i + 5) `mod` 16)
  | otherwise = (c `xor` (b .|. complement d), (7*i) `mod` 16)

r :: Int -> Int
r i = rs !! i
  where
    rs = [7,12,17,22, 7,12,17,22, 7,12,17,22, 7,12,17,22,
          5, 9,14,20, 5, 9,14,20, 5, 9,14,20, 5, 9,14,20,
          4,11,16,23, 4,11,16,23, 4,11,16,23, 4,11,16,23,
          6,10,15,21, 6,10,15,21, 6,10,15,21, 6,10,15,21]

k :: Int -> Word32
k i = ks !! i
  where
    -- floor(2^32 * abs(sin(i+1))) for i in 0..63
    ks = [
      0xd76aa478,0xe8c7b756,0x242070db,0xc1bdceee,0xf57c0faf,0x4787c62a,0xa8304613,0xfd469501,
      0x698098d8,0x8b44f7af,0xffff5bb1,0x895cd7be,0x6b901122,0xfd987193,0xa679438e,0x49b40821,
      0xf61e2562,0xc040b340,0x265e5a51,0xe9b6c7aa,0xd62f105d,0x02441453,0xd8a1e681,0xe7d3fbc8,
      0x21e1cde6,0xc33707d6,0xf4d50d87,0x455a14ed,0xa9e3e905,0xfcefa3f8,0x676f02d9,0x8d2a4c8a,
      0xfffa3942,0x8771f681,0x6d9d6122,0xfde5380c,0xa4beea44,0x4bdecfa9,0xf6bb4b60,0xbebfbc70,
      0x289b7ec6,0xeaa127fa,0xd4ef3085,0x04881d05,0xd9d4d039,0xe6db99e5,0x1fa27cf8,0xc4ac5665,
      0xf4292244,0x432aff97,0xab9423a7,0xfc93a039,0x655b59c3,0x8f0ccc92,0xffeff47d,0x85845dd1,
      0x6fa87e4f,0xfe2ce6e0,0xa3014314,0x4e0811a1,0xf7537e82,0xbd3af235,0x2ad7d2bb,0xeb86d391]
