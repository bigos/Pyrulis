-- learn.hs - p 23
module Learn where
-- First, we declare the name of our module so
-- it can be imported by name in a project.
-- We won't be doing a project of this size
-- for a while yet.

z = 7

x = y^2

waxOn = x*5
  where x = y*y

-- waxOff x = (x * 3) ^ 2
waxOff x = (x ^ 2) * 9

triple x = x*3

y = z+8
