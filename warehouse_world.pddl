(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )

   (:action robotMove
      :parameters (?r - robot ?old - location ?new location)
      :precondition (and (at ?r ?old) (connected ?old ?new) (no-robot ?new))
      :effect (and (at ?r ?new) (no-robot ?old) (not (no-robot ?new)) (not (at ?r ?old))
   )

   (:action robotMoveWithPallette
      :parameters (?r - robot ?old - location ?new - location ?p - pallette)
      :precondition (and (at ?r ?old) (at ?p ?old) (connected ?old ?new) (no-robot ?new) (no-pallette ?new))
      :effect (and (at ?r ?new) (no-robot ?old) (at ?p ?new) (no-pallette ?old) (not (at ?p ?old)) (not (no-pallette ?new)) (not (no-robot ?new)) (not (at ?r ?old)))
   )

   (:action moveItemFromPalletteToShipment
      :parameters (?si - saleitem ?p - pallette ?s - shipment ?o - order ?l - location)
      :precondition (and (at ?p ?l) (packing-at ?s ?l) (not (complete ?s)) (contains ?p ?si) (ships ?s ?o) (orders ?o ?si))
      :effect (and (includes ?s ?si) (not (contains ?p ?si)))
   )

   (:action completeShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (started ?s) (not (complete ?s)) (ships ?s ?o) (packing-at ?s ?l))
      :effect (and (complete ?s) (available ?l))
   )


)
