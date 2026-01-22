
(define (domain capture-flag)
  (:requirements :strips :typing :adl :conditional-effects :negative-preconditions :non-deterministic :action-costs :equality)

  (:types
    agent location flag team
  )

  (:predicates
    (at ?a - agent ?l - location)
    (connected ?l1 - location ?l2 - location)
    (flag-at ?f - flag ?l - location)
    (holding ?a - agent ?f - flag)
    (maybe-tagged ?a - agent)
    (tagged ?a - agent)
    (flag-belongs-to ?f - flag ?t - team)
    (base-belongs-to ?l - location ?t - team)
    (member-of ?a - agent ?t - team)
    (safe-zone ?t - team ?l - location)
    (flag-captured ?t - team) 
    (portal ?loc - location)

  )

  (:functions
    (total-cost)
  )

  ; Players can move to any connected location on the feild as long as not tagged (or maybe-tagged)
  (:action move

    :parameters (?a - agent ?from - location ?to - location)

    :precondition (and
      (at ?a ?from)
      (connected ?from ?to)
      (not (tagged ?a))
      (not (maybe-tagged ?a))
    )

    :effect (and
      (not (at ?a ?from))
      (at ?a ?to)
      (increase (total-cost) 1)
    )
  )


  ; Can only be tagged by opposing team
  (:action tag

    :parameters (?a1 - agent ?a2 - agent ?loc - location ?base - location ?f - flag ?t1 - team ?t2 - team) 

    :precondition (and
      (at ?a1 ?loc)
      (at ?a2 ?loc)
      (maybe-tagged ?a2)

      (member-of ?a1 ?t1)
      (member-of ?a1 ?t2)
      (flag-belongs-to ?f ?t1)
      (base-belongs-to ?base ?t1)
    )

    :effect (and
        (not (maybe-tagged ?a2))

        (oneof
            ; tagged
            (and 
              (tagged ?a2)
              ; if tagged player is holding flag, it get returned to its base
              (when (holding ?a2 ?f) 
                (and
                  (not (holding ?a2 ?f))
                  (flag-at ?f ?base)
                )
              )
            )
            ; not tagged
            (not (tagged ?a2))
        )

        (increase (total-cost) 0)
    )
  )



  ; Can only pick up enemy flag when not in safe zone
  (:action pickup-flag 

    :parameters (?a - agent ?f - flag ?loc - location ?t1 - team ?t2 - team)

    :precondition (and
      (at ?a ?loc)
      (flag-at ?f ?loc)
      (not (tagged ?a))
      (not (holding ?a ?f))

      (member-of ?a ?t1)
      (flag-belongs-to ?f ?t2)
      (not (safe-zone ?t1 ?loc))
    )

    :effect (and
      (not (flag-at ?f ?loc))
      (holding ?a ?f)
      (increase (total-cost) 1)
    )
  )

  ; Must be at same location and on same team to untag
  (:action untag

    :parameters (?a - agent ?mate - agent ?loc - location ?t - team)

    :precondition (and
      (at ?a ?loc)
      (at ?mate ?loc)
      (member-of ?a ?t)
      (member-of ?mate ?t)

      (not (tagged ?a))
      (tagged ?mate)
    )
    :effect (and
      (not (tagged ?mate))
      (increase (total-cost) 0)
    )
  )


  ; Fog resets the maybe-tagged status of all tagged players
  (:action fog-covers-field

    :parameters ()

    :precondition (and)

    :effect (and
      (forall
          (?players -agent)
          (and 
            (not (tagged ?players)) 
            (maybe-tagged ?players)
          )
      )

      (increase (total-cost) 1)
    )
  )

  ; Fall into a portal and land anywhere in the feild
  ; There are unsafe portals which reset your maybe-tagged status
  (:action fall-into-portal
    :parameters (?a - agent ?p - location)
    :precondition (and
      (at ?a ?p)
      (portal ?p)
      (not (tagged ?a))
    )
    :effect (and
      (not (at ?a ?p))

      (oneof
        ; Safe portal
        (oneof
          (at ?a rloc1)
          (at ?a rloc2)
          (at ?a bloc1)
          (at ?a bloc2)
          (at ?a baseR)
          (at ?a baseB)
        )

        ; Unsafe portal, maybe-tagged status reset
        (oneof
          (and (maybe-tagged ?a) (at ?a rloc1))
          (and (maybe-tagged ?a) (at ?a rloc2))
          (and (maybe-tagged ?a) (at ?a bloc1))
          (and (maybe-tagged ?a) (at ?a bloc2))
          (and (maybe-tagged ?a) (at ?a baseR))
          (and (maybe-tagged ?a) (at ?a baseB))
        )
      )
      
      (increase (total-cost) 0)
    )
  )

  
  ; Can only capture enemy flag by bringing it to your own base
  (:action capture-flag

    :parameters (?a - agent ?f - flag ?base - location ?t1 - team ?t2 - team)

    :precondition (and
      (at ?a ?base)
      (holding ?a ?f)
      (not (tagged ?a))
      (not (maybe-tagged ?a))
      
      (member-of ?a ?t1)
      (flag-belongs-to ?f ?t2)
      (base-belongs-to ?base ?t1)
    )

    :effect (and
      (flag-captured ?t1)
      (not (holding ?a ?f))
      (increase (total-cost) 5)
    )
  )
)


(:action robber_move
  :parameters (?x ?y - location)
  :precondition (and 
    (at rob1 ?x)
    (edge ?x ?y)
    (forall (?c - cop) (not (turn ?c)))
  )
  :effect (and
    (when (exists (?c - cop) (at ?c ?y) (caught)))
    ; should this be above? Like robber moves to adjacent vertex and then if cop there its caught
    (not (at rob1 ?x))
    (at rob1 ?y) 

    (when (move0) ; move0 indocates robbers turn?
      (and (not moveK) (move1)) ; counts how many turns the robber makes throughout determining k or is this just for variable robber
    )

    (when (moveK) ; now cops turn cuz no more moves if 1=k then no variable robber
      (and (not moveK) (forall (?c - cop) (turn ?c)))
    )

    (oneof (survived) (nil))
  )

)

(:action cop_move
  :parameters (?c - cop)
  :precondition (and 
    (turn ?c)
    (at ?c node2)
  )
  :effect (and 
    (not (turn ?c))
    (move0) ;from robber turn?
    (not (at ?c node2))
    (oneof
      (and 
        (at ?c node1)
        (when (at rob1 node1) (caught))
      )

      (and 
        (at ?c node3)
        (when (at rob1 node3) (caught))
      )
    )
  )
)

(:action terminate
  :parameters ()
  :precondition (and 
    (survived)
    (not caught)
  )
  :effect (and 
    (done)
  )
)
