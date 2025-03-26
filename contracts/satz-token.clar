;; SATZ Governance and Rewards Token Contract

;; Tokenomic Constants
(define-constant TOTAL_SUPPLY u1000000000)  ;; 1 billion total supply
(define-constant TREASURY 'SP3D1VC4WBM939SA65CTHS7HEVF8GJA6N9Y2APJWV)  ;; Treasury wallet

;; Token Metadata
(define-constant TOKEN_NAME "Bitcoin Labz")     ;; Human-readable token name
(define-constant TOKEN_SYMBOL "SATZ")            ;; Ticker symbol
(define-constant TOKEN_URI "https://raw.githubusercontent.com/Bitcoinlabz/SATZ-Smart-Contract-test/main/metadata/satz-metadata.json") ;; Metadata URI pointing to a JSON file with token details
(define-constant TOKEN_DECIMALS u6)              ;; Token decimals (e.g., u6 means 1 token = 1,000,000 units)

;; SIP-010 Compliance Implementation
(define-fungible-token SATZ TOTAL_SUPPLY)

;; Token Metadata Access Functions
(define-read-only (get-token-uri)
  (ok TOKEN_URI))

(define-read-only (get-name)
  (ok TOKEN_NAME))

(define-read-only (get-symbol)
  (ok TOKEN_SYMBOL))

(define-read-only (get-decimals)
  (ok TOKEN_DECIMALS))

(define-read-only (get-total-supply)
  (ok TOTAL_SUPPLY))

;; Data Variables
(define-data-var circulating-supply uint u0)  ;; Track minted tokens

;; Governance address (fixed, same as treasury in this case)
(define-constant GOVERNANCE 'SP3D1VC4WBM939SA65CTHS7HEVF8GJA6N9Y2APJWV)

;; Mint Function (only for initial supply to treasury)
(define-public (mint-initial-supply)
  (begin
    ;; Only governance can mint the initial supply.
    (asserts! (is-eq tx-sender GOVERNANCE) (err u100))
    ;; Ensure that minting happens only once.
    (asserts! (is-eq (var-get circulating-supply) u0) (err u101))
    (var-set circulating-supply TOTAL_SUPPLY)
    (asserts! (is-ok (ft-mint? SATZ TOTAL_SUPPLY TREASURY)) (err u102))
    (ok true)
  ))

;; External Project Reward Distribution Compatibility
(define-public (distribute-reward (amount uint) (recipient principal))
  (begin
    ;; Only governance can distribute rewards.
    (asserts! (is-eq tx-sender GOVERNANCE) (err u103))
    (asserts! (is-ok (ft-transfer? SATZ amount TREASURY recipient)) (err u104))
    (ok true)
  ))

;; Read-only Balance Lookup
(define-read-only (get-balance (owner principal))
  (ok (ft-get-balance SATZ owner)))
