import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

input :: [String]
input = unsafePerformIO $ readInputLines 2015 15

data Ingredient = Ingredient Int Int Int Int Int

parseIngredient :: String -> Ingredient
parseIngredient line = Ingredient cap dur flav tex cal
  where
    ws = words line
    cap = read $ init $ ws !! 2
    dur = read $ init $ ws !! 4
    flav = read $ init $ ws !! 6
    tex = read $ init $ ws !! 8
    cal = read $ ws !! 10

score :: [Ingredient] -> [Int] -> Int
score ingr amts = product $ map (max 0) [sum [a * v | (a, Ingredient v _ _ _ _) <- zip amts ingr],
                                          sum [a * v | (a, Ingredient _ v _ _ _) <- zip amts ingr],
                                          sum [a * v | (a, Ingredient _ _ v _ _) <- zip amts ingr],
                                          sum [a * v | (a, Ingredient _ _ _ v _) <- zip amts ingr]]

part1 :: Int
part1 = maximum [score ingrs combo | combo <- combos 4 100]
  where
    ingrs = map parseIngredient input
    combos 1 n = [[n]]
    combos k n = [x:rest | x <- [0..n], rest <- combos (k-1) (n-x)]

part2 :: Int
part2 = maximum [score ingrs combo | combo <- combos 4 100, calories combo == 500]
  where
    ingrs = map parseIngredient input
    calories amts = sum [a * v | (a, Ingredient _ _ _ _ v) <- zip amts ingrs]
    combos 1 n = [[n]]
    combos k n = [x:rest | x <- [0..n], rest <- combos (k-1) (n-x)]
