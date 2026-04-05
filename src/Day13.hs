module Day13 (part1, part2) where

import Data.List (elemIndex, intercalate, sort)
import Text.ParserCombinators.Parsec

data Packet = PInt Int | PList [Packet]
  deriving (Eq, Show)

packet :: Parser Packet
packet = (PInt <$> read <$> many1 digit) <|> plist

plist :: Parser Packet
plist = do
  char '['
  xs <- packet `sepBy` char ','
  char ']'
  return $ PList xs

parsePacket :: String -> Packet
parsePacket s = case parse (packet <* eof) "" s of
  Left e -> error $ show e
  Right p -> p

instance Ord Packet where
  compare (PInt a) (PInt b) = compare a b
  compare (PInt a) (PList bs) = compare (PList [PInt a]) (PList bs)
  compare (PList as) (PInt b) = compare (PList as) (PList [PInt b])
  compare (PList as) (PList bs) = cmpList as bs
    where
      cmpList [] [] = EQ
      cmpList [] (_ : _) = LT
      cmpList (_ : _) [] = GT
      cmpList (x : xs) (y : ys) =
        case compare x y of
          EQ -> cmpList xs ys
          c -> c

parsePairs :: String -> [(Packet, Packet)]
parsePairs s =
  let blocks = splitBlocks $ lines s
   in map parseBlock blocks
  where
    splitBlocks [] = []
    splitBlocks ls =
      case break null ls of
        (a, _ : b) -> unlines a : splitBlocks b
        (a, []) -> [unlines a | not (null a)]

    parseBlock b =
      case lines b of
        [a, b'] -> (parsePacket a, parsePacket b')
        _ -> error "Day13: pair"

part1 :: String -> Int
part1 s =
  sum
    [ i
      | (i, (a, b)) <- zip [1 ..] (parsePairs s),
        a <= b
    ]

divider :: Int -> Packet
divider n = PList [PList [PInt n]]

part2 :: String -> Int
part2 s =
  let packets = concat [[a, b] | (a, b) <- parsePairs s]
      d2 = divider 2
      d6 = divider 6
      sorted = sort $ packets ++ [d2, d6]
      Just i2 = elemIndex d2 sorted
      Just i6 = elemIndex d6 sorted
   in (i2 + 1) * (i6 + 1)
