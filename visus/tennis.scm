(require scheme/list)
;(clear)
;(hint-points)

(define tennis-list (make-hash))

(define tennis-n 15)

(define (tennis-destroy id)
    (when (hash-has-key? tennis-list id)
        (for-each
            (lambda (prim)
                (destroy prim)
            )
            (hash-ref tennis-list id)
        )
    )
    (hash-remove! tennis-list id)
)

(define (tennis-build id)
;(texture (load-texture "neon.png"))
    (hash-set! tennis-list id '())
    (hash-set! tennis-list id (append (hash-ref tennis-list id) (list (build-ribbon tennis-n))))
    (hash-set! tennis-list id (append (hash-ref tennis-list id) (list (build-ribbon tennis-n))))
    (hash-set! tennis-list id (append (hash-ref tennis-list id) (list (build-ribbon tennis-n))))
    (hash-set! tennis-list id (append (hash-ref tennis-list id) (list (build-ribbon tennis-n))))
    (hash-set! tennis-list id (append (hash-ref tennis-list id) (list (build-ribbon tennis-n))))
    (hash-set! tennis-list id (append (hash-ref tennis-list id) (list (build-ribbon tennis-n))))
    (hash-set! tennis-list id (append (hash-ref tennis-list id) (list (build-ribbon tennis-n))))
    (hash-set! tennis-list id (append (hash-ref tennis-list id) (list (build-ribbon tennis-n))))
    (hash-set! tennis-list id (append (hash-ref tennis-list id) (list (build-ribbon tennis-n))))
    (hash-set! tennis-list id (append (hash-ref tennis-list id) (list (build-ribbon tennis-n))))
    (hash-set! tennis-list id (append (hash-ref tennis-list id) (list (build-ribbon tennis-n))))
    (hash-set! tennis-list id (append (hash-ref tennis-list id) (list (build-ribbon tennis-n))))

    (for-each
        (lambda (s)
            (with-primitive s
                (hint-none)
                (hint-solid)
                (hint-vertcols)
                (colour (vector 1 1 1))
                (pdata-index-map!
                    (lambda (i w)
                        (if (= i (- (pdata-size) 2))
                            0.7
                            (* i (/ 0.1 (pdata-size)))
                        )
                    )
                    "w"
                )
            )
        )
        (hash-ref tennis-list id)
    )
)


(define (tennis id cross)
    (let ((g (* (c "gain-low" id) (* (c "gain-high" id) 5))))
        (for-each
            (lambda (n)
                (let*
                    (
                        (prim n)
                        (A (* (c "a" id) 10))
                        (B (* (c "b" id) 10))
                        (C (* (c "c" id) 10))
                        (e (+ (* (c "ecart-low" id) 0.1) (c "ecart-high" id)))
                        (v (* (c "vitesse" id) 5))
                        (freq (* (get-num-frequency-bins) (flxrnd)))
                        (color (+ (c "color-base" id) (* (c "color-large" id) (flxrnd))))
                        (gh-freq (gl freq g))
                    )
                    (with-primitive prim
                        (blur (c "blur" id))
                        (cond
                            ((positive? (c "unlit" id))
                                (hint-unlit))
                            (else
                                (hint-none)
                                (hint-solid)
                                (hint-vertcols)
                            )
                        )
                        (flxseed prim)
                        (identity)
                        (rotate (vmul (vector (* 360 (flxrnd)) (* 360 (flxrnd)) (* 360 (flxrnd))) 1))
                        (rotate (vmul (vector (* 360 (time) (flxrnd)) (* 360 (time) (flxrnd)) (* 360 (time) (flxrnd))) 0.1))

                        (let ((pos-offset (* (flxrnd) (* (c "pos-offset" id) 127))))
                            (pdata-index-map!
                                (lambda (i p)
                                    (vector
                                        (+ (* A (cos (+ (* i e) (* (+ pos-offset (time)) v)))) (* B (cos (* 3 (+ (* i e) (* (+ pos-offset (time)) v))))))
                                        (+ (* A (sin (+ (* i e) (* (+ pos-offset (time)) v)))) (* B (sin (* 3 (+ (* i e) (* (+ pos-offset (time)) v))))))
                                        (* C (sin (* 2 (+ (* i e) (* (+ pos-offset (time)) v)))))
                                    )
                                )
                                "p"
                            )
                        )
                        (pdata-index-map!
                            (lambda (i w)
                                (let*
                                    (
                                        (size (* (* (c "size-body" id) 30) (* i (/ 0.1 (pdata-size)))))
                                    )
                                    (if (= i (- (pdata-size) 2))
                                        (+ (* (c "size-head" id) 5) size)
                                        size
                                    )
                                )
                            )
                            "w"
                        )
                        (pdata-index-map!
                            (lambda (i t)
                                (hsv->rgb
                                    (vector
                                        color
                                        gh-freq
                                        (* i (/ 1 (pdata-size)))
                                        (* 5 (c "opa-along" id) i (/ 1 (* (pdata-size) 1)))
                                    )
                                )
                            )
                            "c"
                        )
                    )
                )
            )
            (hash-ref tennis-list id)
        )
    )
)
