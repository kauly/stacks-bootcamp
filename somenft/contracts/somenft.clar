(impl-trait .sip009-nft-trait.sip009-nft-trait)

(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))


(define-non-fungible-token somenft uint)
(define-data-var last-token-id uint u0)

(define-read-only (get-last-token-id)
    (ok (var-get last-token-id))
)

(define-read-only (get-token-uri (token-id uint))
    (ok none)
)

(define-read-only (get-owner (token-id uint))
    (ok (nft-get-owner? somenft token-id))
)

(define-public (transfer (token-id uint) (sender principal) (recipient principal))
    (begin
        (asserts! (is-eq sender tx-sender) err-owner-only)
        (nft-transfer? somenft token-id sender recipient)
    )
)

(define-public (mint (recipient principal))
    (let 
        (
            (token-id (+ (var-get last-token-id) u1))
        ) 
        (asserts! (is-eq tx-sender contract-owner) err-owner-only)
        (try! (nft-mint? somenft token-id recipient))
        (var-set last-token-id token-id)
        (ok token-id)
    )
)