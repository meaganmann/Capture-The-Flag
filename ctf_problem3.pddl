; Field is bigger and more portals
; Strong cyclic solution found, map is HUGE

(define (problem capture-flag-competitive-big-field)
  (:domain capture-flag)

  (:objects
    red blue - team
    red1 red2 blue1 blue2 - agent
    flagR flagB - flag

    ; Expanded map
    rloc1 rloc2 rloc3 rloc4
    bloc1 bloc2 bloc3 bloc4
    mid1 mid2
    baseR baseB - location
  )

  (:init

    (connected baseR rloc1)
    (connected rloc1 baseR)

    (connected rloc1 rloc2)
    (connected rloc2 rloc1)

    (connected rloc2 rloc3)
    (connected rloc3 rloc2)

    (connected rloc3 rloc4)
    (connected rloc4 rloc3)

    (connected rloc4 mid1)
    (connected mid1 rloc4)

    (connected baseB bloc1)
    (connected bloc1 baseB)

    (connected bloc1 bloc2)
    (connected bloc2 bloc1)

    (connected bloc2 bloc3)
    (connected bloc3 bloc2)

    (connected bloc3 bloc4)
    (connected bloc4 bloc3)

    (connected bloc4 mid2)
    (connected mid2 bloc4)

    (connected mid1 mid2)
    (connected mid2 mid1)

    (portal rloc1)
    (portal rloc3)
    (portal bloc2)
    (portal bloc4)
    (portal mid1)
    (portal mid2)

    (member-of red1 red)
    (member-of red2 red)
    (member-of blue1 blue)
    (member-of blue2 blue)

    (flag-belongs-to flagR red)
    (flag-belongs-to flagB blue)
    (base-belongs-to baseR red)
    (base-belongs-to baseB blue)

    (safe-zone red baseR)
    (safe-zone red rloc1)
    (safe-zone red rloc2)

    (safe-zone blue baseB)
    (safe-zone blue bloc1)
    (safe-zone blue bloc2)

    (base baseR red)
    (base baseB blue)

    (at red1 baseR)
    (at red2 baseR)
    (at blue1 baseB)
    (at blue2 baseB)

    (maybe-tagged red1)
    (maybe-tagged red2)
    (maybe-tagged blue1)
    (maybe-tagged blue2)

    (flag-at flagR baseR)
    (flag-at flagB baseB)

    (= (total-cost) 0)
  )

  (:goal
    (and
      (flag-captured red)  ; Blue captures the red flag
      (flag-captured blue) ; Red also must capture blue’s
    )
  )

  (:metric minimize (total-cost))
)
