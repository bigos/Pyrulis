stops = "pbtdkg"
vovels = "aeiou"

nouns = ["cat", "dog", "mouse"]
verbs = ["saw", "chased"]

firstTup (a,_,_) = a

combinations stops vovels = [(i,j,k) | i <- stops, j <-vovels, k <- stops]

res s v = filter (\x -> firstTup x == 'p') $ combinations s v
