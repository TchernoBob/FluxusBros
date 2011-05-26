(define (mury id cross)
    (letrec
        (
        (make-line
            (lambda (n)
                (with-state
                    (translate (vector (* 0.6 n) 0 0))
                    (scale (vector 0.4 (gl n) 1))
                    (colour (vector (gl n) (c "g" id) (c "b" id)))
                    (draw-cube)
                )
                (unless (zero? n)
                    (if (positive? n)
                        (make-line (- n 1))
                        (make-line (+ n 1))
                    )
                )
            )
        )
        (make-row
            (lambda (n)
                (with-state
                    (translate (vector 0 (+ 0.1 n) 0))
                    (make-line 16)
                    (make-line -16)
                )
                (unless (zero? n)
                    (if (positive? n)
                        (make-line (- n 1))
                        (make-line (+ n 1))
                    )
                )
            )
        )
        )
        (make-line 16)
        (make-line -16)
    )
)

;(every-frame (mury 1 1))