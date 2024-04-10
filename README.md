# Boggle-Solver
Boggle solver in Elixir,Haskell,and Rust
You are given an N*N grid of letters, and your task is to find connected chains of letters that form legal words. The basic rules of the game can be found at this [link](https://en.wikipedia.org/wiki/Boggle)

The first input to your program will be an N*N grid of letters. The second input will be a list
of legal words. Your task is to search for unique, legal words in the letter grid according to
the rules of Boggle (see Wikipedia link above for more info):
- Each letter after the first must be a horizontal, vertical, or diagonal neighbor of the one
before it.
- No individual letter cube may be used more than once in a word.
Your program will return this list of words, along with the indexes of each letter. Type
details for inputs and output are language-specific and will be described below. The list of
words returned by your program will be validated, and assigned a score
| Word length | 1| 2 | 3 | 4| 5 | 6| 7 | 8+ |
|----------|----------|----------|----------|----------|----------|----------|----------|----------|
| Points | 1 | 2 | 4 | 6 | 9 | 12 | 16 | 20 |

# Variations from the official game
- Traditional Boggle has a minimum word length of 3, but for this project it will be 1.
- Word scoring also differs. See the table above.
- A traditional game of Boggle uses a 4x4 grid.
- The input to your program can be as small as 2x2 and grow arbitrarily large to 16x16.
- The input will always be square.

## Game Example #1
Below is a sample 4x4 board, as well as some (but not all!) words that are in it. Of course,
the words you can find depend also on the list of legal words passed in but assume for this
example that all standard English words are legal.

| i | s| u | o |
|----------|----------|----------|----------|
|o	|s|	v|	e|
|n|	e	|p|	a|
|n|	t	|s|	u|

**legal words**: is son spa sent vast issue so sap ape oven nice events us ten east nose save sonnet us ten east nose save sonnet

The words found in the board above would be scored as follows:
#### is, so, us, up = 8 points (2 each)
#### son, sap, ten, vet, spa, ape = 24 points (4 each)
#### east, nest, sent, oven, nose, tens, vast, nice, save = 54 points (6 each)
#### pause, issue = 18 points (9 each)
#### events, sonnet = 24 points (12 each)
#### session = 16 points (16 each)
#### 8 + 24 + 54 + 18 + 24 + 16 = 144 points total


## Game Example #2
Here is a 2x2 board, which is much simpler to solve. Immediately, we can eliminate all
words longer than 4 letters. Further, a brute force approach that simply generates and tests
every possible sequence of letters found in the game board is tractable. This is not the case
in the 4x4 example.

| e | a|
|----------|----------|
|s	|t|

**legal words**: as ate set eats seat at eat sat east sate
#### This solution scores 2*2 + 4*4 + 4*6 = 44 points total

# Elixir:
Input: The first argument, representing the game board, is a tuple of tuples whose elements
are strings. The second argument is a list of strings containing the legal words for that game.
For example, the 2x2 example would be: {{“e”, “a”}, {“s”, “t”}} and the legal
word list would be: [“word1”, “word2”, ... ] and so on.
Output: The output will be a map, which is Elixir’s dictionary equivalent:
https://hexdocs.pm/elixir/1.12/Map.html
Keys will be strings, and the values will be a list of coordinates. Each coordinate will be a
pair tuple. For example, a map containing only the word ‘seat’ would be represented as
follows: %{ “seat”=>[ {1, 0}, {0, 0}, {0, 1}, {1, 1} ] }

# Haskell:
Input: Haskell’s argument types differ a bit from Elixir’s. The board will be a list of Strings,
where each string represents a row. The legal word list will also be a list of strings.
Output: Your boggle function should return a list of tuples. Each tuple contains two
elements. The first element is a string (the word), and the second element is a list of pair
tuples, where each pair tuple contains the coordinates of the corresponding letter in the
string. The word ‘seat’ from the 2x2 board would be represented as follows:
[ (“seat”, [ (1,0), (0,0), (0,1), (1,1) ]) ]
Haskell also has a Map type that you may find useful, but you are not required to use it:
https://hackage.haskell.org/package/containers-0.4.0.0/docs/Data-Map.html

# Rust:
Input: The game board in Rust will be passed as a reference to an immutable array of string
slices – each slice is a row of the board. The legal word list will be passed as a reference to
an immutable Vector of Strings.
Output: Your boggle function will return a HashMap, whose keys are the words you’ve
found (String) and whose values are Vectors of pair tuples representing character
coordinates. Documentation for Vector and HashMap is below.
https://doc.rust-lang.org/std/vec/struct.Vec.html
https://doc.rust-lang.org/std/collections/struct.HashMap.html

mix test

cargo test

cabal test

