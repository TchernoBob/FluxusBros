;(require mzlib/string)
;(clear)
;(video-clear-cache)

(define-struct dcub (pos (size #:mutable) color opa))
(define-struct dcubs (dcubes) #:mutable)

(define dc (make-dcubs (list (make-dcub (vector 0 0 0) (vector 1 1 1) (vector 0 0 0) 0.2))))

;(define (dancing-cubes chann cross)
(define (dancing-cubes id cross)
    (define (get-sens i size sizep cpt)
        (let
            (
                (rndX (*    (+ (vector-ref (dcub-pos (list-ref (dcubs-dcubes dc) i)) 0)
                                (* 0.5 (vector-ref size 0))
                                (* 0.5 (vector-ref sizep 0)))
                            (* 2 (- (round (flxrnd)) 1))))
                (rndY (*    (+ (vector-ref (dcub-pos (list-ref (dcubs-dcubes dc) i)) 1)
                                (* 0.5 (vector-ref size 1))
                                (* 0.5 (vector-ref sizep 0)))
                            (* 2 (- (round (flxrnd)) 1))))
            )
            (if (> (vmag
                        (vadd
                            (dcub-pos (list-ref (dcubs-dcubes dc) i))
                            (vector rndX rndY 0)
                        )
                    )
                    (+ (* (c "45" id) 30) 1))
                (cond
                    ((< cpt 20)
                        (get-sens i size sizep (add1 cpt)))
                    (else
                        (get-sens i (vmul size -1) (vmul sizep -1) (add1 cpt))
                    )
                )
                (vector rndX rndY 0)
            )
        )
    )

    (let ((g (* (c "gain-a" id) (* (c "gain-b" id) 10))))
(push)
    (blur (c "blur" id))
    (flxseed (inexact->exact (floor (gl 1 g))))
    (hint-depth-sort)
    (blend-mode 'src-alpha 'one-minus-src-alpha)
    (translate (vector 0 0 -20))
    (rotate (vmul (vector (* 60 (cos (* 0.6 (time)))) (* 60 (sin (* 1 (time)))) (* 10 (time))) (* (c "rotation" id) 5)))
    (for ((i (build-list (length (dcubs-dcubes dc)) values))
            #:when (< i (length (dcubs-dcubes dc))))
        (let ((cube (list-ref (dcubs-dcubes dc) i))
              (cubep (unless (zero? i) (list-ref (dcubs-dcubes dc) (sub1 i))))
              (cube0 (list-ref (dcubs-dcubes dc) 0)))
            (push)
                (translate (vadd (dcub-pos cube) (vector 0 0 (* -0.1 (vector-ref (dcub-size cube) 0)))))
                (opacity (dcub-opa cube))
                (colour(hsv->rgb  (dcub-color cube)))
                (scale (dcub-size cube))
                (draw-cube)
            (pop)
        )
    )

    (let ((max-cubes (+ (inexact->exact (floor (* (c "speed" id) 400))) 1)))
        (when (> (length (dcubs-dcubes dc)) max-cubes)
            #(for ((i (build-list (- (length (dcubs-dcubes dc)) max-cubes) values)))
                (destroy (dcub-prim (list-ref (dcubs-dcubes dc) i)))
            )
            (set-dcubs-dcubes! dc (list-tail (dcubs-dcubes dc) (- (length (dcubs-dcubes dc)) max-cubes)))
        )
    )

    (for ((i (build-list 14 (lambda (x) (+ x 2))))
            #:when (> (gl i g) (* (c "47" id) 10)))
        (let*
            (
                (cubep (sub1 (length (dcubs-dcubes dc))))
                (color (vector (- (/ i 20) 0.1) (* 1 (gl i g)) (* 1 (gl i g))))
                (opa (+ 0.2 (* (gl i g) (* (c "opa-gh" id) 1))))
                (size (vmul (vector (gl i g) (gl (+ 0 i) g) (* (gl (+ 5 i) g) (+ 1 (* (c "scale-gh-z" id) 5)))) (* (c "scale-gh" id) 1)))
                (sizep (dcub-size (list-ref (dcubs-dcubes dc) (sub1 (length (dcubs-dcubes dc))))))
                (sens (get-sens cubep size sizep 0))
                (place
                    (unless (void? sens)
                        (vadd
                            (dcub-pos (list-ref (dcubs-dcubes dc) cubep))
                            sens
                        )
                    )
                )
            )
            (unless (void? sens)
                (set-dcubs-dcubes! dc (append (dcubs-dcubes dc) (list (make-dcub place size color opa))))
            )
        )
    )
(pop)
)
)

;(every-frame (dancing-cubes))
