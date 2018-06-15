import System.IO
import Data.Char
import Data.List

main :: IO ()
main = do
    contents <- readFile "doors.txt"
    let interpreted = shape contents
    mapM_ command interpreted
    --command interpreted

shape :: String -> [(String, String)]
shape = map (interpreter) . lines

interpreter :: String -> (String, String)
interpreter s@(h:t)
    | h == '#' = ("instuction", t)
    | h == '@' = ("choices", t)
    | otherwise = ("text", s)

command :: (String, String) -> IO ()
command t@(c, b)
    | c == "instruction" = putStr $ b ++ ": "
    | c == "text" = putStrLn b
    | c == "choices" = do 
        answer <- getLine
        readAns $ evaluate answer b    
    | otherwise = putStrLn "Not what you expected ! error please review your program"

evaluate :: String -> String -> String
evaluate a b = foldl (\acc x -> if a == head x then tail x else acc) "1" ans
    where ans = answers b

answers :: String -> [[String]]
answers = map (splitOn "->") . splitOn ", "

readAns :: String -> IO ()
readAns s = putStrLn s

-- use marker ", " to build a list of choices -> use marker "->" to make a tupple choice target  
    -- [
    --     ("instuction","1"),
    --     ("text","Your are in a donjon and two doors or in front of you."),
    --     ("text","The firast is blue with a saphyr in the center."),
    --     ("text","The second is yellow with a qurtz in the center."),
    --     ("text","Which one will you pick ?"),
    --     ("choices"," 1 -> 2, 2 -> 3"),
    --     ("instuction","2"),
    --     ("text","You picked the blue door, you are rich! A treasure was waiting for you on the other side!"),
    --     ("instuction","3"),
    --     ("text","You picked the Yellow one, you are in a library. All the knowledge of the world seems to be kept here !")
    -- ]

-- Test IO functionality of main and read/write from/to files
-- test :: IO()
-- test = do
--     putStrLn "Hello and welcome to IF reader"
--     putStr "What is your name ? "
--     name <- getLine
--     putStrLn $ "Nice to meet you " ++ name ++ " !"

--     loud <- readFile "Iamthenight.txt"
--     putStr $ shape loud

--     putStrLn "\nHu-hum... I mean :\n"

--     handle <- openFile "H:/Code/Haskell/IFReaderProject/Iamthenight.txt" ReadMode
--     contents <- hGetContents handle
--     putStrLn contents
--     hClose handle
        
--     putStr "What would you like to play ? "
--     game <- getLine
--     putStrLn $ "I do not have \"" ++ game ++ "\" ready yet. But I might consider building it..."
--     putStrLn "I am afraid that this is all that I have programed so far, so I have to let the program end."
--     putStrLn "See you in the next version."