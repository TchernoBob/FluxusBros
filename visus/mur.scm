(define (mur id cross)
    (with-state
    (translate (vector 0 0 -30))
    (let
        (
            (g (c "gain-a" id #:coeff 10))
            (blur-control (c "blur" id))
            (clr-coeff (c "clr-coeff" id #:coeff 0.1))
            (scale-gh-y-incomplete-coeff (c "scale-gh-y-incomplete-coeff" id #:coeff 10))
            (scale-x (+ 0.001 (c "scale-x" id)))
            (scale-x-gh (c "scale-x-gh" id))
            (scale-z (+ 0.001 (c "scale-z" id)))
            (scale-z-gh (c "scale-z-gh" id))
            (trans-x-gh (c "trans-x-gh" id))
            (trans-x-freq (c "trans-x-gh-freq" id))
            (trans-y-gh (c "trans-y-gh" id))
            (trans-y-freq (c "trans-y-gh-freq" id))
            (L-X (c "R-L-X" id #:coeff 10))
            (L-Y (c "R-L-Y" id #:coeff 10))
            (L-Z (c "R-L-Z" id #:coeff 10))
            (Block-L-X (c "blok-R-L-X" id))
            (Block-L-Y (c "blok-R-L-Y" id))
            (Block-L-Z (c "blok-R-L-Z" id))
            (G-X (c "R-G-X" id #:coeff 200))
            (G-Y (c "R-G-Y" id #:coeff 200))
            (Block-G-X (c "blok-R-G-X" id))
            (Block-G-Y (c "blok-R-G-Y" id))

            (i (* (get-num-frequency-bins) (c "Number-bins-x" id)))
        )
        (letrec
            (
                (draw-row
                    (lambda (sens-h sens-v count count-line)
                        (push)
;(hint-normalise)
                            (colour (vmul (vector (gl 1 g) (gl count g) (gl count g)) clr-coeff))
;                            (colour (vmul (vector (gl 1 g) (min 2 (gl count g)) (gl count g)) clr-coeff))
                            (translate (vector (* (* sens-h 1.2) count) 0 0)) ; move a little in x
                            (translate (vector 0 (* (* sens-v 1.2) count-line) 0))

                            (if (<= count 0)
                                (scale (vector 1 1 (+ 1 (* (gl 1 g) scale-gh-y-incomplete-coeff))))
                                (if (= count 16)
                                    (scale (vector 1 1 (+ 1 (* (gl 15 g) scale-gh-y-incomplete-coeff))))
                                    (scale (vector 1 1 (+ 1 (* (gl count g) scale-gh-y-incomplete-coeff))))
                                )
                            )
    
                            (scale (vector (/ scale-x (+ 1 (* (gl count g) scale-x-gh))) (/ scale-z (+ 1 (* (gl count g) scale-z-gh))) 1))
                            (translate (vector (* count (* sens-h (* trans-x-gh (gl (* 16 trans-x-freq) g)))) (* (* count count) (* sens-v (* trans-y-gh (gl (* 16 trans-y-freq) g)))) 0))
                            (draw-cube)
                        (pop)
                        (if (<= count 0)            ; if the count argument is 0
                            0                        ; return 0 (doesn't matter what we return) & exit
                            (draw-row sens-h sens-v (- count 1) count-line) ; otherwise call render again with count - 1 & exit 
                        )
                    )
                )
                (draw-line
                    (lambda (count-line count-row)
                        (rotate (vector (tempo (string-append id "-" "mur-L-X") L-X) (tempo (string-append id "-" "mur-L-Y") L-Y) (tempo (string-append id "-" "mur-L-Z") L-Z)))
                        (when (positive? Block-L-X)
                            (tempo (string-append id "-" "mur-L-X") null 0))
                        (when (positive? Block-L-Y)
                            (tempo (string-append id "-" "mur-L-Y") null 0))
                        (when (positive? Block-L-Z)
                            (tempo (string-append id "-" "mur-L-Z") null 0))
    
                        (cond
                            ((<= count-line 0)
                                (draw-row -1 0 count-row count-line)
                                (draw-row 1 0 count-row count-line)
                            )
                            (else
                                (draw-row -1 1 count-row count-line)
                                (draw-row 1 1 count-row count-line)
                                (draw-row -1 -1 count-row count-line)
                                (draw-row 1 -1 count-row count-line)
                                (draw-line (- count-line 1) count-row)
                            )
                        )
                    )
                )
            )

            (hint-none)
            (hint-solid)
            (blur blur-control)
;            (opacity  cross)

            (rotate (vector (tempo (string-append id "-" "mur-G-X") G-X) (* (tempo (string-append id "-" "mur-G-X") G-X) 0.98751) (tempo (string-append id "-" "mur-G-Y") G-Y)))
            (when (positive? Block-G-X)
                (tempo (string-append id "-" "mur-G-X") null 0))
            (when (positive? Block-G-Y)
                (tempo (string-append id "-" "mur-G-Y") null 0))
            (draw-line i i)
        )
    )
    )
)