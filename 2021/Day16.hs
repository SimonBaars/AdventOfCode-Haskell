import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)
import Numeric (readHex)

input :: String
input = unsafePerformIO $ readInput 2021 16

hexToBin :: String -> String
hexToBin = concatMap hexDigitToBin
  where
    hexDigitToBin c = case readHex [c] of
        [(n, "")] -> pad 4 $ toBinary n
        _ -> ""
    toBinary 0 = "0"
    toBinary n = toBinary (n `div` 2) ++ show (n `mod` 2)
    pad len s = replicate (len - length s) '0' ++ s

data Packet = Literal Int Int | Operator Int Int [Packet] deriving Show

parsePacket :: String -> (Packet, String)
parsePacket s = 
    let version = binToInt $ take 3 s
        typeId = binToInt $ take 3 $ drop 3 s
        rest = drop 6 s
    in if typeId == 4
       then parseLiteral version rest
       else parseOperator version typeId rest

binToInt :: String -> Int
binToInt = foldl (\acc c -> acc * 2 + if c == '1' then 1 else 0) 0

parseLiteral :: Int -> String -> (Packet, String)
parseLiteral version s = (Literal version value, rest)
  where
    (groups, rest) = readLiteralGroups s
    value = binToInt groups

readLiteralGroups :: String -> (String, String)
readLiteralGroups (cont:a:b:c:d:rest)
    | cont == '1' = let (more, rest') = readLiteralGroups rest
                    in (a:b:c:d:more, rest')
    | otherwise = ([a,b,c,d], rest)

parseOperator :: Int -> Int -> String -> (Packet, String)
parseOperator version typeId (lengthTypeId:rest)
    | lengthTypeId == '0' = 
        let totalLength = binToInt $ take 15 rest
            subPacketsStr = take totalLength $ drop 15 rest
            subPackets = parseSubPackets subPacketsStr
            remaining = drop (15 + totalLength) rest
        in (Operator version typeId subPackets, remaining)
    | otherwise =
        let numPackets = binToInt $ take 11 rest
            (subPackets, remaining) = parseNPackets numPackets (drop 11 rest)
        in (Operator version typeId subPackets, remaining)

parseSubPackets :: String -> [Packet]
parseSubPackets s | length s < 6 = []
                  | otherwise = let (p, rest) = parsePacket s
                                in p : parseSubPackets rest

parseNPackets :: Int -> String -> ([Packet], String)
parseNPackets 0 s = ([], s)
parseNPackets n s = let (p, rest) = parsePacket s
                        (ps, rest') = parseNPackets (n-1) rest
                    in (p:ps, rest')

sumVersions :: Packet -> Int
sumVersions (Literal v _) = v
sumVersions (Operator v _ subs) = v + sum (map sumVersions subs)

part1 :: Int
part1 = sumVersions packet
  where (packet, _) = parsePacket $ hexToBin input

evalPacket :: Packet -> Int
evalPacket (Literal _ v) = v
evalPacket (Operator _ t subs) = 
    let vals = map evalPacket subs
    in case t of
        0 -> sum vals
        1 -> product vals
        2 -> minimum vals
        3 -> maximum vals
        5 -> if vals !! 0 > vals !! 1 then 1 else 0
        6 -> if vals !! 0 < vals !! 1 then 1 else 0
        7 -> if vals !! 0 == vals !! 1 then 1 else 0

part2 :: Int
part2 = evalPacket packet
  where (packet, _) = parsePacket $ hexToBin input
