(require racket/list)
(define wiretriangle-save (make-hash))

(define (wiretriangle-build id)
    (hash-set! wiretriangle-save id (list 0 0 0))
)

(define (wiretriangle id cross)
    (letrec
        (
            (get-orig
                (lambda (a c)
                    (* a c)
                )
            )
            (draw-triangle
                (lambda ()
                    (draw-line (vector 0 1 0)       (vector -1 -0.5 0))
                    (draw-line (vector -1 -0.5 0) (vector 1 -0.5 0))
                    (draw-line (vector 1 -0.5 0)  (vector 0 1 0))
                )
            )
            (h-pos-x (first  (hash-ref wiretriangle-save id)))
            (h-pos-y (second (hash-ref wiretriangle-save id)))
            (h-pos-z (third  (hash-ref wiretriangle-save id)))
            (coeff-x (c "coeff-x" id))
            (coeff-y (c "coeff-y" id))
            (coeff-z (c "coeff-z" id))
            (coeff-g-x 1)
            (coeff-g-y 1)
            (coeff-g-z 1)
            (pos-x (get-orig h-pos-x coeff-x))
            (pos-y (get-orig h-pos-y coeff-y))
            (pos-z (get-orig h-pos-z coeff-z))
            (pos (vector pos-x pos-y pos-z))
            (draw-wiretriangle
                (lambda (i)
                    (with-state
                        (rotate (vmul (vector (* (c "r-x-time" id #:coeff 50) (time)) (* (c "r-y-time" id #:coeff 50) (time)) 0) (c "r-time" id)))
                        (translate (vector 0 0 (c "offset-y" id #:coeff -10)))
                        (rotate (vmul (vector (* (gl i) (c "r-x" id)) (* (gl i)  (c "r-y" id)) 0) 360))
                        (translate (vmul (vector (* (gl i) 0.1) (* (gl i) 1.5) 0) 1))
                        (scale (vmul (vector (gl i) (* (gl i) 2) 1) (c "scale" id #:coeff 10)))
                        (draw-triangle)
                    )
                    (unless (zero? i)
                        (draw-wiretriangle (- i 1))
                    )
                )
            )
        )
        (draw-wiretriangle (get-num-frequency-bins))
        (when (beat-catch "tri" "beat-1" #:beat (list 4))
            (when (zero? (c "beat" id))
                (hash-set! wiretriangle-save id (list (* (* 4 (- 0.5 (flxrnd))) 2) (* (* 3 (- 0.5 (flxrnd))) 2) 0))
            )
        )
    )
)

(define (wiretriangle-destroy id)
 1
)
