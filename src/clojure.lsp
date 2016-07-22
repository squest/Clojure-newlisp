;; Just the renaming parts

(define range sequence)
(define remove clean)
(define def define)
(define defmacro define-macro)
(define !inc (fn (x) (+ 1 x)))
(define !dec (fn (x) (- x 1)))
(define pos? (fn (x) (> x 0)))
(define neg? (fn (x) (< x 0)))
(define str string)
(define concat append)
(define partial curry)
(define doseq dolist)
(define !count length)
(define every? for-all)
(define shuffle randomize)

(define (sort-by f compf col)
  (sort col (fn (a b) (compf (f a) (f b)))))

(define (comp)
  (define (comp-helper col x)
    (define (iter res col)
      (if col
	  (iter ((first col) res) (rest col))
	  res))
    (iter x col))
  (letex (resi (reverse (args)))
    (partial comp-helper 'resi)))

(define-macro (defn fname binding)
  (eval (append '(define)
		(list (cons (expand fname) (expand binding)))
		(args))))


;; Just playing cool with defn, but the thing is it cannot have a
;; docstring, but still cool nonetheless ;)
(define-macro (f%)
  (eval (append '(fn) '((%1 %2 %3 %4 %5 %6)) (args))))

;; This one let's you to use (f% (* %1 %2)) as anonymous function, but
;; sadly you cannot use % since it's a reserved symbol in newlisp
(define (juxt)
  (define (juxt-helper cols x)
    (map (fn (f) (f x)) cols))
  (letex (res (args))
    (curry juxt-helper 'res)))

(define (conj)
  (append (first (args)) (rest (args))))

(define (iterate f pred init)
  (define (iter cur res)
    (if (pred cur)
	(iter (f cur) (conj res cur))
	res))
  (iter init '()))

;; ugly iterate, can't implement laziness yet
;; need a pred function to keep the iteration going when (pred value)
;; is true
(define (take n cols)
  (define (iter i res col)
    (if col
	(if (>= i n)
	    res
	    (iter (!inc i) (conj res (first col)) (rest col)))
	res))
  (iter 0 '() cols))

(define (drop n cols)
  (if cols
      (if (<= n 0)
	  cols
	  (drop (!dec n) (rest cols)))
      cols))

(define (reduce f e)
  (define (iter res col)
    (if col
	(iter (f res (first col)) (rest col))
	res))
  (iter e (first (args))))

(define-macro (->>)
  (when (args)
    (if (rest (args))
	(letn (res (reduce (fn (a b) (conj b a))
			   (first (args))
			   (rest (args))))
	  (eval res))
	(eval (first (args))))))

(define-macro (->)
  (when (args)
    (if (rest (args))
	(letn (res (reduce (fn (a b)
			     (append (list (first b))
				     (list a)
				     (rest b)))
			   (first (args))
			   (rest (args))))
	  (eval res))
	(eval (first (args))))))

(define (keep f col)
  (->> (map f col)
    (clean nil?)))

(define (take-last n col)
  (drop (- (length col) n) col))

(define (drop-last n col)
  (take (- (length col) n) col))

(define (take-while pred col)
  (define (iter res col)
    (if col
	(let (r (first col))
	  (if (pred r)
	      (iter (conj res r) (rest col))
	      res))
	res))
  (iter '() col))

(define (drop-while pred col)
  (if-not col
	  col
	  (if (pred (first col))
	      (drop-while pred (rest col))
	      (rest col))))

(define-macro (if-let)
  (setf (eval (first (args 0))) (eval ((args 0) 1)))
  (if (eval (first (args 0)))
      (eval (args 1))
      (eval (args 2))))

(define (butlast col)
  (drop-last 1 col))

(define-macro (when-let)
  (setf (eval (first (args 0))) (eval ((args 0) 1)))
  (if (eval (first (args 0)))
      (if (= 1 (length (rest (args))))
	  (eval (last (args)))
	  (eval (apply begin (rest (args)))))
      nil))

(define-macro (when-not)
  (eval (concat (list 'when (eval (not (first (args)))))
		(rest (args)))))

(define-macro (!apply)
  (eval (concat (butlast (args)) (eval (last (args))))))
