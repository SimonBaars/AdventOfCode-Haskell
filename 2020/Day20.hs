{-# LANGUAGE TupleSections #-}
import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)
import Data.List (isPrefixOf, transpose, intercalate)
import qualified Data.Map.Strict as Map
import Data.Maybe (fromJust, mapMaybe, listToMaybe)

type TileId = Int
type Tile = [[Char]]

input :: [(TileId, Tile)]
input = unsafePerformIO $ parseTiles <$> readInput 2020 20

parseTiles :: String -> [(TileId, Tile)]
parseTiles s = map parseTile $ filter (not . null . lines) $ splitOn "\n\n" s

parseTile :: String -> (TileId, Tile)
parseTile block = (tileId, tile)
  where
    (header:rows) = lines block
    tileId = read $ takeWhile (/= ':') $ drop 5 header
    tile = filter (not . null) rows

splitOn :: String -> String -> [String]
splitOn delim str = case breakOn delim str of
    (chunk, "") -> [chunk]
    (chunk, rest) -> chunk : splitOn delim (drop (length delim) rest)

breakOn :: String -> String -> (String, String)
breakOn needle haystack = go [] haystack
  where
    go acc [] = (reverse acc, "")
    go acc s@(c:cs)
        | needle `isPrefixOf` s = (reverse acc, s)
        | otherwise = go (c:acc) cs

-- Edges: top, right, bottom, left
topE, botE, leftE, rightE :: Tile -> String
topE = head
botE = last
leftE = map head
rightE = map last

rotate90 :: Tile -> Tile
rotate90 = map reverse . transpose

flipH :: Tile -> Tile
flipH = map reverse

orientations :: Tile -> [Tile]
orientations t =
  let rots = take 4 $ iterate rotate90 t
  in rots ++ map flipH rots

allOriented :: [(TileId, Tile)] -> [(TileId, Tile)]
allOriented = concatMap (\(i,t) -> map (i,) (orientations t))

edgeMatches :: String -> String -> Bool
edgeMatches a b = a == b

-- Part 1
edgesOf :: Tile -> [String]
edgesOf t = [topE t, rightE t, botE t, leftE t]

part1 :: Integer
part1 = product $ map (toInteger . fst) corners
  where
    tiles = input
    corners = filter isCorner tiles
    isCorner (tid, tile) =
      let other = concatMap (edgesOf . snd) [x | x <- tiles, fst x /= tid]
          unmatched = [e | e <- edgesOf tile, e `notElem` other, reverse e `notElem` other]
      in length unmatched == 2

-- Part 2: assemble then find sea monsters
n :: Int
n = round (sqrt (fromIntegral (length input) :: Double))

-- Build adjacency by normalized edge -> tile ids
norm :: String -> String
norm e = min e (reverse e)

assemble :: [[(TileId, Tile)]]
assemble = placeGrid
  where
    tiles = input
    -- Find a corner and orient it so unmatched edges are top & left
    cornerId = fst $ head $ filter isCorner tiles
      where
        isCorner (tid, tile) =
          let other = concatMap (edgesOf . snd) [x | x <- tiles, fst x /= tid]
              unmatched = [e | e <- edgesOf tile, e `notElem` other, reverse e `notElem` other]
          in length unmatched == 2
    cornerTile = fromJust $ lookup cornerId tiles
    orientedCorner = head
      [ o
      | o <- orientations cornerTile
      , let other = concatMap (edgesOf . snd) [x | x <- tiles, fst x /= cornerId]
      , topE o `notElem` other && reverse (topE o) `notElem` other
      , leftE o `notElem` other && reverse (leftE o) `notElem` other
      ]
    -- Remaining tiles by id
    pool0 = Map.fromList [(i, orientations t) | (i,t) <- tiles, i /= cornerId]

    findRight :: (TileId, Tile) -> Map.Map TileId [Tile] -> Maybe ((TileId, Tile), Map.Map TileId [Tile])
    findRight (_, cur) pool =
      listToMaybe
        [ ((tid, o), Map.delete tid pool)
        | (tid, orients) <- Map.toList pool
        , o <- orients
        , leftE o == rightE cur
        ]

    findBelow :: (TileId, Tile) -> Map.Map TileId [Tile] -> Maybe ((TileId, Tile), Map.Map TileId [Tile])
    findBelow (_, cur) pool =
      listToMaybe
        [ ((tid, o), Map.delete tid pool)
        | (tid, orients) <- Map.toList pool
        , o <- orients
        , topE o == botE cur
        ]

    buildRow :: (TileId, Tile) -> Map.Map TileId [Tile] -> Int -> ([ (TileId, Tile) ], Map.Map TileId [Tile])
    buildRow start pool cols =
      go [start] pool (cols - 1)
      where
        go acc p 0 = (reverse acc, p)
        go (prev:rest) p k =
          case findRight prev p of
            Just (nxt, p') -> go (nxt:prev:rest) p' (k-1)
            Nothing -> error "cannot extend row"

    placeGrid :: [[(TileId, Tile)]]
    placeGrid =
      let (row0, p0) = buildRow (cornerId, orientedCorner) pool0 n
          goRows rows pool 1 = reverse rows
          goRows (prevRow:rs) pool k =
            case findBelow (head prevRow) pool of
              Just (start, pool') ->
                let (row, pool'') = buildRow start pool' n
                in goRows (row:prevRow:rs) pool'' (k-1)
              Nothing -> error "cannot start next row"
      in goRows [row0] p0 n

stripBorder :: Tile -> Tile
stripBorder = map (init . tail) . init . tail

fullImage :: Tile
fullImage =
  let grid = map (map (stripBorder . snd)) assemble
      -- each cell is a small tile; stitch rows of tiles
      stitchRow :: [Tile] -> [String]
      stitchRow tiles =
        let h = length (head tiles)
        in [ concatMap (!! r) tiles | r <- [0..h-1] ]
  in concatMap stitchRow grid

monster :: [String]
monster =
  [ "                  # "
  , "#    ##    ##    ###"
  , " #  #  #  #  #  #   "
  ]

monsterOffsets :: [(Int, Int)]
monsterOffsets =
  [ (r, c)
  | (r, row) <- zip [0..] monster
  , (c, ch) <- zip [0..] row
  , ch == '#'
  ]

monsterH, monsterW :: Int
monsterH = length monster
monsterW = length (head monster)

countMonsters :: Tile -> Int
countMonsters img =
  let h = length img
      w = length (head img)
  in length
    [ (r, c)
    | r <- [0 .. h - monsterH]
    , c <- [0 .. w - monsterW]
    , all (\(dr,dc) -> (img !! (r+dr)) !! (c+dc) == '#') monsterOffsets
    ]

roughness :: Tile -> Int
roughness img =
  let hashes = length [ () | row <- img, ch <- row, ch == '#' ]
      m = maximum [ countMonsters o | o <- orientations img ]
  in hashes - m * length monsterOffsets

part2 :: Int
part2 = roughness fullImage
