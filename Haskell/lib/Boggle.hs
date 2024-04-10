module Boggle (boggle) where

import qualified Data.Map.Strict as Map
import qualified Data.Set as Set
import Data.List (foldl')

type BoardPosition  = (Int, Int)
type WordDictionary = Map.Map String Bool
type VisitedPositions = Map.Map BoardPosition Bool 
type DiscoveredWords = Map.Map String [BoardPosition]

createWordDictionary :: [String] -> WordDictionary
createWordDictionary = foldl' (\dict word -> foldl' (\t i -> Map.insert (take i word) True t) dict [1..length word]) Map.empty

getBoardPositions :: [String] -> [BoardPosition]
getBoardPositions  brd = [ (row,col) | row <- [0..numRows-1], col <- [0..numCols-1] ]
  where (numRows,numCols) = (length  brd, length $ head  brd) 

boggle :: [String] -> [String] -> [(String, [BoardPosition])]
boggle board wordList = Map.toList $ foldl' searchWords Map.empty (getBoardPositions board)
  where
    wordSet = Set.fromList wordList
    moveDirections = [(-1,-1),(-1,0), (-1,1),(0,-1),(0,1),(1,-1),(1,0),(1,1)]
    wordDictionary = createWordDictionary wordList
    searchWords :: DiscoveredWords -> BoardPosition -> DiscoveredWords
    searchWords found pos = Map.union found $ depthFirstSearch board wordSet wordDictionary pos moveDirections "" Map.empty []


isOutOfBounds :: BoardPosition -> [String] -> Bool
isOutOfBounds (rowIndex, colIndex) gameBoard  = rowIndex < 0 || colIndex < 0 || rowIndex >= length gameBoard || colIndex >= length (head gameBoard)

isPositionVisited :: BoardPosition -> VisitedPositions -> Bool
isPositionVisited pos seen = Map.member pos seen

updateVisitedPositions :: BoardPosition -> VisitedPositions -> VisitedPositions
updateVisitedPositions pos seen = Map.insert pos True seen


getNextWord :: BoardPosition -> String -> [String] -> String 
getNextWord (rowIndex, colIndex) currentWord gameBoard = currentWord ++ [gameBoard  !! rowIndex !! colIndex]  


getNextPath :: BoardPosition -> [BoardPosition] -> [BoardPosition]
getNextPath pos path = pos : path 


discoverWordsFromPosition :: [String] -> Set.Set String -> WordDictionary -> BoardPosition -> [BoardPosition] -> String -> VisitedPositions -> [BoardPosition] -> BoardPosition -> DiscoveredWords
discoverWordsFromPosition  gameBoard lexicon trie pos moveOptions currentWord seen path move =
  let newPos = (fst pos + fst move, snd pos + snd move)
  in  depthFirstSearch gameBoard lexicon trie newPos moveOptions  currentWord  seen path 


processCurrentWord :: String -> Set.Set String -> DiscoveredWords -> WordDictionary -> [BoardPosition] -> DiscoveredWords
processCurrentWord nextWord lexicon discoveredWords trie nextPath = 
  case Map.lookup nextWord trie of
    Nothing -> Map.empty
    _ -> if Set.member nextWord lexicon
      then Map.insert nextWord (reverse nextPath) discoveredWords
      else discoveredWords

depthFirstSearch :: [String] -> Set.Set String -> WordDictionary -> BoardPosition -> [BoardPosition] -> String -> VisitedPositions -> [BoardPosition] -> DiscoveredWords
depthFirstSearch gameBoard lexicon trie pos moveOptions currentWord seen path =
  if isOutOfBounds pos gameBoard || isPositionVisited pos seen
  then Map.empty
  else 
    let updatedVisited = updateVisitedPositions pos seen
        nextWord' = getNextWord pos currentWord gameBoard
        nextPath' =  getNextPath pos path
        discoveredWords = foldl' (\acc move -> Map.union acc $ discoverWordsFromPosition gameBoard lexicon trie pos moveOptions nextWord' updatedVisited nextPath' move) Map.empty moveOptions
    in processCurrentWord nextWord' lexicon discoveredWords trie nextPath' 