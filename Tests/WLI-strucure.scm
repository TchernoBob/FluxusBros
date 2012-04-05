(require scheme/math)
(clear)
(hint-none)
(hint-solid)
;(ortho)
;(set-ortho-zoom -10)
(clip 1 10000)
(define c1 (build-cube))
(define c2 (build-cube))
(define c3 (build-cube))
(define t 0.5)
(define -t (* -1 t))
(define s 4)
(define a 40)
(define b 37)

(with-primitive c1
    (rotate (vector a 0 0))
    (rotate (vector 0 b 0))
    (scale s)
    (translate (vector t t 0))
)
(with-primitive c2
    (rotate (vector a 0 0))
    (rotate (vector 0 b 0))
    (scale s)
    (translate (vector -t -t 0))
)
(with-primitive c3
    (rotate (vector a 0 0))
    (rotate (vector 0 b 0))
    (scale s)
    (translate (vector t -t (* 2 t)))
)