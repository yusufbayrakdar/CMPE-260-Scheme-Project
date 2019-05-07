#lang scheme

(define FARMS '( 
(farmA 100 (apricot apple blueberry))
(farmB 90 (broccoli carrot grape))
(farmC 75 (corn grape lemon))
(farmD 75 ()) ))

(define CUSTOMERS '( 
(john (farmA farmC) (apricot lemon))
(james (farmB farmC) (grape corn))
(arya (farmB farmD) (grape broccoli))
(elenor () ())))

(define CROPS '( 
(apricot farmA 10)
(apple farmA 12)
(blueberry farmA 15)
(broccoli farmB 8)
(carrot farmB 5)
(grape farmB 10)
(corn farmC 9)
(grape farmC 12)
(lemon farmC 10)))
