applyTimes 0 f b = b
applyTimes n f b = f . applyTimes (n-1) f $ b

applyN 0 f b = b
applyN n f b = applyN (n-1) f (f b)
