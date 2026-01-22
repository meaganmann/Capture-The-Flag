; first problem instance the portals are at rloc1 and bloc2, everyone starts at own base with home flag
; strong cyclic solution found

(define (problem capture-flag-competitive)
  (:domain capture-flag)

  (:objects
    red blue - team
    red1 red2 blue1 blue2 - agent
    flagR flagB - flag
    rloc1 rloc2 bloc1 bloc2 baseR baseB - location
  )

  (:init
    ; Playing feild
    (connected rloc1 rloc2)
    (connected rloc2 rloc1)
    (connected rloc1 baseR)
    (connected baseR rloc1)
    (connected rloc2 baseR)
    (connected baseR rloc2)

    (connected rloc1 bloc1)
    (connected bloc1 rloc1)
    (connected rloc2 bloc2)
    (connected bloc2 rloc2)

    (connected bloc1 bloc2)
    (connected bloc2 bloc1)
    (connected bloc1 baseB)
    (connected baseB bloc1)
    (connected bloc2 baseB)
    (connected baseB bloc2)

    ; Portals
    (portal rloc1)
    (portal bloc2)



    ; Teams
    (member-of red1 red)
    (member-of red2 red)
    (member-of blue1 blue)
    (member-of blue2 blue)

    ; Belongings
    (flag-belongs-to flagR red)
    (flag-belongs-to flagB blue)
    (base-belongs-to baseR red)
    (base-belongs-to baseB blue)

    ; Red's safe zones
    (safe-zone red baseR)
    (safe-zone red rloc1)
    (safe-zone red rloc2)

    ; Blue's safe zones
    (safe-zone blue baseB)
    (safe-zone blue bloc1)
    (safe-zone blue bloc2)

    ; Bases
    (base baseR red)
    (base baseB blue)

    ; Starting positions
    (at red1 baseR)
    (at red2 baseR)
    (at blue1 baseB)
    (at blue2 baseB)

    ; All players start maybe-tagged
    (maybe-tagged red1)
    (maybe-tagged red2) 
    (maybe-tagged blue1)
    (maybe-tagged blue2)

    ; Flag placements
    (flag-at flagR baseR)
    (flag-at flagB baseB) 

    ; Costs
    (= (total-cost) 0)
  )

  ; Goal: Each team captures the opponent’s flag
  (:goal
    (and
      (flag-captured red) ; Blue team brought red flag to blue base
      (flag-captured blue) ; Red team brought blue flag to red base
    )
  )

  (:metric minimize (total-cost))
)
