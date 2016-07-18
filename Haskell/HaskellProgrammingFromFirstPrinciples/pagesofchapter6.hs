-- chapter 6 scribbling



myWords' "" sep acc = acc
myWords' s sep acc = myWords' (dropWhile (== sep) $ dropWhile (/= sep) s) sep (acc ++ [ takeWhile (/= sep) s])

myWords s = myWords' s ' ' []
myLines s = myWords' s '\n' []
