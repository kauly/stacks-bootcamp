;; Owner
(define-constant contract-owner tx-sender)

;; Errors
(define-constant err-owner-only  (err u100))
(define-constant err-already-locked  (err u101))
(define-constant err-more-votes-than-members-required  (err u102))
(define-constant err-not-a-member  (err u103))
(define-constant err-votes-required-not-met  (err u104))

;; Variables
(define-data-var members (list 100 principal) (list))
(define-data-var votes-required uint u1)
(define-map votes { member: principal, recipient: principal } { decision: bool })


(define-private (tally (member principal) (acc uint))
    (if (get-vote member tx-sender) (+ acc u1) acc)
)

(define-public (start (new-members (list 100 principal)) (new-votes-required uint))
    (begin
        (asserts! (is-eq tx-sender contract-owner) err-owner-only)
        (asserts! (is-eq (len (var-get members)) u0) err-already-locked)
        (asserts! (>= (len new-members) new-votes-required) err-more-votes-than-members-required)
        (var-set members new-members)
        (var-set votes-required new-votes-required)
        (ok true)
    )
)

(define-public (vote (recipent principal) (decision bool))
    (begin
        (asserts! (is-some (index-of (var-get members) tx-sender)) err-not-a-member)
        (ok (map-set votes {member: tx-sender, recipient: recipent } {decision: decision}))
    )
)

(define-public (withdraw)
    (let 
        (
            (recipient tx-sender)
            (total-votes (tally-votes))
        )
        (asserts! (>= total-votes (var-get votes-required)) err-votes-required-not-met)
        (try! (as-contract (stx-transfer? (stx-get-balance tx-sender) tx-sender recipient)))
        (ok total-votes)
    )
)

(define-public (deposit (amount uint))
    (stx-transfer? amount tx-sender (as-contract tx-sender))
)

(define-read-only (get-vote (member principal) (recipent principal))
    (default-to false (get decision (map-get? votes {member: member, recipient: recipent})))
)

(define-read-only (tally-votes)
    (fold tally  (var-get members) u0)
)

