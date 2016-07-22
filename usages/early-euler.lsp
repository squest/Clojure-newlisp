(load "../src/clojure.lsp")

;; Euler no 10

(define (sieve lim)
  (setf not-primes (array (!inc lim)))
  (setf i 3)
  (for (i 3 (int (sqrt lim)) 2)
    (when (not (not-primes i))
      (for (j (* i i) lim (* 2 i))
	(setf (not-primes j) true))))
  (cons 2 (filter (f% (not (not-primes %1))) (range 3 lim 2))))

(define (sum-sieve lim)
  (setf not-primes (array (!inc lim)))
  (setf i 3)
  (setf llim (int (sqrt lim)))
  (setf res 2)
  (for (i 3 lim 2)
    (if (<= i llim)
	(when (not (not-primes i))
	  (for (j (* i i) lim (* 2 i))
	    (setf (not-primes j) true))
	  (setf res (+ res i)))
	(when (not (not-primes i))
	  (setf res (+ res i)))))
  (println res))


