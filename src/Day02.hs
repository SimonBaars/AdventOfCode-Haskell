module Day02 (part1, part2) where

import Data.List (sort)

data Move = Rock | Paper | Scissors
  deriving (Eq, Enum)

parseLine :: String -> (Move, Char)
parseLine [a, _, b] = (opp, b)
  where
    opp = case a of
      'A' -> Rock
      'B' -> Paper
      'C' -> Scissors
      _ -> error "Day02: bad opponent"
parseLine _ = error "Day02: bad line"

scoreRound :: Move -> Move -> Int
scoreRound opp you =
  outcome + shape
  where
    shape = 1 + fromEnum you
    outcome = case (you, opp) of
      (Rock, Scissors) -> 6
      (Paper, Rock) -> 6
      (Scissors, Paper) -> 6
      (x, y) | x == y -> 3
      _ -> 0

youFromOutcome :: Move -> Char -> Move
youFromOutcome opp desired =
  case desired of
    'X' -> lose
    'Y' -> draw
    'Z' -> win
    _ -> error "Day02: bad outcome"
  where
    lose = case opp of
      Rock -> Scissors
      Paper -> Rock
      Scissors -> Paper
    draw = opp
    win = case opp of
      Rock -> Paper
      Paper -> Scissors
      Scissors -> Rock

part1 :: String -> Int
part1 =
  sum
    . map
      ( \(opp, b) ->
          let you = case b of
                'X' -> Rock
                'Y' -> Paper
                'Z' -> Scissors
                _ -> error "Day02: bad you"
           in scoreRound opp you
      )
    . map parseLine
    . lines

part2 :: String -> Int
part2 =
  sum
    . map
      ( \(opp, b) ->
          let you = youFromOutcome opp b
           in scoreRound opp you
      )
    . map parseLine
    . lines
