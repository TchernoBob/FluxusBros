(define (corner id cross)
    (with-state
        (letrec
            (
                (mr
                    (lambda (input)
                        (- (* 360 input) 180)
                    )
                )
                (g (c "gain" id #:coeff 2))
                (blur-c (c "blur" id))
                (cs (c "cs" id #:coeff 127))
                (-cs (* -1 cs))
                (ps (+ 1 (c "ps" id #:coeff 127)))
                (hs (+ 1 (c "hs" id #:coeff 127)))
                (cs2 (c "cs2" id #:coeff 127))
                (-cs2 (* -1 cs2))
                (ps2 (+ 1 (c "ps2" id #:coeff 127)))
                (hs2 (+ 1 (c "hs2" id #:coeff 127)))
                (R1 (c "R1" id #:coeff 127))
                (R2 (c "R2" id #:coeff 127))
                (R3 (c "R3" id #:coeff 127))
                (R4 (c "R4" id #:coeff 127))
                (R5 (c "R5" id #:coeff 127))
                (mr-x (mr (c "mr-x" id)))
                (mr-y (mr (c "mr-y" id)))
                (mr-z (mr (c "mr-z" id)))
                (mr2-x (mr (c "mr2-x" id)))
                (mr2-y (mr (c "mr2-y" id)))
                (mr2-z (mr (c "mr2-z" id)))
                (color (c "colour" id))
                (opa (c "opacity" id))
                (ghp
                    (lambda (freq)
                        (if (= freq 16)
                            (gh2 15 g)
                        (if (= freq 1)
                            (gh2 2 g)
                            (gh2 freq g)))))
                (create-corner
                    (lambda (s h)
                        (rotate (vector 0 -180 -90))
                        (create-edge 16 1 s h)
                        (rotate (vector 90 90 0))
                        (create-edge 16 1 s h)
                        (rotate (vector 90 90 0))
                        (create-edge 16 1 s h)
                    )
                )
                (create-corner2
                    (lambda (s h)
                        (rotate (vector 0 180 90))
                        (create-edge 16 1 s h)
                        (rotate (vector -90 -90 0))
                        (create-edge 16 1 s h)
                        (rotate (vector -90 -90 0))
                        (create-edge 16 1 s h)
                    )
                )
                (create-edge
                    (lambda (n i s h)
                        (push)
                        (translate (vector (* i s) 0 0))
                        (translate (vector 0 (* 0.5 (* h (ghp i))) 0))
                        (scale (vector s (* h (ghp i)) 1))
                ;        (scale (vector s (* (ghp i) 1)))
                        (colour (vmul (vector (gh2 1 g) (ghp i) (gh2 12 g)) color))
                        (opacity (opa-cross opa))
                        (draw-cube)
                        (pop)
                        (if (= n i)
                            #t
                            (create-edge n (+ i 1) s h)
                        )
                    )
                )
            )
    ;(hint-ignore-depth)
            (cond ((= (c "hint-solid" id) 0)
                (hint-none)
                (hint-solid))
            (else
                (hint-none)
                (hint-wire)))
            (let* (
                  )
                (with-state
                    (blur blur-c)
                    (when (and (= R1 127) (= R2 0))
                        (rotate (vector (* (time2) mr-x) (* (time2) mr-y) (* (time2) mr-z))))
                    (translate (vector cs2 cs2 cs2))
                    (when (and (= R1 127) (= R2 127))
                        (rotate (vector (* (time2) mr-x) (* (time2) mr-y) (* (time2) mr-z))))
                    (create-corner2 ps2 hs2))
                (with-state
                    (blur blur-c)
                    (when (and (= R1 127) (= R2 0))
                        (rotate (vector (* (time2) mr-x) (* (time2) mr-y) (* (time2) mr-z))))
                    (rotate (vector -90 -180 0))
                    (translate (vector cs2 cs2 cs2))
                    (when (and (= R1 127) (= R2 127))
                        (rotate (vector (* (time2) mr-x) (* (time2) mr-y) (* (time2) mr-z))))
                    (create-corner2 ps2 hs2))
                (with-state
                    (blur blur-c)
                    (when (= R3 127)
                        (rotate (vector (* (time2) mr2-x) (* (time2) mr2-y) (* (time2) mr2-z))))
                    (translate (vector cs cs cs))
                    (when (= R5 127)
                        (rotate (vector (* (time2) mr2-x) (* (time2) mr2-y) (* (time2) mr2-z))))
                    (create-corner ps hs))
                (with-state
                    (blur blur-c)
                    (when (and (= R3 127) (= R4 0))
                        (rotate (vector (* (time2) mr2-x) (* (time2) mr2-y) (* (time2) mr2-z))))
                    (translate (vector -cs cs cs))
                    (rotate (vector 0 -90 0))
                    (when (and (= R5 127) (= R4 0))
                        (rotate (vector (* (time2) mr2-x) (* (time2) mr2-y) (* (time2) mr2-z))))
                    (create-corner ps hs))
                (with-state
                    (blur blur-c)
                    (when (= R3 127)
                        (rotate (vector (* (time2) mr2-x) (* (time2) mr2-y) (* (time2) mr2-z))))
                    (translate (vector -cs -cs cs))
                    (rotate (vector 90 -90 0))
                    (when (= R5 127)
                        (rotate (vector (* (time2) mr2-x) (* (time2) mr2-y) (* (time2) mr2-z))))
                    (create-corner ps hs))
                (with-state
                    (blur blur-c)
                    (when (and (= R3 127) (= R4 0))
                        (rotate (vector (* (time2) mr2-x) (* (time2) mr2-y) (* (time2) mr2-z))))
                    (translate (vector cs -cs cs))
                    (rotate (vector 90 0 0))
                    (when (and (= R5 127) (= R4 0))
                        (rotate (vector (* (time2) mr2-x) (* (time2) mr2-y) (* (time2) mr2-z))))
                    (create-corner ps hs))
                (with-state
                    (blur blur-c)
                    (when (and (= R3 127) (= R4 0))
                        (rotate (vector (* (time2) mr2-x) (* (time2) mr2-y) (* (time2) mr2-z))))
                    (translate (vector -cs -cs -cs))
                    (rotate (vector -90 -90 90))
                    (when (and (= R5 127) (= R4 0))
                        (rotate (vector (* (time2) mr2-x) (* (time2) mr2-y) (* (time2) mr2-z))))
                    (create-corner ps hs))
                (with-state
                    (blur blur-c)
                    (when (= R3 127)
                        (rotate (vector (* (time2) mr2-x) (* (time2) mr2-y) (* (time2) mr2-z))))
                    (translate (vector -cs cs -cs))
                    (rotate (vector 90 -90 -180))
                    (when (= R5 127)
                        (rotate (vector (* (time2) mr2-x) (* (time2) mr2-y) (* (time2) mr2-z))))
                    (create-corner ps hs))
                (with-state
                    (blur blur-c)
                    (when (= R3 127)
                        (rotate (vector (* (time2) mr2-x) (* (time2) mr2-y) (* (time2) mr2-z))))
                    (translate (vector cs -cs -cs))
                    (rotate (vector -90 90 0))
                    (when (= R5 127)
                        (rotate (vector (* (time2) mr2-x) (* (time2) mr2-y) (* (time2) mr2-z))))
                    (create-corner ps hs))
                (with-state
                    (blur blur-c)
                    (when (and (= R3 127) (= R4 0))
                        (rotate (vector (* (time2) mr2-x) (* (time2) mr2-y) (* (time2) mr2-z))))
                    (translate (vector cs cs -cs))
                    (rotate (vector -90 0 0))
                    (when (and (= R5 127) (= R4 0))
                        (rotate (vector (* (time2) mr2-x) (* (time2) mr2-y) (* (time2) mr2-z))))
                    (create-corner ps hs))
            )
        )
    )
)
