use std::collections::{HashMap, HashSet};

struct Trie {
    children: HashMap<char, Trie>,
    end_of_word: bool,
}

impl Trie {
    fn new() -> Self {
        Trie {
            children: HashMap::new(),
            end_of_word: false,
        }
    }

    fn insert(&mut self, word: &str) {
        let mut node = self;
        for ch in word.chars() {
            node = node.children.entry(ch).or_insert(Trie::new());
        }
        node.end_of_word = true;
    }

    fn search(&self, word: &str) -> bool {
        let mut node = self;
        for ch in word.chars() {
            if let Some(n) = node.children.get(&ch) {
                node = n;
            } else {
                return false;
            }
        }
        node.end_of_word
    }

    fn starts_with(&self, prefix: &str) -> bool {
        let mut node = self;
        for ch in prefix.chars() {
            if let Some(n) = node.children.get(&ch) {
                node = n;
            } else {
                return false;
            }
        }
        true
    }
}

fn boggle(board: &[&str], words: &[String]) -> HashMap<String, Vec<(u8, u8)>> {
    let mut found: HashMap<String, Vec<(u8, u8)>> = HashMap::new();
    let mut trie = Trie::new();
    for word in words {
        trie.insert(word);
    }
    let n = board.len();
    let directions = [(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)];

    for x in 0..n {
        for y in 0..n {
            dfs(
                board,
                &trie,
                (x as u8, y as u8),
                &directions,
                "".to_string(),
                &mut HashMap::new(),
                &mut Vec::new(),
                &mut found,
            );
        }
    }
    found
}

fn dfs(
    board: &[&str],
    trie: &Trie,
    (x, y): (u8, u8),
    directions: &[(i8, i8)],
    word: String,
    visited: &mut HashMap<(u8, u8), bool>,
    coords: &mut Vec<(u8, u8)>,
    found: &mut HashMap<String, Vec<(u8, u8)>>,
) {
    if x < board.len() as u8 && y < board[0].len() as u8 && !visited.contains_key(&(x, y)) {
        let new_word = format!("{}{}", word, board[x as usize].chars().nth(y as usize).unwrap());
        if trie.starts_with(&new_word) {
            visited.insert((x, y), true);
            coords.push((x, y));
            if trie.search(&new_word) {
                found.insert(new_word.clone(), coords.clone());
            }
            for dir in directions {
                dfs(
                    board,
                    trie,
                    ((x as i8 + dir.0) as u8, (y as i8 + dir.1) as u8),
                    directions,
                    new_word.clone(),
                    visited,
                    coords,
                    found,
                );
            }
            visited.remove(&(x, y));
            coords.pop();
        }
    }
}


#[cfg(test)]
#[path = "tests.rs"]
mod tests;