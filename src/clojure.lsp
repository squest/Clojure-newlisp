;; Just the renaming parts

(define range sequence)
(define remove clean)
(define def define)
(define defmacro define-macro)

;; Just playing cool with defn, but the thing is it cannot have a
;; docstring, but still cool nonetheless ;)
(defmacro (defn fname binding)
  (eval (append '(define)
		(list (cons (expand fname) (expand binding)))
		(args))))

;; The macros and functions

(define-macro (f%)
  (eval (append '(fn) '((%1 %2 %3 %4 %5 %6)) (args))))

(define (conj)
  (append (first (args)) (rest (args))))

(define (reduce f e)
  (define (iter res col)
    (if col
	(iter (f res (first col)) (rest col))
	res))
  (iter e (first (args))))

(define-macro (->>)
  (when (args)
    (if (rest (args))
	(letn (res (reduce (fn (a b)
			     (reverse (cons a (reverse b))))
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
  (if col
      '()
      (let (a (first col))
	(if (pred a)
	    (cons a (take-while pred (rest col)))
	    '()))))

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

(define (butlast col) (reverse (rest (reverse col))))

(define-macro (when-let)
  (setf (eval (first (args 0))) (eval ((args 0) 1)))
  (if (eval (first (args 0)))
    (if (= 1 (length (rest (args))))
	(eval (last (args)))
	(begin
	  (dolist (c (butlast (rest (args))))
	    (eval c))
	  (eval (last (args)))))
    nil))