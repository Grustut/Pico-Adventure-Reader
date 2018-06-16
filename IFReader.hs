import Data.List

data Input = Input String deriving (Show, Read)
data Action = Action String deriving (Show, Read)
data Choices = Choices [(Input, Action)] deriving (Show, Read)
data Context = Context String deriving (Show)
data Situation = Situation Int (Context, Choices) deriving (Show)
data Game = Game [Situation] deriving (Show)

main = do
    putStrLn "Welcome to Interactive Fiction Reader\nPlease type your Game file name : "
    gameName <- getLine 
    content <- readFile gameName
    let emptyGame = Game []
        game = createGame content emptyGame 
    readGame game 0
    putStrLn "Thanks !"
    

createGame :: String -> Game -> Game 
createGame (x:xs) g@(Game si)
    | xs == [] || head xs == '$' = g'
    | x == '#' = createSituation xs g
    | otherwise = error "The game file does not start with first Situation declaration or the character #."
        where g' = Game (reverse si)

createSituation :: String -> Game -> Game
createSituation xs g@(Game si) = createGame rest $ Game sis
    where   sis         = (Situation (read (fst nameRest) :: Int) (Context (trim $ fst contextRest), choices)):si
            nameRest    = span (/= '\n') xs
            contextRest = span (\x -> x /= '@') $ snd nameRest
            choicesRest = span (\x -> x /= '#') $ snd contextRest
            choices     = createChoices $ fst choicesRest
            rest        = if snd choicesRest /= "" then snd choicesRest else " "

createChoices :: String -> Choices
createChoices (x:xs) = createChoices' (x:xs) []
    where createChoices' (x:xs) cs
            | x == '\n' = read (cs ++ "\")]") :: Choices
            | x == '@'  = createChoices' xs (cs ++ "Choices [( Input \"")
            | x == '>'  = createChoices' xs (cs ++ "\", Action \"")
            | x == ','  = createChoices' xs (cs ++ "\"), (Input \"")
            | x == ' '  = createChoices' xs cs
            | otherwise = createChoices' xs (cs ++ x:[])

trim :: String -> String
trim ls
    | before == ' ' || before == '\n' = trim $ tail ls
    | after  == ' ' || after  == '\n' = trim $ init ls
    | otherwise  = ls
    where before = head ls
          after  = last ls

readGame :: Game -> Int -> IO ()
readGame g@(Game xs) s = readSituation g $ xs !! s

readSituation :: Game -> Situation -> IO ()
readSituation g s@(Situation _ (co , ch)) = do
    putStrLn "\n\n"
    putStrLn $ cont co
    let theEnd = isItTheEnd ch
    if theEnd then putStrLn "Game Over" else do
        answer <- getLine
        let result = evalChoice answer ch 
        if result == False 
            then putStrLn "It is not one of the possible answers"
            else readGame g $ (read $ doAction answer ch) - 1
    where cont co@(Context s) = s 

evalChoice :: String -> Choices -> Bool
evalChoice a c@(Choices xs) = any (== True) $ map (\x@(Input y, Action z) -> a == y) xs

doAction :: String -> Choices -> String
doAction a c@(Choices xs) =  foldl (\acc x@(Input y, Action z) -> if a==y then z else acc) "" xs

isItTheEnd :: Choices -> Bool
isItTheEnd ch@(Choices xs)
        | any (\x@(Input y, Action z) -> y == "Enter" && z == "End") xs = True
        | otherwise = False