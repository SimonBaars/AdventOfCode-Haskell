import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import Data.List (find, sort, intercalate, (\\))
import qualified Data.Map.Strict as Map
import qualified Data.Set as Set

-- Day 21: Allergen Assessment
-- Map allergens to ingredients using constraint solving

type Food = ([String], [String])  -- (ingredients, allergens)

input :: [Food]
input = unsafePerformIO $ map parseFood <$> readInputLines 2020 21

parseFood :: String -> Food
parseFood line = (ingredients, allergens)
  where
    parts = words line
    (ingWords, allergenPart) = break (== "(contains") parts
    ingredients = ingWords
    allergens = if null allergenPart
                then []
                else map (filter (`notElem` ",)")) $ tail allergenPart

-- Part 1: Count appearances of safe ingredients
part1 :: Int
part1 = length [i | food <- input, i <- fst food, i `elem` safeIngredients]
  where
    safeIngredients = allIngredients \\ allergenicIngredients
    allIngredients = Set.toList $ Set.unions [Set.fromList (fst f) | f <- input]
    allergenicIngredients = Set.toList $ Set.unions $ Map.elems possibleIngredients
    possibleIngredients = getAllergenPossibilities input

getAllergenPossibilities :: [Food] -> Map.Map String (Set.Set String)
getAllergenPossibilities foods = foldl updateMap Map.empty foods
  where
    updateMap m (ingredients, allergens) = foldl (updateAllergen ingredients) m allergens
    updateAllergen ingredients m allergen = 
        Map.insertWith Set.intersection allergen (Set.fromList ingredients) m

-- Part 2: Find canonical dangerous ingredient list
part2 :: String
part2 = intercalate "," [snd p | p <- sort (Map.toList solved)]
  where
    possibilities = getAllergenPossibilities input
    solved = solveMappings possibilities

solveMappings :: Map.Map String (Set.Set String) -> Map.Map String String
solveMappings initial = go initial Map.empty
  where
    go remaining found
        | Map.null remaining = found
        | otherwise = case find (\(_, s) -> Set.size s == 1) (Map.toList remaining) of
            Just (allergen, ingredients) ->
                let ingredient = Set.findMin ingredients
                    found' = Map.insert allergen ingredient found
                    remaining' = Map.map (Set.delete ingredient) $ Map.delete allergen remaining
                in go remaining' found'
            Nothing -> found
