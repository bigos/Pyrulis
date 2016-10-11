data Price = Price Integer deriving (Eq, Show)

data Manufacturer = Mini | Mazda | Tata deriving (Eq, Show)

data Airline = PapuAir | CatapultsR'Us | TakeYourChancesUnited deriving (Eq, Show)

data Vehicle = Car Manufacturer Price
             | Plane Airline
             deriving (Eq, Show)

myCar = Car Mini (Price 14000)
urCar = Car Mazda (Price 20000)
clownCar = Car Tata (Price 7000)
doge = Plane PapuAir


isCar :: Vehicle -> Bool
isCar c = c == myCar || c == urCar || c == clownCar


isPlane :: Vehicle -> Bool
isPlane d = d == doge

areCars :: [Vehicle] -> [Bool]
areCars av = map isCar av

getManu :: Vehicle -> Manufacturer
getManu (Car m _) = m
