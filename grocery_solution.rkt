#lang scheme
;2016400378

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


;Case 1
(define (catchLine list entity) ;this function reads the given list of data line by line
  (if (null? list)
      null
      (if (eq? entity (caar list))
             (car list)
             (catchLine (cdr list) entity)
      )
  )
)
(define (sayNull table anything);I used this function if nothing compares with our search keyword
      (or  (catchLine table anything) null)
)
(define (TRANSPORTATION-COST farmer);It receives lines from catchline and find the wanted section
  (if (eq? null (sayNull FARMS farmer))
      0
      (list-ref (catchLine FARMS farmer) 1)
  )
)

;Case 2
(define (AVAILABLE-CROPS farmer);It receives lines from catchline and find the wanted section
  (if (eq? null (sayNull FARMS farmer))
      null
      (list-ref (catchLine FARMS farmer) 2)
  )
)

;Case 3
(define (INTERESTED-CROPS farmer);It receives lines from catchline and find the wanted section
  (if (eq? null (sayNull CUSTOMERS farmer))
      null
      (list-ref (catchLine CUSTOMERS farmer) 2)
  )
)
;Case 4
(define (CONTRACT-FARMS farmer);It receives lines from catchline and find the wanted section
  (if (eq? null (sayNull CUSTOMERS farmer))
      null
      (list-ref (catchLine CUSTOMERS farmer) 1)
  )
)
;Case5
(define (SUB-LIST list city whichSection);This function finds the wanted list in the line and controls is that line contains or not if it is then lists all matched results (farmers)
  (if (empty? list)
      null
      (if (memq city (list-ref(car list) whichSection))
          (cons (car(car list)) (SUB-LIST (cdr list) city whichSection))
          (SUB-LIST (cdr list) city whichSection))))

(define (CONTRACT-WITH-FARM farmer)
      (SUB-LIST CUSTOMERS farmer 1))
;Case6
(define (INTERESTED-IN-CROP crop);This function finds the wanted list in the line and controls is that line contains or not if it is then lists all matched results (farmers)
      (SUB-LIST CUSTOMERS crop 2))
;Case7
(define (MAKE-LIST list city whichSection);This function lists all prices of a crop and return the master
  (if (empty? list)
      null
      (if (eq? city (caar list))
          (cons (caddr(car list)) (MAKE-LIST (cdr list) city whichSection))
          (MAKE-LIST (cdr list) city whichSection))))
(define (MIN-SALE-PRICE crop);This function finds the min of the returned list
  (list-min (MAKE-LIST CROPS crop 2))
)

(define (list-min list);This function is to find minimum element of the given list
    (if (empty? list)
        0
        (cond ((null? (cdr list)) (car list))
          ((< (car list) (list-min (cdr list))) (car list))
          (else (list-min (cdr list))))
    )
)
;Case8
(define (SCOPE list min max);This function lists all crops whose price is between min and max price
  (if (empty? list)
      null
      (if (<= min (caddr(car list)))
          (if (>= max (caddr(car list)))
              (cons (caar list) (SCOPE (cdr list) min max))
              (SCOPE (cdr list) min max)
          )
          (SCOPE (cdr list) min max)
      )
  )
)
(define (CROPS-BETWEEN min max)
  (SCOPE CROPS min max)
)
;Case9
(define (LABEL-PRICE list crop farmer);This function calculate the price without transportation
  (if (null? list)
      0
  (if (eq? crop (caar list))
      (if (eq? farmer (cadar list))
          (caddar list)
          (LABEL-PRICE (cdr list) crop farmer)
      )
      (LABEL-PRICE (cdr list) crop farmer)
  )
  )
)
(define (BUY-PRICE person crop)
  (if (memq crop (INTERESTED-CROPS person))
      (PRICE-RECURSIVE (CONTRACT-FARMS person) crop)
      +inf.0
  )
)
(define (PRICE-RECURSIVE list crop);This function calculate min sum of Transportation and Label price for given crop
  (if (null? list)
      +inf.0
  (if (memq crop (AVAILABLE-CROPS (car list)))
       (exact-round (min (+ (TRANSPORTATION-COST (car list)) (LABEL-PRICE CROPS crop (car list))) (PRICE-RECURSIVE (cdr list) crop)))
       (PRICE-RECURSIVE (cdr list) crop)
  )
  )
)
;Case10
(define (TOTAL-PRICE person);This function uses BUY-PRICE function and finds the minimum price that given person can buy all crops that the person can buy.
  (TOTAL-PRICE-RECURSIVE (INTERESTED-CROPS person) person)
)
(define (TOTAL-PRICE-RECURSIVE list person)
  (if (null? list)
      0
  (+ (BUY-PRICE person (car list)) (TOTAL-PRICE-RECURSIVE (cdr list) person))
  )
)